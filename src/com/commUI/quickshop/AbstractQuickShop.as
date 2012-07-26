package com.commUI.quickshop
{
	import game.manager.SignalBusManager;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.ID;
	import game.module.shop.ShopManager;
	import game.module.shop.staticValue.ShopStaticValue;

	import gameui.controls.GButton;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;

	import com.commUI.GInfoWindow;
	import com.commUI.button.KTButtonData;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;





	/**
	 * @author qiujian
	 */
	public class AbstractQuickShop extends GInfoWindow
	{
		private var _okFunc : Function;
		private var _cancelFunc : Function;
		private var _serverRetFunc : Function;
		protected var _orders : Array /* of VoOrder */;
		protected var _okButton : GButton;
		protected var _cancelButton : GButton;
		private var _modalSkin : Sprite;

		// protected var _subPanel : GPanel;
		public function AbstractQuickShop(orders : Array, okFunc : Function = null, cancelFunc : Function = null, serverRetFunc : Function = null)
		{
			var data : GComponentData = new GComponentData();
			data.parent = UIManager.root;

			for each (var order:VoOrder in orders)
			{
				if (order.id == ID.SILVER)
				{
					order.id = ID.SILVER_CARD;
					order.count = Math.ceil(Number(order.count) / 1000 / ShopStaticValue.getGoodsPic(ID.SILVER_CARD));
				}
				if (!order.price)
					order.price = ShopStaticValue.getGoodsPic(order.id);
			}

			_orders = orders;
			_okFunc = okFunc;
			_cancelFunc = cancelFunc;
			_serverRetFunc = serverRetFunc;

			super(data);

			// _titleBar.visible = false;
		}

		override protected function create() : void
		{
			super.create();
			addModalSkin();
			addHintText();
			addButtons();
		}

		private function addModalSkin() : void
		{
			_modalSkin = ASSkin.modalSkin;
		}

		private function addHintText() : void
		{
			var hint : TextField = UICreateUtils.createTextField("缺少以下材料，是否购买？", null, 160, 20, 26, 11, TextFormatUtils.panelContent);
			addChild(hint);
		}

		private function addButtons() : void
		{
			var okButtonData : GButtonData = new KTButtonData();

			_okButton = new GButton(okButtonData);
			_okButton.text = "购买";
			addChild(_okButton);

			var cancelButtonData : GButtonData = new KTButtonData();

			_cancelButton = new GButton(cancelButtonData);
			_cancelButton.text = "取消";
			addChild(_cancelButton);
		}

		private function addModelSkinToStage() : void
		{
			parent.addChildAt(_modalSkin, parent.numChildren - 1);
			parent.swapChildrenAt(parent.getChildIndex(this), parent.numChildren - 1);
		}

		override protected function onShow() : void
		{
			super.onShow();
			addModelSkinToStage();
			layout();
			_okButton.addEventListener(MouseEvent.CLICK, onOK);
			_cancelButton.addEventListener(MouseEvent.CLICK, onCancel);
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
			addEventListener(Event.CHANGE, inputHandler);
		}

		override protected function onHide() : void
		{
			_modalSkin.parent.removeChild(_modalSkin);
			_okButton.removeEventListener(MouseEvent.CLICK, onOK);
			_cancelButton.removeEventListener(MouseEvent.CLICK, onCancel);
			stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
			removeEventListener(Event.CHANGE, inputHandler);
			super.onHide();
		}

		private function stage_resizeHandler(event : Event) : void
		{
			layoutModelSkin();
		}

		protected function inputHandler(event : Event) : void
		{
		}

		protected function onOK(event : MouseEvent) : void
		{
			if (hasEnoughCurrency())
			{
				var i : int = _orders.length - 1;
				for each (var order:VoOrder in _orders)
				{
					var storeType : uint = (order.currencyID == ID.HONOR) ? 2 : 1;

					if (i == 0)
						ShopManager.getInstance().sendStoreBuyMessage(order.id, order.count, storeType, _serverRetFunc);
					else
						ShopManager.getInstance().sendStoreBuyMessage(order.id, order.count, storeType);
					i--;
				}
				if (_okFunc != null) _okFunc();

				parent.removeChild(this);
			}
		}

		protected function onCancel(event : MouseEvent) : void
		{
			if (_cancelFunc != null) _cancelFunc();

			parent.removeChild(this);
		}

		override protected function layout() : void
		{
			super.layout();

			layoutModelSkin();

			_okButton.x = (width / 2 - _okButton.width) * 0.6;
			_okButton.y = height - 35;
			_cancelButton.x = width / 2 + _cancelButton.width * 0.4;
			_cancelButton.y = height - 35;

			if (parent)
			{
				x = (parent.width - _width) / 2;
				y = (parent.height - height) / 2;
			}
		}

		private function layoutModelSkin() : void
		{
			_modalSkin.x = 0;
			_modalSkin.y = 0;
			_modalSkin.width = UIManager.root.stage.stageWidth;
			_modalSkin.height = UIManager.root.stage.stageHeight;
		}

		private function hasEnoughCurrency() : Boolean
		{
			var totalCost : Dictionary = new Dictionary();

			for each (var order:VoOrder in _orders)
			{
				if (totalCost.hasOwnProperty(order.currencyID))
					totalCost[order.currencyID] += order.price * order.count;
				else
					totalCost[order.currencyID] = order.price * order.count;
			}

			for (var key:String in totalCost)
			{
				var currencyID : uint = uint(key);
				if (currencyID == ID.GOLD)
				{
					if (totalCost[currencyID] > UserData.instance.totalGold)
					{
						StateManager.instance.checkMsg(4);
						return false;
					}
				}

				if (currencyID == ID.HONOR)
				{
					if (totalCost[currencyID] > UserData.instance.honour)
					{
						// TODO: 快捷购买默认用元宝，这个弹框预留
						StateManager.instance.checkMsg(4);
						return false;
					}
				}

				if (currencyID == ID.SILVER)
				{
					if (totalCost[currencyID] > UserData.instance.silver)
					{
						StateManager.instance.checkMsg(129);
						return false;
					}
				}
			}

			return true;
		}

		protected function getGoodsById(id : uint) : Item
		{
			var item : Item;
			if (id == ID.SILVER)
				item = ItemManager.instance.newItem(ID.SILVER_CARD);
			else
				item = ItemManager.instance.newItem(id);
			return item;
		}
	}
}
