package game.module.pack {
	import game.core.hero.HeroManager;
	import game.core.item.Item;
	import game.core.item.equipable.EquipableItem;
	import game.core.item.equipment.Equipment;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.manager.SignalBusManager;
	import game.net.core.Common;
	import game.net.core.RequestData;
	import game.net.data.CtoC.CCHeroEqChange;
	import game.net.data.CtoS.CSSellItem;
	import game.net.data.CtoS.CSUseItem;


	/**
	 * @author yangyiqiang
	 */
	public final class ManagePack
	{
		private static var _goodOperatePanel : GoodOperateBox;

		public static function get goodOperatePanel() : GoodOperateBox
		{
			if (!_goodOperatePanel)
				_goodOperatePanel = new GoodOperateBox();
			return _goodOperatePanel;
		}

		public static var MAX : int = 600;

		public static function useItem(itemId : int, bind : Boolean, num : int, heroId : int) : void
		{
			var cmd : CSUseItem = new CSUseItem();
			cmd.heroId = heroId;
			// 使用普通物品 第16bit表示装备是否绑定。0-非绑定 1-绑定。高位两个字节表示使用数量。
			cmd.itemId = (num << 16) + (bind ? 0x8000 : 0x0000) + itemId;
			Common.game_server.sendMessage(0x201, cmd);
		}

		public static function sellItem(value : *) : void
		{
			if (!value) return;
			var cmd : CSSellItem = new CSSellItem();
			for each (var vo:Item in value)
			{
				if (vo is EquipableItem)
					cmd.uniqueID.push(EquipableItem(vo).uuid);
				else
					cmd.items.push((vo.nums << 16) + (vo.binding ? 0x8000 : 0x0000) + vo.id);
			}
			Common.game_server.sendMessage(0x202, cmd);
		}

		public static function equipItem(eq : Equipment) : void
		{
			if (!MenuManager.getInstance().getMenuState(MenuType.HERO_PANEL))
			{
				MenuManager.getInstance().openMenuView(MenuType.HERO_PANEL);
				SignalBusManager.heroPanelSelectHero.dispatch(HeroManager.instance.myHero.id);
			}
			var cmd : CCHeroEqChange = new CCHeroEqChange();
			cmd.uuid = eq.uuid;
			Common.game_server.executeCallback(new RequestData(0xfff3, cmd));
		}
		//		//  请求脱下装备 type: 0 装备， 1 元神， 2 宝石
		// public static function sendTakeOffEquip(heroId : uint, type : uint, pos : uint) : void
		// {
		// if (heroId > 0xFFFF || type > 0x3 || pos > 0xF)
		// {
		// Logger.error("非法装备位置");
		// return;
		// }
		//
		// var cmd : CSEquipChange = new CSEquipChange();
		// cmd.heroId = heroId | type << 8 | pos << 10;
		// cmd.uniqueID = 0;
		// Common.game_server.sendMessage(0x1A, cmd);
		// }

		//		//  请求穿上装备
		// public static function sendPutOnEquip(heroId : uint, type : uint, pos : uint, uuid : uint) : void
		// {
		// if (heroId > 0xFFFF || type > 0x3 || pos > 0xF)
		// {
		// Logger.error("非法装备位置");
		// return;
		// }
		//
		// var cmd : CSEquipChange = new CSEquipChange();
		// cmd.heroId = heroId | type << 8 | pos << 10;
		// cmd.uniqueID = uuid;
		// Common.game_server.sendMessage(0x1A, cmd);
		// }
	}
}
