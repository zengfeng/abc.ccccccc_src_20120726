package game.module.userPanel {
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.equipable.EquipableItem;
	import game.core.item.equipment.Equipment;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.net.core.Common;
	import game.net.data.StoC.SCItemList;

	import flash.utils.Dictionary;


	/**
	 * @author jian
	 */
	public class ProposeEqManager
	{
		// =====================
		// 单例
		// =====================
		private static var __instance : ProposeEqManager;

		public static function get instance() : ProposeEqManager
		{
			if (!__instance)
				return new ProposeEqManager();

			return __instance;
		}

		public function ProposeEqManager()
		{
			if (__instance)
				throw(Error("单例错误！"));

			initiate();
		}

		// =====================
		// 属性
		// =====================
		private var _panel : ProposeEqPanel;
		private var _valid : Boolean = false;
		private var _newItems : Dictionary;

		// 面板需要在使用时创建，否则可能获得不了资源
		public function get panel() : ProposeEqPanel
		{
			if (!_panel)
				_panel = new ProposeEqPanel();
				
			return _panel;
		}

		// =====================
		// 方法
		// =====================
		private function initiate() : void
		{
			_newItems = new Dictionary();

			Common.game_server.addCallback(0x200, onFirstItemList);
		}

		private function onFirstItemList(msg : SCItemList) : void
		{
			Common.game_server.removeCallback(0x200, onFirstItemList);

			if (UserData.instance.level > 20)
				return;

			SignalBusManager.equipableItemAddToPack.add(onAddToPack);
			SignalBusManager.equipableItemMoveToHero.add(onRemoveFromPack);
			SignalBusManager.equipableItemRemoveFromPack.add(onRemoveFromPack);
		}

		private function quit() : void
		{
			SignalBusManager.equipableItemAddToPack.remove(onAddToPack);
			SignalBusManager.equipableItemMoveToHero.remove(onRemoveFromPack);
			SignalBusManager.equipableItemRemoveFromPack.remove(onRemoveFromPack);

			if (_panel)
				_panel.hide();
		}

		private function  onAddToPack(item : EquipableItem) : void
		{
			if (UserData.instance.level > 20)
			{
				quit();
			}

			if (!(item is Equipment))
				return;

			if (item.useLevel > UserData.instance.level)
				return;

			var eq : Equipment = _newItems[item.type];

			if (!eq || eq.id < item.id)
				_newItems[item.type] = item;

			updatePanel();
		}

		private function onRemoveFromPack(item : EquipableItem, hero : VoHero = null) : void
		{
			if (_panel)
			{
				if (_newItems[item.type] && item.uuid == _newItems[item.type].uuid)
				{
					delete _newItems[item.type];
				}
			}

			updatePanel();
		}

		private function updatePanel() : void
		{
			var myHero : VoHero = HeroManager.instance.myHero;

			for (var type:String in _newItems)
			{
				var heroEq : Equipment = myHero.getEquipment(uint(type));
				var newItem : Equipment = _newItems[type];

				if (!newItem)
					continue;

				if (!heroEq || heroEq.id < newItem.id)
				{
					panel.source = newItem;
					panel.show();
					return;
				}
				else
				{
					delete _newItems[type];
				}
			}

			if (_panel)
				_panel.hide();
		}
		// private function onAddToPack(msg : CCPackChange) : void
		// {
		// if (UserData.instance.level > 20)
		// {
		// Common.game_server.removeCallback(0xFFF2, onAddItemToPack);
		// return;
		// }
		//
		// if (msg.topType | Item.EQ)
		// {
		// var proposal : Equipment;
		// for each (var slot:EquipmentSlot in HeroManager.instance.myHero.eqSlots)
		// {
		// if (!slot.equipable)
		// proposal = ItemUtils.proposeNewbieEquipment(UserData.instance.level, slot.eqType, 0);
		// else
		// proposal = ItemUtils.proposeNewbieEquipment(UserData.instance.level, slot.eqType, (slot.equipable as Item).id);
		//
		// if (proposal)
		// {
		// panel.source = proposal;
		// panel.show();
		// break;
		// }
		// }
		// }
		// }
	}
}
