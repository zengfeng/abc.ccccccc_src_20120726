package com.commUI.quickshop
{
	import game.core.item.ItemManager;
	import game.definition.ID;
	import game.definition.UI;

	/**
	 * @author jian
	 */
	public class VoOrder
	{
		// 物品ID
		public var id : uint;
		// 物品单价
		public var price : uint;
		// 物品数量
		public var count : uint;
		// 货币ID：ID.GOLD, ID.BIND_GOLD, ID.SILVER, ID.HONER
		// 快捷购买默认用元宝，计算元宝是否足够是应当将元宝和绑元宝一起计算
		public var currencyID : uint = ID.GOLD;
		
		// 获取货币的名字
		public function get currencyName():String
		{
			return  ItemManager.instance.newItem(currencyID); 
		}

		// 获取Asset的名称
		public function get currencyAssetName() : String
		{
			if (currencyID == ID.GOLD || currencyID == ID.BIND_GOLD)
			{
				return UI.MONEY_ICON_GOLD;
			}
			else if (currencyID == ID.SILVER)
			{
				return UI.MONEY_ICON_SILVER;
			}
			else if (currencyID == ID.HONOR)
			{
				return UI.MONEY_ICON_HONOUR;
			}
			else
			{
				return "";
			}
		}
	}
}
