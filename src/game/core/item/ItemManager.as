package game.core.item {
	import log4a.Logger;
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.equipable.EquipableItem;
	import game.core.item.equipable.EquipableSlot;
	import game.core.item.equipable.HeroSlot;
	import game.core.item.equipment.Equipment;
	import game.core.item.pile.PileItem;
	import game.core.item.soul.Soul;
	import game.core.item.sutra.Sutra;
	import game.definition.ID;
	import game.manager.SignalBusManager;
	import game.module.pack.PackModel;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import flash.utils.Dictionary;

	/**
	 * @author jian
	 */
	public class ItemManager {
		// =====================
		// 定义
		// =====================
		// =====================
		// @单例
		// =====================
		private static var __instance : ItemManager;

		public static function get instance() : ItemManager {
			if (!__instance) __instance = new ItemManager();

			return __instance;
		}

		public function ItemManager() {
			if (__instance) throw (Error("单例错误!"));
		}

		// =====================
		// @属性
		// =====================
		private var _itemFactory : ItemFactory = new ItemFactory();
		private var _packModel : PackModel = new PackModel();
		private var _pileItems : Dictionary = new Dictionary();
		private var _equipableItems : Dictionary = new Dictionary();
		private var _sutras : Dictionary = new Dictionary();
		private var _soulModel : IndexListModel = new IndexListModel();
		private var _changeType : uint = 0;

		public function get packModel() : PackModel {
			return _packModel;
		}

		public function get soulModel() : IndexListModel {
			return _soulModel;
		}

		// --------------------------------------------------------------
		// 产生物品 不进容器
		public function newItem(id : uint, binding : Boolean = false) : * {
			return _itemFactory.newItem(id, binding);
		}

		// --------------------------------------------------------------
		/*
		 * 获取物品，区分绑定
		 */
		public function getPileItemWithBinding(id : uint, binding : Boolean) : PileItem {
			var item : PileItem = null;
			if (_pileItems[id])
				item = _pileItems[id][binding];
			return item;
		}

		/*
		 * 获取物品，不区分绑定
		 */
		public function getPileItem(id : uint) : PileItem {
			var item : PileItem = _itemFactory.newItem(id, false);
			item.binding = true;

			if (_pileItems[id]) {
				if (_pileItems[id][true])
					item.nums += PileItem(_pileItems[id][true]).nums;
				if (_pileItems[id][false])
					item.nums += PileItem(_pileItems[id][false]).nums;
			}
			return item;
		}

		/*
		 * 物品数量
		 */
		public function getPileItemNums(id : uint) : uint {
			var nums : uint = 0;

			if (_pileItems[id]) {
				if (_pileItems[id][true])
					nums += PileItem(_pileItems[id][true]).nums;
				if (_pileItems[id][false])
					nums += PileItem(_pileItems[id][false]).nums;
			}
			return nums;
		}

		public function getEquipableItem(uuid : uint) : EquipableItem {
			return _equipableItems[uuid];
		}

		// --------------------------------------------------------------
		// 添加物品
		public function addPileItem(id : uint, binding : Boolean, nums : uint) : void {
			var item : PileItem = _itemFactory.newItem(id, binding);

			item.nums = nums;
			if (!_pileItems[id]) _pileItems[id] = new Dictionary();
			_pileItems[id][binding] = item;
			_packModel.addItem(item);

			_changeType |= item.topType;
		}

		// 删除物品
		public function removePileItem(id : uint, binding : Boolean) : void {
			var item : PileItem = _pileItems[id][binding];
			_packModel.removeItem(item);
			_changeType |= item.topType;
			delete _pileItems[id][binding];
		}

		// 设置物品数量
		public function setPileItemNum(id : uint, binding : Boolean, nums : uint, roll : Boolean = false) : void {
			var item : PileItem = _pileItems[id][binding];
			item.nums = nums;
			_changeType |= item.topType;
			_packModel.changeItem(item);
		}

		// --------------------------------------------------------------
		// 获得鱼
		public function getFishes() : Array {
			var fishes : Array = [];
			for each (var item:Item in _packModel.getPageItems(Item.EXPEND)) {
				if (item.id >= 2300 && item.id < 2400)
					fishes[fishes.length] = item;
			}
			return fishes;
		}
		
		// 获得仙石
		public function getEnhanceStones():Array
		{
			var stones:Array = [];
			
			for each (var item:Item  in _packModel.getPageItems(Item.ENHANCE))
			{
				if (item.id >= ID.ENHANCE_STONE_0 && item.id <= ID.ENHANCE_STONE_3)
				{
					stones.push(item);
				}
			}
			
			return stones;
		}

		// =====================
		// 服务器接口
		// =====================
		// --------------------------------------------------------------
		// 添加装备
		public function addEquipableItem(id : uint, uuid : uint, binding : Boolean, toHero : Boolean) : void {
			var item : EquipableItem = _itemFactory.newItem(id, binding);
			
			if (!item)
			{
				Logger.error("非法装备!");
				return;
			}

			item.uuid = uuid;
			item.nums = 1;
			_equipableItems[uuid] = item;
			_changeType |= item.topType;
			_packModel.addItem(item);

			if (item is Soul)
				_soulModel.add(item);

			if (!toHero)
				SignalBusManager.equipableItemAddToPack.dispatch(item);
		}

		// 删除装备
		public function removeEquipableItem(uuid : uint) : void {
			var item : EquipableItem = _equipableItems[uuid];
			if (item.slot) {
				// 卸下并删除物品
				var hero : VoHero = (item.slot as HeroSlot).hero;
				item.slot.onReleased();
				SignalBusManager.equipableItemRemoveFromHero.dispatch(item, hero);
			} else {
				// 从包裹中删除物品
				_packModel.removeItem(item);
				SignalBusManager.equipableItemRemoveFromPack.dispatch(item);
			}
			_changeType |= item.topType;
			delete _equipableItems[uuid];

			if (item is Soul)
				_soulModel.remove(item);
		}

		// 装上装备
		public function equipEquipableItem(uuid : uint, heroId : uint, pos : uint, isNew : Boolean) : void {
			var item : EquipableItem = _equipableItems[uuid];
			var hero : VoHero = HeroManager.instance.getTeamHeroById(heroId, 2);
			var slot : EquipableSlot;

			_packModel.removeItem(item);

			if (item is Soul)
				_soulModel.remove(item);

			if (item is Sutra) {
			} else if (item is Soul) {
				slot = hero.soulSlots[pos];
				slot.onEquipped(item);
			} else if (item is Equipment) {
				slot = hero.eqSlots[pos];
				slot.onEquipped(item);
			}
			_changeType |= item.topType;

			if (isNew)
				SignalBusManager.equipableItemAddToHero.dispatch(item, hero);
			else
				SignalBusManager.equipableItemMoveToHero.dispatch(item, hero);
		}

		// 将装备放入包裹
		public function moveEquipableItemToPack(uuid : uint, pos : int = -1) : void {
			var item : EquipableItem = _equipableItems[uuid];
			var hero : VoHero = (item.slot) ? (item.slot as HeroSlot).hero : null;
			if (item.slot)
				item.slot.onReleased();
			else
				item.onReleased();

			_packModel.addItem(item);
			_changeType |= item.topType;

			if (item is Soul) {
				if (pos == -1)
					_soulModel.add(item);
				else
					_soulModel.setAt(pos, item);
			}

			SignalBusManager.equipableItemMoveToPack.dispatch(item, hero);
		}

		// 改变强化等级
		public function changeEnhanceLevel(uuid : uint, enhanceLevel : uint) : void {
			var item : Equipment = _equipableItems[uuid];
			item.enhanceLevel = enhanceLevel;
			_changeType |= item.topType;

			SignalBusManager.itemPropChange.dispatch(item);
		}

		// 改变元神经验值
		public function changeSoulExp(uuid : uint, exp : uint) : void {
			var item : Soul = _equipableItems[uuid];
			item.exp = exp;
			_changeType |= item.topType;
		}

		// 设置绑定
		public function setEquipableItemBinding(uuid : uint, binding : Boolean) : void {
			var item : EquipableItem = _equipableItems[uuid];
			item.binding = binding;
			_changeType |= item.topType;
		}

		// --------------------------------------------------------------
		// 获得元神
		public function getPackSouls() : Array {
			var souls : Array = [];

			for each (var item:Item in _packModel.getPageItems(Item.SOUL)) {
				if (item is Soul)
					souls.push(item);
			}

			return souls;
		}

		// --------------------------------------------------------------
		// 添加法宝
		public function addSutra(id : uint) : void {
			_sutras[id] = _itemFactory.newItem(id, true);
		}

		// 获得法宝
		public function getSutra(id : uint) : Sutra {
			var sutra : Sutra = _sutras[id];
			if (!sutra) {
				sutra = _itemFactory.newItem(id, true);
				_sutras[id] = sutra;
			}
			return sutra;
		}

		// --------------------------------------------------------------
		public function notifyChange() : void {
			if (_changeType > 0) {
				var msg : CCPackChange = new CCPackChange();
				msg.topType |= _changeType;
				Common.game_server.sendCCMessage(0xFFF2, msg);
				_changeType = 0;
			}
		}
	}
}
