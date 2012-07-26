package com.commUI.quickshop
{
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.ViewManager;

	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;





	/**
	 * @author jian
	 */
	public class MultiQuickShop extends AbstractQuickShop
	{

		public static function showOrder(orders : Array /* of VoOrder */, okFunc : Function = null, cancelFunc : Function = null, archor : DisplayObject = null, serverCallback:Function = null) : void
		{
			if (!archor)
				archor = ViewManager.instance.uiContainer;

			var shop : MultiQuickShop = new MultiQuickShop(orders, okFunc, cancelFunc, serverCallback);
			shop.show();

			var offsetPt : Point = shop.parent.globalToLocal(archor.localToGlobal(new Point((archor.width - shop.width) / 2, (archor.height - shop.height) / 2)));
			shop.moveTo(offsetPt.x, offsetPt.y);
		}
		
		private var _boxes : Array = new Array();
		private var _totalCost:TextField;


		public function MultiQuickShop(orders : Array /* of VoOrder */, okFunc : Function = null, cancelFunc : Function = null, serverCallback:Function = null)
		{
			super(orders, okFunc, cancelFunc, serverCallback);

			width = 352;
			height = 207;
		}

		override protected function create() : void
		{
			super.create();

			addFrameBg();
			addGoods();
			addCost();
			addHaving();
		}
		
		private function addFrameBg():void
		{
			var bg:Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND2));
			bg.width = 330;
			bg.height = 104;
			bg.x = 12;
			bg.y = 37;
			addChild(bg);
		}
		
		private function addGoods() : void
		{
			var locX : Number = (width - _orders.length * 100) / 2;
			for each (var order:VoOrder in _orders)
			{
				var box : MultiQuickShopOrderBox = new MultiQuickShopOrderBox(order);

				box.x = locX;
				box.y = 40;
				addChild(box);

				_boxes.push(box);
				locX += 100;
			}
		}

		private function addCost() : void
		{
			var costText:TextField = UICreateUtils.createTextField("共花费：", null, 80, 20, 26, 143, TextFormatUtils.panelContent);
			addChild(costText);
			
			var assetName:String = (_orders[0] as VoOrder).currencyAssetName;
			var icon:Sprite = UIManager.getUI(new AssetData(assetName));
			icon.x = 72;
			icon.y = 143;
			addChild(icon);
					
			_totalCost = UICreateUtils.createTextField(getTotalCost().toString(), null, 60, 20, 87, 143, TextFormatUtils.panelContent);
			addChild(_totalCost);
		}
		
		private function addHaving() : void
		{
			var havingText:TextField = UICreateUtils.createTextField("你当前拥有：", null, 100, 20, 200, 143, TextFormatUtils.panelContent);
			addChild(havingText);
			
			var assetName:String = (_orders[0] as VoOrder).currencyAssetName;
			var icon:Sprite = UIManager.getUI(new AssetData(assetName));
			icon.x = 268;
			icon.y = 143;
			addChild(icon);

			var count:TextField = UICreateUtils.createTextField(String(getHaving()), null, 60, 20, 287, 143, TextFormatUtils.panelContent);
			addChild(count);			
		}

		override protected function layout() : void
		{
			super.layout();

			var locX : Number = (width - _boxes.length * 100) / 2;
			for each (var box:MultiQuickShopOrderBox in _boxes)
			{
				box.x = locX;
				locX += 100;
			}
		}
		
		private function getTotalCost():uint
		{
			var total:uint = 0;
			for each (var order:VoOrder in _orders)
			{
				total += order.price * order.count;
			}
			
			return total;
		}
		
		private function getHaving():uint
		{
			return UserData.instance.gold + UserData.instance.goldB;
		}
		
		
		override protected function inputHandler(event:Event):void
		{
			_totalCost.text = String(getTotalCost());
		}
	}
}
