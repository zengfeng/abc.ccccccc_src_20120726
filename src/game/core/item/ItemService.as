package game.core.item {
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.equipable.EquipableItem;
	import game.core.item.equipment.Equipment;
	import game.core.item.gem.Gem;
	import game.core.item.gem.GemSlot;
	import game.core.item.pile.PileItem;
	import game.core.item.soul.Soul;
	import game.core.item.sutra.Sutra;
	import game.core.user.StateManager;
	import game.manager.SignalBusManager;
	import game.net.core.Common;
	import game.net.data.CtoS.CSEquipChange;
	import game.net.data.CtoS.CSGemMergeAll;
	import game.net.data.CtoS.CSMergeSoul;
	import game.net.data.CtoS.CSMergeSoulAll;
	import game.net.data.StoC.EquipAttribute;
	import game.net.data.StoC.SCGemChange;
	import game.net.data.StoC.SCItemChange;
	import game.net.data.StoC.SCItemList;
	import game.net.socket.SocketClient;

	import log4a.Logger;

	/**
	 * @author jian
	 */
	public class ItemService {
		// =====================
		// @单例
		// =====================
		private static var __instance : ItemService;

		public static function get instance() : ItemService {
			if (!__instance) __instance = new ItemService();

			return __instance;
		}

		public function ItemService() {
			if (__instance) throw (Error("单例错误!"));

			__instance = this;

			_itemManager = ItemManager.instance;
		}

		// =====================
		// @属性
		// =====================
		private var _itemManager : ItemManager;
		private var _server : SocketClient;

		// =====================
		// @方法
		// =====================
		/*
		 * 连接Socket服务器
		 */
		public function connect(server : SocketClient) : void {
			_server = server;
			_server.addCallback(0x200, onRecvItemList);
			_server.addCallback(0x203, onRecvItemChange);
			_server.addCallback(0x205, onRecvGemChange);
		}

		/*
		 * 断开Socket服务器
		 */
		public function disconnect() : void {
			if (_server) {
				_server.removeCallback(0x200, onRecvItemList);
				_server.removeCallback(0x203, onRecvItemChange);
				_server.removeCallback(0x205, onRecvGemChange);
			}
		}

		/*
		 * 物品列表数据包
		 */
		private function onRecvItemList(msg : SCItemList) : void {
			var roll:Boolean = msg.hint == 1;
			for each (var key:uint in msg.items) {
				processCommonItemChange(key, roll);
			}

			for each (var attr:EquipAttribute in msg.equipments) {
				if (attr.uniqueID > 30000 && attr.uniqueID < 100000)
					processSutraChange(attr);
				else
					processEquipItemChange(attr, roll);
			}
			_itemManager.notifyChange();
		}

		/*
		 * 物品改变数据包
		 */
		private function onRecvItemChange(msg : SCItemChange) : void {
			for each (var attr:EquipAttribute in msg.equipment) {
				if (attr.uniqueID > 30000 && attr.uniqueID < 100000)
					processSutraChange(attr);
				else
					processEquipItemChange(attr);
			}
			_itemManager.notifyChange();
		}

		public static function createItem(value : uint) : Item {
			var id : uint = value & 0x7FFF;
			var num : uint = (value & 0x7FFF0000) >> 16;
			var binding : Boolean = (value >> 15 & 0x1) != 0;
			var item : Item = ItemManager.instance.newItem(id, binding);
			if (!item) {
				Logger.error("后台的发的物品value=" + value + " 前台没法解析!");
				return null;
			}
			item.nums = num;
			return item;
		}

		/*
		 * 处理物品改变
		 */
		private function processCommonItemChange(key : uint, roll:Boolean = false) : void {
			var id : uint = key & 0x7FFF;
			var num : uint = (key & 0xFFFF0000) >>> 16;
			var binding : Boolean = (key >> 15 & 0x1) != 0;

			var item : PileItem = _itemManager.getPileItemWithBinding(id, binding);

			if (!item) {
				if (num > 0) {
					var tempItem : Item = ItemManager.instance.newItem(id);
					// ViewManager.instance.rollMessage("获得  " + tempItem.htmlName + "×" + num);
					if (roll) StateManager.instance.checkMsg(163, null, null, [tempItem.id, num]);
					_itemManager.addPileItem(id, binding, num);
				}
			} else if (num == 0) {
				if (item) {
					if (roll) StateManager.instance.checkMsg(269, null, null, [item.id, item.nums]);
					// ViewManager.instance.rollMessage("消耗  " + item.htmlName + "×" + item.nums);
					_itemManager.removePileItem(id, binding);
				}
			} else {
				if (roll) {
					var changNum : int = num - item.nums;
					if (changNum > 0) {
						StateManager.instance.checkMsg(163, null, null, [item.id, changNum]);
						// ViewManager.instance.rollMessage("获得  " + item.htmlName + "×" + changNum);
					} else {
						StateManager.instance.checkMsg(269, null, null, [item.id, Math.abs(changNum)]);
						// ViewManager.instance.rollMessage("消耗  " + item.htmlName + "×" + Math.abs(changNum));
					}
				}
				_itemManager.setPileItemNum(id, binding, num, roll);
			}
		}

		/*
		 * 处理装备改变
		 */
		private function processEquipItemChange(attr : EquipAttribute, roll:Boolean = false) : void {
			var key : uint = attr.typeID;
			var uuid : uint = attr.uniqueID;
			var id : uint = key & 0x7FFF;
			var num : uint = (key & 0xFFFF0000) >>> 16;
			var binding : Boolean = (key >> 15 & 0x1) != 0;

			var item : EquipableItem = _itemManager.getEquipableItem(uuid);
			var isNew : Boolean = (item == null);
			var isHero : Boolean = false;
			var pos : int;
			var heroId : uint;

			if (attr.hasPosition) {
				var posKey : uint = attr.position >>> 16;
				heroId = attr.position & 0xFFFF;
				pos = ((posKey & 0x8000) != 0) ? (posKey & 0x7FFF) : -1;

				if (heroId != 0)
					isHero = true;
			}

			if (num == 0) {
				if (item) {
					_itemManager.removeEquipableItem(uuid);
					if (roll) StateManager.instance.checkMsg(269, null, null, [item.id, 1]);
					// ViewManager.instance.rollMessage("失去  " + item.htmlName + "×" + 1);
				}
				return;
			}

			if (!item) {
				_itemManager.addEquipableItem(id, uuid, binding, isHero);
				item = _itemManager.getEquipableItem(uuid);
				if (roll) StateManager.instance.checkMsg(163, null, null, [item.id, 1]);
				// ViewManager.instance.rollMessage("得到  " + item.htmlName + "×" + 1);
			} else {
				_itemManager.setEquipableItemBinding(uuid, binding);
			}

			if (attr.hasEnchantlv) {
				if (item is Equipment) {
					_itemManager.changeEnhanceLevel(uuid, attr.enchantlv);
				} else if (item is Soul) {
					_itemManager.changeSoulExp(uuid, attr.enchantlv);
				}
			}

			if (attr.hasPosition) {
				if (isHero)
					_itemManager.equipEquipableItem(uuid, heroId, posKey, isNew);
				else
					_itemManager.moveEquipableItemToPack(uuid, pos);
			}
		}

		private function processSutraChange(attr : EquipAttribute) : void {
			if (attr.hasEnchantlv) {
				var sutra : Sutra = ItemManager.instance.getSutra(attr.uniqueID);
				sutra.enhanceLevel = attr.enchantlv;

				// var msg : CCPackChange = new CCPackChange();
				// msg.topType |= Item.EQ;
				// Common.game_server.sendCCMessage(0xFFF2, msg);

				SignalBusManager.itemPropChange.dispatch(sutra);
			}
		}

		/*
		 * 灵珠镶嵌
		 */
		private function onRecvGemChange(msg : SCGemChange) : void {
			// trace("log");
			for each (var key:uint in msg.gemlist) {
				var heroId : uint = key & 0xFF;
				var pos : uint = (key >> 8 ) & 0xFF;
				var gemId : uint = (key >> 16) & 0x7FFF;
				var binding : Boolean = (key >> 31) != 0;

				var hero : VoHero = HeroManager.instance.getTeamHeroById(heroId);
				var slot : GemSlot = hero.gemSlots[pos];

				if (gemId == 0) {
					slot.onReleased();
				} else {
					var gem : Gem = ItemManager.instance.newItem(gemId, binding);
					gem.nums = 1;
					slot.onEquipped(gem);
				}
			}
		}

		/*
		 * 发送物品装上/卸下
		 */
		public function sendEquipChangeMessage(heroId : uint, uniqueId : uint, position : int = -1) : void {
			var msg : CSEquipChange = new CSEquipChange();
			msg.heroId = heroId;
			msg.uniqueID = uniqueId;

			if (position >= 0)
				msg.position = (position | 0x8000);

			Common.game_server.sendMessage(0x1A, msg);
		}

		public function sendMergeMessage(source : uint, target : uint, position : int = -1) : void {
			var msg : CSMergeSoul = new CSMergeSoul();
			msg.source = source;
			msg.target = target;

			if (position >= 0)
				msg.position = (position | 0x8000);

			Common.game_server.sendMessage(0x290, msg);
		}

		public function sendMergeAllSoulMessage(binding : Boolean = false) : void {
			var msg : CSMergeSoulAll = new CSMergeSoulAll();
			msg.mergeBound = binding;
			Common.game_server.sendMessage(0x291, msg);
		}

		public function sendMergeAllGemMessage() : void {
			var msg : CSGemMergeAll = new CSGemMergeAll();
			Common.game_server.sendMessage(0x2A2, msg);
		}
	}
}
