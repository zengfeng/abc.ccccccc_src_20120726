package game.module.trade.exchange
{
	import game.core.item.IUnique;
	import game.core.item.Item;
	import game.core.item.pile.PileItem;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.trade.VTabbedPack;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.core.GAlign;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;
	import com.commUI.alert.Alert;
	import com.commUI.itemgrid.ItemCellEvent;
	import com.commUI.itemgrid.ItemGridCell;
	import com.utils.RegExpUtils;
	import com.utils.ItemUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * ...
	 * @author qiujian
	 */
	public class ExchangeSheet extends GCommonSmallWindow
	{
		// =====================
		// @属性
		// =====================
		private var _parterCart : ShoppingCart;
		private var _myCart : ShoppingCart;
		private var  _freezeMyCart : Boolean = false;
		private var _tabbedPack : VTabbedPack;
		private var _exitButton : GButton;
		private var _cancelButton : GButton;
		private var _startButton : GButton;
		private var _acceptButton : GButton;
		private var _finishButton : GButton;
		private var _exchangeVO : ExchangeVO;
		private var _floatMessageText : TextField;
		private var _subPanel : GPanel;
		private var _shoppingCartBg : Sprite;

		// =====================
		// @创建
		// =====================
		public function ExchangeSheet()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.parent = ViewManager.instance.uiContainer;
			data.allowDrag = true;
			data.width = 660;
			data.height = 365;
			data.align = new GAlign(-1, -1, -1, -1, 1, 1);
			super(data);
		}

		public function get exchangeVO() : ExchangeVO
		{
			return _exchangeVO;
		}

		override protected function create() : void
		{
			super.create();

			title = "交易单";
			addSubPanel();
			addShoppingCartBg();
			addParterCart();
			addMyCart();
			addPack();
			addButtons();
			addFloatMessage();

			_tabbedPack.tabList.select(0);
		}

		private function addSubPanel() : void
		{
			var data : GPanelData = new GPanelData();
			data.x = 5;
			data.y = 0;
			data.width = _width - 65;
			data.height = _height - 5;
			data.bgAsset = new AssetData(UI.PANEL_BACKGROUND);

			_subPanel = new GPanel(data);
			_subPanel.height = _height - 5;
			this.contentPanel.add(_subPanel);
		}

		private function addShoppingCartBg() : void
		{
			_shoppingCartBg = UIManager.getUI(new AssetData(UI.SHOPPING_CART_BG_1));
			_shoppingCartBg.x = 4;
			_shoppingCartBg.y = 4;
			_shoppingCartBg.width = 402;
			_shoppingCartBg.height = 308;
			_subPanel.addChild(_shoppingCartBg);
		}

		private function addParterCart() : void
		{
			_parterCart = new ShoppingCart();
			_parterCart.mode = ShoppingCart.TEXT_MODE;
			_parterCart.x = 2;
			_parterCart.y = 10;
			_subPanel.addChild(_parterCart);
		}

		private function addMyCart() : void
		{
			_myCart = new ShoppingCart();
			_myCart.mode = ShoppingCart.INPUT_MODE;
			_myCart.x = 201;
			_myCart.y = 10;
			_subPanel.addChild(_myCart);
		}

		private function addPack() : void
		{
			_tabbedPack = new VTabbedPack(getMyCartItems);
			_tabbedPack.x = 410;
			_tabbedPack.y = 0;
			_subPanel.addChild(_tabbedPack);
		}

		private function addButtons() : void
		{
			_cancelButton = UICreateUtils.createGButton("取消交易", 0, 0, 164, 320);
			_subPanel.addChild(_cancelButton);

			// _exitButton = UICreateUtils.createGButton("返回", 72, 25, 245, 320);
			// _subPanel.addChild(_exitButton);

			_startButton = UICreateUtils.createGButton("发起交易", 0, 0, 164, 320);
			_subPanel.addChild(_startButton);

			_acceptButton = UICreateUtils.createGButton("确认交易", 0, 0, 125, 320);
			_subPanel.addChild(_acceptButton);

			_finishButton = UICreateUtils.createGButton("完成交易", 0, 0, 125, 320);
			_subPanel.addChild(_finishButton);
		}

		private function addFloatMessage() : void
		{
			_floatMessageText = UICreateUtils.createTextField(null, null, 160, 30, 20, 278, TextFormatUtils.panelSubTitleCenter);
			_floatMessageText.textColor = 0xFF3300;
			_floatMessageText.visible = false;
			addChild(_floatMessageText);
		}

		// =====================
		// @更新
		// =====================
		public function updateView() : void
		{
			updateParterCart();
			updateMyCart();
			updatePack();
			updateButtons();
			updateFloatMessage();
		}

		private function updateParterCart() : void
		{
			_parterCart.playerName = StringUtils.addColor(_exchangeVO.partnerName, StringUtils.colorToString(_exchangeVO.partnerColor));
			_parterCart.itemGrid.source = _exchangeVO.partnerItems;
			// _parterCart.price = _exchangeVO.partnerPrice;
			// _parterCart.message = _exchangeVO.partnerMessage;
			if (_exchangeVO.partnerPrice == 0)
			{
				_parterCart.price = 0;
			}
			else
			{
				_parterCart.price = _exchangeVO.partnerPrice;
			}
			// 有问题

			if (_exchangeVO.partnerMessage == "")
			{
				_parterCart.message = " ";
			}
			else
			{
				_parterCart.message = _exchangeVO.partnerMessage;
			}
		}

		private function updateMyCart() : void
		{
			if (_exchangeVO.status == ExchangeVO.NOT_START || _exchangeVO.status == ExchangeVO.HE_START)
			{
				_myCart.mode = ShoppingCart.INPUT_MODE;
				_freezeMyCart = false;
			}
			else
			{
				_myCart.mode = ShoppingCart.TEXT_MODE;
				_freezeMyCart = true;
			}
			_myCart.playerName = UserData.instance.playerHtmlName;
			_myCart.itemGrid.source = _exchangeVO.myItems;

			if (_myCart.mode == ShoppingCart.TEXT_MODE)
			{
				_myCart.price = _exchangeVO.myPrice;
				_myCart.message = _exchangeVO.myMessage;
			}
		}

		private function updatePack() : void
		{
			// if (_exchangeVO.status == ExchangeVO.NOT_START || _exchangeVO.status == ExchangeVO.HE_START || _exchangeVO.status == ExchangeVO.HE_REPLIED)
			// {
			// _tabbedPack.itemGrid.mouseChildren = true;
			// _tabbedPack.itemGrid.mouseChildren = true;
			// }
			// else
			// {
			// _tabbedPack.itemGrid.mouseChildren = false;
			// _tabbedPack.itemGrid.mouseChildren = false;
			// }
			_tabbedPack.updateView();
		}

		private function updateButtons() : void
		{
			_startButton.visible = false;
			_acceptButton.visible = false;
			_finishButton.visible = false;
			_cancelButton.visible = false;
			_cancelButton.x = 168;
			switch(_exchangeVO.status)
			{
				case ExchangeVO.NOT_START:
					_startButton.visible = true;
					break;
				case ExchangeVO.HE_REPLIED:
					_finishButton.visible = true;
					_cancelButton.visible = true;
					_cancelButton.x = 212;
					break;
				case ExchangeVO.HE_START:
					_acceptButton.visible = true;
					_cancelButton.visible = true;
					_cancelButton.x = 212;
					break;
				case ExchangeVO.I_REPLIED:
				case ExchangeVO.I_START:
					_cancelButton.visible = true;
					break;
			}
		}

		private function updateFloatMessage() : void
		{
			switch(_exchangeVO.status)
			{
				case ExchangeVO.I_START:
				case ExchangeVO.I_REPLIED:
					_floatMessageText.visible = true;
					_floatMessageText.text = "等待对方确认";
					_floatMessageText.x = 30;
					break;
				case ExchangeVO.HE_REPLIED:
					_floatMessageText.visible = true;
					_floatMessageText.text = "等待你的确认";
					_floatMessageText.x = 220;
					break;
				default:
					_floatMessageText.visible = false;
			}
		}

		private function readCartToVO() : void
		{
			_exchangeVO.myPrice = _myCart.price;
			_exchangeVO.myMessage = _myCart.message;

			if (_exchangeVO.myPrice == 0)
			{
				_exchangeVO.myPrice = 0;
			}
			// 有问题

			if (_exchangeVO.myMessage == "")
			{
				_exchangeVO.myMessage = " ";
			}
		}

		public function clear() : void
		{
			_myCart.price = 0;
			_myCart.message = "";
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			// _exitButton.addEventListener(MouseEvent.CLICK, clickExitHandler);
			_cancelButton.addEventListener(MouseEvent.CLICK, clickCancelHandler);
			_acceptButton.addEventListener(MouseEvent.CLICK, clickAcceptHandler);
			_finishButton.addEventListener(MouseEvent.CLICK, clickFinishHandler);
			_startButton.addEventListener(MouseEvent.CLICK, clickStartHandler);
			_tabbedPack.itemGrid.addEventListener(ItemCellEvent.SELECT, selectPackItemHandler, true);
			_myCart.itemGrid.addEventListener(ItemCellEvent.SELECT, selectMyCartItemHandler, true);
			updateView();
		}

		override protected function onHide() : void
		{
			// _exitButton.removeEventListener(MouseEvent.CLICK, clickExitHandler);
			_cancelButton.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			_acceptButton.removeEventListener(MouseEvent.CLICK, clickAcceptHandler);
			_finishButton.removeEventListener(MouseEvent.CLICK, clickFinishHandler);
			_startButton.removeEventListener(MouseEvent.CLICK, clickStartHandler);
			_tabbedPack.itemGrid.removeEventListener(ItemCellEvent.SELECT, selectPackItemHandler, true);
			_myCart.itemGrid.removeEventListener(ItemCellEvent.SELECT, selectMyCartItemHandler, true);
			super.onHide();
		}

		private function clickExitHandler(event : MouseEvent) : void
		{
			if (parent)
				parent.removeChild(this);
		}

		private function clickCancelHandler(event : MouseEvent) : void
		{
			ExchangeManager.instance.cancelExchange(_exchangeVO);
		}

		private function clickStartHandler(event : MouseEvent) : void
		{
			if (RegExpUtils.checkStr(_myCart.message))
			{
				StateManager.instance.checkMsg(244);
				return;
			}
			
			readCartToVO();

			if (_exchangeVO.myPrice == 0 && _exchangeVO.myItems.length == 0)
			{
				StateManager.instance.checkMsg(203);
				return;
			}

			if (UserData.instance.gold >= _exchangeVO.myPrice)
			{
				StateManager.instance.checkMsg(199, [StringUtils.addColor(_exchangeVO.partnerName, StringUtils.colorToString(_exchangeVO.partnerColor))], startTradeConfirmHandler);
			}
			else
			{
				StateManager.instance.checkMsg(4);
			}
		}

		private function startTradeConfirmHandler(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT)
			{
				ExchangeManager.instance.startExchange(_exchangeVO);
				hide();
			}
			return true;
		}

		private function clickFinishHandler(event : MouseEvent) : void
		{
			ExchangeManager.instance.finishExchange(_exchangeVO);
			hide();
		}

		private function clickAcceptHandler(event : MouseEvent) : void
		{
			if (RegExpUtils.checkStr(_myCart.message))
			{
				StateManager.instance.checkMsg(244);
				return;
			}

			readCartToVO();
			ExchangeManager.instance.acceptExchange(_exchangeVO);
			hide();
		}

		private function selectPackItemHandler(event : Event) : void
		{
			if (_freezeMyCart)
			{
				StateManager.instance.checkMsg(201);
				return;
			}

			var cell : ItemGridCell = event.target as ItemGridCell;
			var item : Item = cell.source as Item;

			var room : int = roomForItem(item);
			if (room == 0)
			{
				StateManager.instance.checkMsg(47);
			}
			else if (item.topType == Item.GEM && _exchangeVO.partnerLevel < 70)
			{
				Logger.info("不能将灵珠交易给70级以下玩家");
				StateManager.instance.checkMsg(202);
			}
			else if (item is IUnique || item.nums == 1)
			{
				addItemToMyCart(item);
			}
			else if (item is PileItem)
			{
				var pile : PileItem = item.clone();
				pile.nums = Math.min(pile.nums, room);
				PileSplitter.splitPile(pile, addItemToMyCart, null, this);
			}
			else
				trace("错误的物品类型");
		}

		private function selectMyCartItemHandler(event : Event) : void
		{
			if (_freezeMyCart)
			{
				StateManager.instance.checkMsg(201);
				return;
			}

			var cell : ItemGridCell = event.target as ItemGridCell;
			var item : Item = cell.source as Item;

			removeItemFromCart(item);
		}

		private function roomForItem(item : Item) : int
		{
			if (_exchangeVO.myItems.length < 9)
				return item.config.stackLimit;

			if (!(item is PileItem))
				return 0;

			for each (var existItem:Item in _exchangeVO.myItems)
			{
				if (item.id == existItem.id && existItem.config.stackLimit > existItem.nums)
					return existItem.config.stackLimit - existItem.nums;
			}

			return 0;
		}

		// TODO
		private function addItemToMyCart(item : Item) : void
		{
			var array : Array = _exchangeVO.myItems;
			ItemUtils.addToPileArray(array, item);
			_exchangeVO.myItems = ItemUtils.splitPileArray(array);

			if (!_myCart.message)
			{
				_myCart.message = item.name;
			}

			updateMyCart();
			updatePack();
		}

		private function removeItemFromCart(item : Item) : void
		{
			_exchangeVO.myItems.splice(_exchangeVO.myItems.indexOf(item), 1);
			updateMyCart();
			updatePack();
		}

		override public function set source(value : *) : void
		{
			_exchangeVO = value;

			updateView();
		}

		public function onReceiveChangeStatus(tradeId : uint, status : uint) : void
		{
			if (_exchangeVO && tradeId == _exchangeVO.tradeId)
			{
				_exchangeVO.status = status;
				updateView();
			}
		}

		// =====================
		// @其它
		// =====================
		private function getMyCartItems() : Array
		{
			if (_exchangeVO)
			{
				if (_exchangeVO.status == ExchangeVO.NOT_START || _exchangeVO.status == ExchangeVO.HE_START)
					return _exchangeVO.myItems;
			}
			return null;
		}
	}
}