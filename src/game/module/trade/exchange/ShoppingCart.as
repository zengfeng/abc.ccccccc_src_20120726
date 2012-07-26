package game.module.trade.exchange {
	import game.core.user.UserData;
	import game.definition.UI;

	import gameui.controls.GTextInput;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;





	/**
	 * @author jian
	 */
	public class ShoppingCart extends GComponent
	{
		// =====================
		// 定义
		// =====================
		public static const TEXT_MODE : uint = 0;
		public static const INPUT_MODE : uint = 1;
		// =====================
		// 属性
		// =====================
		private var _mode : uint;
		private var _serverIdText : TextField;
		private var _playerNameText : TextField;
		private var _priceInput : GTextInput;
		private var _messageInput : GTextInput;
		private var _itemGrid : ItemGrid;

		// =====================
		// Getter/Setter
		// =====================
		public function set mode(value : uint) : void
		{
			_mode = value;

			updateInputs();
			updateItemGrid();
		}
		
		public function get mode():uint
		{
			return _mode;
		}

		public function set serverId(value : uint) : void
		{
			_serverIdText.text = value.toString();
		}

		public function set playerName(value : String) : void
		{
			_playerNameText.htmlText = value;
		}

		public function get itemGrid() : ItemGrid
		{
			return _itemGrid;
		}

		public function set price(value : uint) : void
		{
			if (value == 0)
				_priceInput.text = "";
			else
				_priceInput.text = value.toString();
		}

		public function get price() : uint
		{
			return uint(_priceInput.text);
		}

		public function set message(value : String) : void
		{
			_messageInput.text = value.toString();
		}

		public function get message() : String
		{
			return _messageInput.text;
		}

		// =====================
		// @创建
		// =====================
		/*
		 * input: 可以操作
		 */
		public function ShoppingCart()
		{
			var data : GComponentData = new GComponentData();
			super(data);
		}

		override protected function create() : void
		{
			addBackground();
			addServerId();
			addPlayerName();
			addItemGrid();
			addPrice();
			addMessage();
		}

		private function addBackground() : void
		{
			var _shoppingCartBg : Sprite = UIManager.getUI(new AssetData(UI.SHOPPING_CART_BG_2));
			_shoppingCartBg.x = 8;
			_shoppingCartBg.y = 0;
			_shoppingCartBg.width = 190;
			_shoppingCartBg.height = 294;
			addChild(_shoppingCartBg);
		}

		private function addServerId() : void
		{
			_serverIdText = UICreateUtils.createTextField(null, null, 22, 11, 42, 7, TextFormatUtils.panelSubTitle);
			addChild(_serverIdText);
		}

		private function addPlayerName() : void
		{
			_playerNameText = UICreateUtils.createTextField(null, null, 190, 20, 8, 0, TextFormatUtils.panelSubTitleCenter);
			addChild(_playerNameText);
		}

		private function addItemGrid() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 19;
			gridData.y = 20;
			gridData.allowDrag = false;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 3;
			gridData.columns = 3;
			gridData.hgap = 6;
			gridData.vgap = 6;
			gridData.padding = 6;
			gridData.cell = ItemGridCell;
			gridData.verticalScrollPolicy = GPanelData.OFF;

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 48;
			cellData.height = 48;
			cellData.iconData.showBg = true;
			cellData.iconData.showNums = true;
			cellData.iconData.showToolTip = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showLevel = true;

			gridData.cellData = cellData;

			_itemGrid = new ItemGrid(gridData);
			addChild(_itemGrid);
		}

		private function addPrice() : void
		{
			_priceInput = UICreateUtils.createGTextInput({width:168, height:24, x:19, y:192, restrict:"0-9", hintText:"可输入给对方的元宝", maxChars:20, indent:22});
			addChild(_priceInput);

			var icon : Sprite = UIManager.getUI(new AssetData(UI.MONEY_ICON_GOLD));
			icon.x = 24;
			icon.y = 197;
			addChild(icon);
		}

		private function addMessage() : void
		{
			 _messageInput = UICreateUtils.createGTextInput({width:168, height:42, x:19, y:216, hintText:"可输入给对方的留言", maxChars:40, wordWrap:true, indent:40});
			addChild(_messageInput);

			addChild(UICreateUtils.createTextField(null, "<b>留言：</b>", 100, 20, 22, 220));
		}

		// =====================
		// @更新
		// =====================
		private function updateInputs() : void
		{
			if (_mode == TEXT_MODE)
			{
				_priceInput.enabled = false;
				_messageInput.enabled = false;
			}
			else if (_mode == INPUT_MODE)
			{
				_priceInput.enabled = true;
				_messageInput.enabled = true;
			}
		}

		private function updateItemGrid() : void
		{
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			_priceInput.addEventListener(Event.CHANGE, numsFocusOutHandler);
		}

		override protected function onHide() : void
		{
			_priceInput.removeEventListener(Event.CHANGE, numsFocusOutHandler);
			_priceInput.text = "";
			_messageInput.text = "";
			super.onHide();
		}

		private function numsFocusOutHandler(event : Event) : void
		{
			var input : GTextInput = _priceInput;
			var nums : uint = uint(input.text);

			if (!input.text)
			{
				_priceInput.text = "";
			}
			else if (nums > UserData.instance.gold)
			{
				_priceInput.text = UserData.instance.gold.toString();
			}
			else
			{
				_priceInput.text = String(nums);
			}
		}
	}
}
