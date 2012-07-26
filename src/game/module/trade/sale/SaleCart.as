package game.module.trade.sale
{
	import com.utils.TextFormatUtils;
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.icon.ItemIcon;
	import com.commUI.icon.ItemIconData;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.core.item.IUnique;
	import game.core.item.equipable.EquipableItem;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoS.CSStartSale;
	import game.net.data.StoC.SCStartSale;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GImage;
	import gameui.controls.GTextInput;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;








	/**
	 * @author zhengyuhang
	 */
	public class SaleCart extends GPanel
	{
		// 重构笔记
		// 留给Zhengyuhang
		// saleItem 函数里面有Bug，Jian先改起来
		// =====================
		// @定义
		// =====================
		private static const SALE_COST : uint = 100;
		// =====================
		// @属性
		// =====================
		private var _itemname : String = "";
		private var _countText : GTextInput;
		private var _priceText : GTextInput;
		private var _itemImage : GImage;
		private var _names : Array = new Array();
		private var _counts : Array = new Array();
		private var _price : Array = new Array();
		private var _usersaleitem : SaleVO;
		private var _maxButton : GButton;
		private var _itemIcon : ItemIcon;
		private var _cleanBtn : GButton;
		private var _saleBtn : GButton;
		private var _myEvent : EventSale;
		private var _saleItem : Boolean = true;
		
		private var _title1:TextField;
		private var _title2:TextField;
		private var _titleCount:TextField;
        private var _titlePrice:TextField;
		
		private var _itemNameText:TextField;
		// =====================
		// @创建
		// =====================
		public function SaleCart()
		{
			_data = new GPanelData();
			_data.width = 224;
			_data.height = 169;
			_data.x = UIManager.stage.stageWidth / 2 - 150;
			_data.y = UIManager.stage.stageHeight / 2 - 65;
			_data.parent = UIManager.root;
			_data.modal = true;
			_data.bgAsset = new AssetData(UI.COMMON_BACKGROUND05);
			super(_data);
			initView();
			initEvent();
		}

		private function initView() : void
		{
			addbg();
			addButton();
		//	addTextFiled("寄售所需手续费:", TextFormatAlign.CENTER, 110, 20, 18, 12, 12, 0x2f1f00);
//			addTextFiled("100", TextFormatAlign.CENTER, 40, 20, 120, 12, 12, 0x2f1f00);
//			addTextFiled("寄售数量:", TextFormatAlign.CENTER, 56, 18.5, 74, 64, 12, 0x2f1f00);
//			addTextFiled("寄售价格:", TextFormatAlign.CENTER, 56, 18.5, 74, 90, 12, 0x2f1f00);
			_title1=UICreateUtils.createTextField("寄售所需手续费:",null,110, 20, 18, 12,TextFormatUtils.panelContent);			
			addChild(_title1);
			_title2=UICreateUtils.createTextField("100",null,40, 20, 120, 12,TextFormatUtils.panelContent);			
			addChild(_title2);
			_titleCount=UICreateUtils.createTextField("寄售数量:",null,80, 18.5, 74, 64,TextFormatUtils.panelContent);			
			addChild(_titleCount);
			_titlePrice=UICreateUtils.createTextField("寄售价格:",null,80, 18.5, 74, 90,TextFormatUtils.panelContent);			
			addChild(_titlePrice);
			
			_countText = UICreateUtils.createGTextInput({text:"1", width:70, x:135, y:62, restrict:"0-9", maxChars:2, selectAll:true, indent:20, maxNum:99});
			_priceText = UICreateUtils.createGTextInput({text:"", width:70, x:135, y:88, restrict:"0-9", maxChars:6, selectAll:true, indent:20, maxNum:999999});

			addChild(_countText);
			addChild(_priceText);
//			addTextFiled(_itemname, TextFormatAlign.CENTER, 107, 18.5, 74, 42, 12, 0x2f1f00, 1);
			_itemNameText=UICreateUtils.createTextField(_itemname,null,107, 18.5, 74, 42);			
			addChild(_itemNameText);
			
			addMaxCountButton();

			var goldbg : Sprite = UIManager.getUI(new AssetData(UI.MONEY_ICON_GOLD));
			goldbg.width = 13;
			goldbg.height = 11;
			goldbg.x = 140;
			goldbg.y = 95;
			addChild(goldbg);

			_countText.addEventListener(Event.CHANGE, countInputHandler);
			_priceText.addEventListener(Event.CHANGE, priceInputHandler);
		}

		private function initEvent() : void
		{
			_countText.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
		}

		/******************************************************************
		 *鼠标失去焦点事件
		 *******************************************************************/
		private function focusOutHandler(event : FocusEvent) : void
		{
			if ( _countText.text == "")
				_countText.text = "1";
		}

		/******************************************************************
		 * 添加背景
		 *******************************************************************/
		private function addbg() : void
		{
			var panelBg : Sprite = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));
			panelBg.width = 207.5;
			panelBg.height = 76;
			panelBg.x = 9;
			panelBg.y = 40;
			addChild(panelBg);

			// var editBg1 : Sprite = UIManager.getUI(new AssetData(UI.TRADE_SHOPCART_EDITBG));
			// editBg1.width = 70;
			// editBg1.height = 18.5;
			// editBg1.x = 132;
			// editBg1.y = 66;
			// addChild(editBg1);
			//
			setImage();
			//
			// var editBg2 : Sprite = UIManager.getUI(new AssetData(UI.TRADE_SHOPCART_EDITBG));
			// editBg2.width = 70;
			// editBg2.height = 18.5;
			// editBg2.x = 132;
			// editBg2.y = 86;
			// _content.addChild(editBg2);

			var moneybg : Sprite = UIManager.getUI(new AssetData(UI.MONEY_ICON_SILVER));
			moneybg.width = 11;
			moneybg.height = 11;
			moneybg.x = 110;
			moneybg.y = 14;
			addChild(moneybg);
		}

		// private var _counttext
		/******************************************************************
		 * 点击背包中的物品之后 刷新物品
		 *******************************************************************/
		public function refreshItem(usersaleitem : SaleVO) : void
		{
			_usersaleitem = usersaleitem;
			_usersaleitem.item.nums = usersaleitem.item.nums;
			var num : int = _usersaleitem.item.nums;
			_itemNameText.htmlText = StringUtils.addColorById(_usersaleitem.item.name, _usersaleitem.item.color);

			_countText.text = "1";
			_countText.enabled = (_usersaleitem.item.stackLimit > 1);
			_maxButton.visible = (_usersaleitem.item.stackLimit > 1);
			_priceText.text = "";
			_itemIcon.source = _usersaleitem.item;
		}

		/******************************************************************
		 * 设置最大数量按钮响应事件
		 *******************************************************************/
		private function addMaxCountButton() : void
		{
			var buttonData : GButtonData = new GButtonData();
			buttonData.upAsset = new AssetData(UI.TRADE_MAXBTN_UP);
			buttonData.overAsset = new AssetData(UI.TRADE_MAXBTN_OVER);
			buttonData.downAsset = new AssetData(UI.TRADE_MAXBTN_DOWN);
			buttonData.disabledAsset = new AssetData("EnterButtonSkin_Disable");
			buttonData.width = 16;
			buttonData.height = 20;
			buttonData.x = 186;
			buttonData.y = 64;
			_maxButton = new GButton(buttonData);

//			for (var index : int = _maxButton.numChildren - 1; index >= 0; index--)
//			{
//				var child : DisplayObject = _maxButton.getChildAt(index);
//				with (_maxButton.graphics)
//				{
//					lineStyle(1);
//					drawRect(child.x, child.y, child.width, child.height);
//				}
//			}

			addChild(_maxButton);
			_maxButton.addEventListener(MouseEvent.CLICK, maxButtonHandler);
		}

		/******************************************************************
		 * 设置物品的图片
		 *******************************************************************/
		private function setImage() : void
		{
			var _itemData : ItemIconData = new ItemIconData();
			_itemData.x = 16;
			_itemData.y = 45;

			_itemData.showToolTip = true;
			_itemData.showBorder = true;
			_itemData.showLevel = true;

			_itemIcon = new ItemIcon(_itemData);
			addChild(_itemIcon);
		}

		/******************************************************************
		 * 文本框函数
		 *******************************************************************/
		private function addTextFiled(text : String, align : String, width : int, height : int, x : int, y : int, size : int, color : Object, type : int = 0) : TextField // type为1时 指名字对话框
		{
			var textField : TextField = new TextField();
			var format : TextFormat = new TextFormat();

			format.size = size;
			format.color = color;
			format.align = align;
			textField.mouseEnabled = false;
			textField.wordWrap = true;

			textField.width = width;
			textField.height = height;
			textField.text = text;

			textField.setTextFormat(format);
			textField.x = x;
			textField.y = y;
			if (type == 1)
			{
				_names.push(textField);
			}

			addChild(textField);
			return textField;
		}

		/******************************************************************
		 * 添加按钮
		 *******************************************************************/
		private function addButton() : void
		{
			var data : KTButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
			data.width = 72;
			data.height = 24;
			data.x = 30;
			data.y = 130;
			_saleBtn = new GButton(data);
			_saleBtn.text = "开始寄售";
			_saleBtn.addEventListener(MouseEvent.CLICK, onButtonSaleClick);
			addChild(_saleBtn);

			data.x = 120;
			_cleanBtn = new GButton(data);
			_cleanBtn.text = "取消";
			_cleanBtn.addEventListener(MouseEvent.CLICK, onButtoncleanClick);
			addChild(_cleanBtn);
		}

		/******************************************************************
		 *相应出售事件 派发消息给服务器
		 *******************************************************************/
		private function onButtonSaleClick(event : MouseEvent) : void
		{
			if (_countText.text == "")
			{
				StateManager.instance.checkMsg(53);
				return;
			}

			var saleCount : int = int(_countText.text);
			var salePrice : int = int(_priceText.text);

			if (salePrice > 999999 || salePrice <= 0)
			{
				StateManager.instance.checkMsg(53);
				return;
			}

			if (UserData.instance.silver < SALE_COST)
			{
				StateManager.instance.checkMsg(129);
				return;
			}

			StateManager.instance.checkMsg(56, [], okFun);
			// saleItem();
		}

		private function saleItem() : void
		{
			_myEvent = new EventSale(EventSale.ADD_MYITEM);

			_usersaleitem.salePrice = int(_priceText.text);
			_usersaleitem.item.nums = int(_countText.text);
			var num : int = _usersaleitem.item.nums;

			var cmd : CSStartSale = new CSStartSale();
			if (_saleItem == true)
			{
				if (_usersaleitem.item is EquipableItem)
				{
					cmd.itemid = _usersaleitem.item.id;
					cmd.price = _usersaleitem.salePrice;
					cmd.param = (_usersaleitem.item as EquipableItem).uuid;
					Common.game_server.sendMessage(0xB5, cmd);
				}
				else
				{
					cmd.itemid = _usersaleitem.item.id;
					cmd.price = _usersaleitem.salePrice;
					cmd.param = _usersaleitem.item.nums;
					Common.game_server.sendMessage(0xB5, cmd);
				}

				_saleItem = false;
			}
			_myEvent.voSaleItem = _usersaleitem;
			Common.game_server.addCallback(0xb5, saleSucess);
		}

		private function okFun(type : String) : Boolean
		{
			switch(type)
			{
				case Alert.OK_EVENT:
				case Alert.YES_EVENT:
					saleItem();
					break;
			}
			return true;
		}

		/******************************************************************
		 * 在收到出售成功消息后 派发消息到myshop界面
		 *******************************************************************/
		private function saleSucess(event : SCStartSale) : void
		{
			// Alert.show("出售成功");
			// StateManager.instance.checkMsg(53);
			_saleItem = true;
			_myEvent.voSaleItem.id = event.saleid;
			dispatchEvent(_myEvent);
			this.hide();
		}

		private function onButtoncleanClick(event : MouseEvent) : void
		{
			this.hide();
		}

		private function countInputHandler(event : Event) : void
		{
			var saleCount : int = int(_countText.text);

			if (saleCount > _usersaleitem.item.nums)
			{
				// //trace("--------------------->>>>>>>>>"+_usersaleitem.item.nums);
				_countText.text = _usersaleitem.item.nums.toString();
				return;
			}
			else if (_countText.text == "0")
			{
				_countText.text = "1";
			}
		}

		private function priceInputHandler(event : Event) : void
		{
			if (_countText.text == "0")
			{
				_countText.text = "1";
			}
		}

		/******************************************************************
		 * 当前物品最大数量按钮响应
		 *******************************************************************/
		private function maxButtonHandler(event : MouseEvent) : void
		{
			var num : int = _usersaleitem.item.nums;
			_countText.text = num.toString();
		}

		private function addEditFiled(text : String, align : String, width : int, height : int, x : int, y : int, size : int, color : Object, maxChars : int = 0, type : Boolean = false, cnt : int = 0) : TextField // cnt2表示数量 3表示价格框
		{
			var textField : TextField = new TextField();
			var format : TextFormat = new TextFormat();

			format.size = size;
			format.color = color;
			format.align = align;
			textField.mouseEnabled = true;
			textField.wordWrap = false;

			textField.width = width;
			textField.height = height;
			textField.text = text;

			textField.setTextFormat(format);
			textField.x = x;
			textField.y = y;
			textField.maxChars = maxChars;
			if (type == true)
			{
				textField.type = TextFieldType.INPUT;
			}

			if (cnt == 2)
			{
				_counts.push(textField);
				textField.restrict = "0-99";
			}
			else if (cnt == 3)
			{
				_price.push(textField);
				textField.restrict = "0-999999";
			}
			addChild(textField);
			return textField;
		}
	}
}
