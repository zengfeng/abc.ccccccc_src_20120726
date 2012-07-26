package com.commUI.quickshop
{
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.module.shop.staticValue.ShopStaticValue;

	import gameui.controls.GTextInput;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GTextInputData;

	import com.commUI.icon.ItemIcon;
	import com.commUI.icon.ItemIconData;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;




	/**
	 * @author jian
	 */
	public class MultiQuickShopOrderBox extends GComponent
	{
		private var _count : GTextInput;
		private var _order : VoOrder;

		public function MultiQuickShopOrderBox(order : VoOrder)
		{
			var data : GComponentData = new GComponentData();
			super(data);

			_order = order;
			if (!_order.price)
				_order.price = ShopStaticValue.getGoodsPic(_order.id);

			var item : Item = ItemManager.instance.newItem(order.id);

			var iconData : ItemIconData = new ItemIconData();
			iconData.x = 25;
			iconData.y = 0;
			iconData.showBorder = true;
			iconData.showToolTip = true;

			var icon : ItemIcon = new ItemIcon(iconData);
			icon.source = item;
			addChild(icon);

			var name : TextField = UICreateUtils.createTextField(null, item.htmlName, 70, 20, 15, 52, TextFormatUtils.panelContentCenter);
			addChild(name);

			var countText : TextField = UICreateUtils.createTextField("数量：", null, 60, 20, 5, 72, TextFormatUtils.panelContent);
			addChild(countText);

			var textFormat : TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;

			var inputdata : GTextInputData = new GTextInputData();
			inputdata.maxChars = 8;
			inputdata.width = 60;
			inputdata.textFormat = textFormat;
			inputdata.x = 40;
			inputdata.y = 70;
			inputdata.restrict = "0-9";
			inputdata.maxChars = 3;
			inputdata.maxNum = 999;
			inputdata.text = String(order.count);

			_count = new GTextInput(inputdata);
			addChild(_count);
		}

		public function get count() : uint
		{
			return uint(_count.text);
		}

		public function get order() : VoOrder
		{
			return _order;
		}

		override protected function onShow() : void
		{
			addEventListener(Event.CHANGE, inputChangeHandler);
		}

		override protected function onHide() : void
		{
			removeEventListener(Event.CHANGE, inputChangeHandler);
		}

		private function inputChangeHandler(event : Event) : void
		{
			if (int(_count.text)<=0)
				_count.text = "1";
			_order.count = uint(_count.text);
		}
	}
}
