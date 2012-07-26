package com.commUI.quickshop
{
	import com.utils.ColorUtils;
	import gameui.controls.GLabel;
	import gameui.data.GLabelData;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.definition.ID;
	import game.definition.UI;
	import game.manager.ViewManager;

	import gameui.controls.GTextInput;
	import gameui.data.GTextInputData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.IconLabel;
	import com.commUI.icon.ItemIcon;
	import com.commUI.icon.ItemIconData;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;





	/**
	 * @author jian
	 */
	public class SingleQuickShop extends AbstractQuickShop
	{
		private var _itemIcon : ItemIcon;
		private var _itemName : TextField;
		private var _order : VoOrder;
		private var _total : IconLabel;
		private var _count : GTextInput;

		public function SingleQuickShop(orders : Array, okFunc : Function = null, cancelFunc : Function = null, serverCallback:Function = null)
		{
			_order = orders[0];

			super(orders, okFunc, cancelFunc, serverCallback);

			width = 281;
			height = 167;
		}

		public static function show(goodId : int, type : int = ID.GOLD, num : int = 1, okFunc : Function = null, cancelFunc : Function = null, archor : DisplayObject = null, serverCallback:Function = null) : void
		{
			var order : VoOrder = new VoOrder();
			order.id = goodId;
			order.count = num;
			order.currencyID = type;

			showOrder(order, okFunc, cancelFunc, archor, serverCallback);
		}

		public static function showOrder(order : VoOrder, okFunc : Function = null, cancelFunc : Function = null, archor : DisplayObject = null, serverCallback:Function = null) : void
		{
			if (!archor)
				archor = ViewManager.instance.uiContainer;

			var shop : SingleQuickShop = new SingleQuickShop([order], okFunc, cancelFunc, serverCallback);
			shop.show();

			var offsetPt : Point = shop.parent.globalToLocal(archor.localToGlobal(new Point((archor.width - shop.width) / 2, (archor.height - shop.height) / 2)));
			shop.moveTo(offsetPt.x, offsetPt.y);
		}

		override protected function create() : void
		{
			super.create();

			addFrameBg();
			addGood();
			addCurrency();
			addCount();
		}

		private function addFrameBg() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND2));
			bg.width = 269;
			bg.height = 70;
			bg.x = 6;
			bg.y = 34;
			addChild(bg);
		}

		private function addGood() : void
		{
			var item : Item = ItemManager.instance.newItem(_order.id);
			item.binding = true;

			var data : ItemIconData = new ItemIconData();
			data.showBorder = true;
			data.showToolTip = true;

			_itemIcon = new ItemIcon(data);
			_itemIcon.source = item;
			_itemIcon.x = 59;
			_itemIcon.y = 45;
			addChild(_itemIcon);

			_itemName = new TextField();
			_itemName.defaultTextFormat = TextFormatUtils.panelSubTitle;
			_itemName.x = 125;
			_itemName.y = 45;
			_itemName.width = 120;
			_itemName.htmlText = item.htmlName;
			_itemName.mouseEnabled = false;
			addChild(_itemName);
		}

		private function addCurrency() : void
		{
//			var priceText : TextField = UICreateUtils.createTextField("总花费：", null, 80, 20, 26, 108, TextFormatUtils.panelContent);
			
			var data:GLabelData = new GLabelData();
			data.textFormat = TextFormatUtils.panelContent;
			data.textColor = ColorUtils.PANELTEXT0X;
			data.textFieldFilters = [];
			
			
			var priceText :GLabel = new GLabel(data);
			priceText.text = "总花费：";
			priceText.x = 26;
			priceText.y = 104;
			addChild(priceText);
			
			
			_total = new IconLabel(data);
			_total.icon = UIManager.getUI(new AssetData(_order.currencyAssetName));
			_total.text = getTotalCost().toString();
			_total.x = 74;
			_total.y = 104;
			_total.hgap = 0;
			_total.iconX = 0;
			_total.iconY = 2;
			addChild(_total);

//			var icon : Sprite = UIManager.getUI(new AssetData(_order.currencyAssetName));
//			icon.x = 72;
//			icon.y = 109;
//			addChild(icon);

//			_total = UICreateUtils.createTextField(getTotalCost().toString(), null, 80, 20, 87, 108, TextFormatUtils.panelContent);
//			addChild(_total);
		}

		private function addCount() : void
		{
			var text : TextField = UICreateUtils.createTextField("数量：", null, 60, 20, 126, 74, TextFormatUtils.panelContent);
			addChild(text);

			var textFormat : TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;

			var data : GTextInputData = new GTextInputData();
			data.maxChars = 8;
			data.x = 159;
			data.y = 70;
			data.width = 65;
			data.textFormat = textFormat;
			data.text = _order.count.toString();
			data.restrict = "0-9";
			data.maxChars = 3;
			data.maxNum = 999;
			_count = new GTextInput(data);
			addChild(_count);
		}

		private function getTotalCost() : uint
		{
			return _order.price * _order.count;
		}

		override protected function inputHandler(event : Event) : void
		{
			if (_count.text == "0")
				_count.text = "1";
			_order.count = uint(_count.text);
			_total.text = String(getTotalCost());
		}
	}
}
