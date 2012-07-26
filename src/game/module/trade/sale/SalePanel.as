package game.module.trade.sale
{
	import com.commUI.button.KTButtonData;
	import com.commUI.itemgrid.ItemCellEvent;
	import com.commUI.itemgrid.ItemGridCell;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	import game.core.item.IUnique;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.equipment.Equipment;
	import game.core.item.soul.Soul;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.module.trade.VTabbedPack;
	import game.net.core.Common;
	import game.net.data.CtoS.CSSaleReceiveAll;
	import game.net.data.CtoS.CSSaleState;
	import game.net.data.CtoS.CSSelfSale;
	import game.net.data.StoC.SCResell;
	import game.net.data.StoC.SCSaleState;
	import game.net.data.StoC.SCSelfSale;
	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.controls.GList;
	import gameui.data.GLabelData;
	import gameui.data.GListData;
	import gameui.data.GPanelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;





	/**
	 * @author zhengyuhang
	 */
	public class SalePanel extends GPanel
	{
		
		// =====================
		// @定义
		// =====================
		// 过期数量 当前寄售物品中的过期数量
		private var _timeout_item : int = 0;
		// =====================
		// @属性
		// =====================
		private var _salePanel : SaleCart;
		private var _vo : UserData = UserData.instance;
		private var _tabbedPack : VTabbedPack;
		private var outDataBtn_Label : GLabel;
		private var initUserItem : SaleVO = new SaleVO();
		private var initUserItems : Vector.<SaleVO>=new Vector.<SaleVO>();
		private var _itemList : GList;
		private var items : Array = new Array();
		// =====================
		// @创建
		// =====================
		public function SalePanel()
		{
			// _topType = Item.EXPEND;
			//trace("SalePanel Construct from:" + getTimer());
			var data : GPanelData = new GPanelData();
			data.width = 619;
			data.height = 350;
		    data.bgAsset = new AssetData(UI.TRADE_BACKGROUND_BIG);
			super(data);
			initView();
			//trace("SalePanel Construct to:" + getTimer());
		}



		private function initView() : void
		{
			addBg();
			addLabel();
			addButton();
			addMyPack();
			addSaleList();
		}


		/******************************************************************
		 * 添加提示文本
		 *******************************************************************/
		private function addLabel() : void
		{
			var _data : GLabelData = new GLabelData();
			_data.width = 162;
			_data.height = 18;
			_data.x = 37;
			_data.y = 5;
			_data.textFieldFilters = [];
			outDataBtn_Label = new GLabel(_data);
			outDataBtn_Label.text = "<font color='#2F1F00'>过期的寄售单，只保存10天</font>";
//			outDataBtn_Label.text = "<font color='#000000'>完成的交易单，只保存10时间</font>";
			_content.addChild(outDataBtn_Label);

			addText("商品", 28, 20, 70, 32, 12);
			addText("数量", 28, 20, 159, 32, 12);
			addText("价格", 28, 20, 210, 32, 12);
			addText("操作", 28, 20, 340, 32, 12);
		}

		private var _deleteall_Btn : GButton;

		/******************************************************************
		 * 添加全部收取按钮
		 *******************************************************************/
		private function addButton() : void
		{
			var data : KTButtonData = new KTButtonData(KTButtonData.NORMAL_BUTTON);
			data.width = 80;
			data.height = 30;
			data.x = 175;
			data.y = 315;
			_deleteall_Btn = new GButton(data);
			_deleteall_Btn.text = "全部收取";
			_deleteall_Btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			addChild(_deleteall_Btn);
			_deleteall_Btn.hide();
		}

		/******************************************************************
		 * 响应背包中的物品点击事件
		 *******************************************************************/

		
		
		private function onAddList(event : EventSale) : void
		{
			StateManager.instance.checkMsg(55);
			_itemList.model.insert(_timeout_item, event.voSaleItem);

			var cell : SaleListCell;
			var i : int = 0;
			var m : int;
			var arr : Array = _itemList._cells;
			var max : int = arr.length;

			// 刷新list控件的背景
			for (m = 0;m < max;m++)
			{
				_itemList.content.addChildAt(arr[m], m);
			}
			while (i < _itemList.content.numChildren)
			{
				cell = _itemList.content.getChildAt(i) as SaleListCell;
				cell.updateBackground(i);
				i++;
			}
		}

		private function addBg() : void
		{
			// 解释图标
			var panelBg : Sprite = UIManager.getUI(new AssetData(UI.ICON_HINT));
			panelBg.x = 20;
			panelBg.y = 10;
			_content.addChild(panelBg);

			// 商品深色面板
			var itemListNameBg : Sprite = UIManager.getUI(new AssetData(UI.TRADE_LISTNAMEBG));
			itemListNameBg.width = 427;
			itemListNameBg.height = 25;
			itemListNameBg.x = 5;
			itemListNameBg.y = 30;
			_content.addChild(itemListNameBg);
			
			// 小白条上
			var panelBg1 : Sprite = UIManager.getUI(new AssetData(UI.TRADE_MARKET_WHITELINE));
			panelBg1.width = 428;
			panelBg1.height = 2;
			panelBg1.x = 6;
			panelBg1.y = 55;
			//_content.addChild(panelBg1);
			
			// 小白条上上
			var panelBg2: Sprite = UIManager.getUI(new AssetData(UI.TRADE_MARKET_WHITELINE));
			panelBg2.width = 428;
			panelBg2.height = 1;
			panelBg2.x = 6;
			panelBg2.y = 28;
			_content.addChild(panelBg2);
			
			// 小白条下
			var panelBg3 : Sprite = UIManager.getUI(new AssetData(UI.TRADE_MARKET_WHITELINE));
			panelBg3.width = 428;
			panelBg3.height = 2;
			panelBg3.x = 6;
			panelBg3.y = 308;
			_content.addChild(panelBg3);
		}

		/******************************************************************
		 * 初始化列表文件，在收到服务器发送的我的商品列表信息时进行刷新
		 *******************************************************************/
		private function initMyShop(event : SCSelfSale) : void
		{
			_itemList.model.clear();
			var i : int = 0;
			while (i < event.sale.length)
			{
				var count : int;
				var itemid : int = event.sale[i].item;
				initUserItem = new SaleVO();
				initUserItem.id = event.sale[i].id;
				var item : Item = ItemManager.instance.newItem(itemid);
				if (item is Equipment)
				{
					(item as Equipment).enhanceLevel = event.sale[i].param;
					count = 1;
				}
				else if (item is Soul)
				{
					count = 1;
				}
				else
				{
					count = event.sale[i].param;
				}

				if (event.sale[i].status == 4)
				{
					_timeout_item++;
					initUserItem.time_outdays = event.sale[i].expired;
				}

				initUserItem.saleStatus = event.sale[i].status;
				initUserItem.item = item;
				initUserItem.item.nums = count;
				initUserItem.background = i % 2;
				initUserItem.salePrice = event.sale[i].price;

				initUserItem.ownerName = UserData.instance.playerName;
				_itemList.model.insert(i, initUserItem);
				i++;
				initUserItems.push(initUserItem);
			}

			var j : int = 0;
			while (j < _itemList.content.numChildren)
			{
				(_itemList.content.getChildAt(j) as SaleListCell).updateBackground(j);
				j++;
			}
			if (_timeout_item > 0)
			{
				//_deleteall_Btn.enabled = true;
				_deleteall_Btn.show();
			}
		}

		/***************************************************************
		 * 背包事件处理
		 ***************************************************************/
		private function addMyPack() : void
		{
			_tabbedPack = new VTabbedPack();
			_tabbedPack.x = 435;
			_tabbedPack.y = 0;
			addChild(_tabbedPack);
		}


		
		private function addListBg():void
		{

		}

		/******************************************************************
		 * 添加我在出售物品的列表
		 *******************************************************************/
		private function addSaleList() : void
		{
			var listData : GListData = new GListData();
			listData.x = 5;
			listData.y = 57;
			listData.width = 423;
			listData.height = 250;
			listData.allowDrag = false;
			listData.bgAsset = new AssetData(SkinStyle.emptySkin);
			listData.rows = 0;
			listData.padding = 0;
			listData.hGap = 0;
			listData.cell = SaleListCell;
			listData.enabled = true;
			listData.verticalScrollPolicy=GPanelData.ON;
			listData.scrollBarData.wheelSpeed = 9;

			var cellData : GCellData = new GCellData();
			cellData.width = 410;
			cellData.height = 50;
			cellData.enabled = true;
			cellData.selected_upAsset = null;

			listData.cellData = cellData;
			_itemList = new GList(listData);
			_itemList.model.max = -1;
			addChild(_itemList);
			
			var listBg : Sprite = UIManager.getUI(new AssetData(UI.TRADE_BACKGROUND_ITEMLIST));
			listBg.width = 413;
			listBg.height = 250;
			listBg.x = 0;
			listBg.y = 0;
            _itemList.addChildAt(listBg,0);
			_salePanel = new SaleCart();
		}

		private var _upDateItem : SaleVO;


		// =====================
		// @更新
		// =====================

		/******************************************************************
		 * 接收listitem中发送过来的更改商品状态的信息，按钮“收取和撤销”点击事件
		 *******************************************************************/
		// 接收状态更新消息
		private function onUpdateStaeus(event : EventSale) : void
		{
			_upDateItem = new SaleVO();
			_upDateItem = event.voSaleItem;

			var cmd1 : CSSaleState = new CSSaleState();
			cmd1.tradeid = event.voSaleItem.id;
			cmd1.status = event.status;
			Common.game_server.sendMessage(0xB8, cmd1);
		}

		/******************************************************************
		 * 接收重新寄售的服务器信息，并进行相应的处理
		 *******************************************************************/
		

		/******************************************************************
		 * 相应刷新状态的服务器信息，并进行相应的处理
		 *******************************************************************/
		private function refreshStatus(event : SCSaleState) : void
		{
			// Alert.show("修改状态成功");
			if (event.status == 3)
			{
				// 滚屏由服务器来做
				// StateManager.instance.checkMsg(163);
				_timeout_item--;
				if (_timeout_item == 0)             // 判断超时的物品个数，如果个数为0，则将全部收取按钮置灰
				{
			        _deleteall_Btn.hide();
				}
			}
			else
			  {
				// 滚屏由服务器来做
				// StateManager.instance.checkMsg(54);
				//				//  修改状态成功弹框
			  }
			_itemList.model.remove(_upDateItem);
			var cell : SaleListCell;

			var i : int = 0;
			var m : int;
			var arr : Array = _itemList._cells;
			var max : int = arr.length;
			for (m = 0;m < max;m++)
			{
				_itemList.content.addChildAt(arr[m], m);
			}
			while (i < _itemList.content.numChildren)
			{
				cell = _itemList.content.getChildAt(i) as SaleListCell;
				cell.updateBackground(i);
				i++;
			}
		}
		// =====================
		// @交互
		// =====================
		
		
				// 事件初始化
		override protected function onShow() : void
		{
			super.onShow();
			_tabbedPack.addEventListener(ItemCellEvent.SELECT, onCallClick, true);
			_itemList.addEventListener(EventSale.UPDATESATUS_MYITEM, onUpdateStaeus);
			Common.game_server.addCallback(0xb8, refreshStatus);
			Common.game_server.addCallback(0xbe, reSale);
			Common.game_server.addCallback(0xB6, initMyShop);
			// 监听item结束信息
			var cmd : CSSelfSale = new CSSelfSale();
			cmd.begin = 0;
			Common.game_server.sendMessage(0xB6, cmd);
			_tabbedPack.updateView();
			_timeout_item=0;
		}

		override protected function onHide() : void
		{
			_salePanel.hide();
			super.onHide();
			_tabbedPack.removeEventListener(ItemCellEvent.SELECT, onCallClick, true);
			_itemList.removeEventListener(EventSale.UPDATESATUS_MYITEM, onUpdateStaeus);
			// _comboBox.selectionModel.removeEventListener(Event.CHANGE, colorSelectHandler);
		}
		
		
	    private function onCallClick(event : Event) : void
		{
			// var item:Item = _itemGrid.model.getAt(_itemGrid.selectionModel.index) as Item;
			var usersaleitem : SaleVO = new SaleVO();
			var item : Item = (event.target as ItemGridCell).source as Item;
			usersaleitem.item = ItemManager.instance.newItem(item.id, item.binding);
			usersaleitem.item.nums = item.nums;
			if (item is IUnique)
				(usersaleitem.item as IUnique).uuid = (item as IUnique).uuid ;

			usersaleitem.ownerName = _vo.playerName;
			_salePanel.show();
			_salePanel.refreshItem(usersaleitem);
			_salePanel.addEventListener(EventSale.ADD_MYITEM, onAddList);
			// arr.push(event);
		}
		
		private function reSale(event : SCResell) : void
		{
			// Alert.show("重新寄卖成功");
			StateManager.instance.checkMsg(55);
			// 重新寄卖成功

			var newitem : SaleVO = new SaleVO();
			newitem = _upDateItem;
			_itemList.model.remove(_upDateItem);
			newitem.saleStatus = 0;
			newitem.id = event.postid;
			_timeout_item--;
			_itemList.model.insert(_timeout_item, newitem);

			if (_timeout_item == 0)                              // 判断超时的物品个数，如果个数为0，则将全部收取按钮置灰
			{
				//_deleteall_Btn.enabled = false;
				_deleteall_Btn.hide();
			}
			var cell : SaleListCell;
			var i : int = 0;
			var m : int;
			var arr : Array = _itemList._cells;
			var max : int = arr.length;

			for (m = 0;m < max;m++)                                              // 更新用户物品列表的背景
			{
				_itemList.content.addChildAt(arr[m], m);
			}
			while (i < _itemList.content.numChildren)
			{
				cell = _itemList.content.getChildAt(i) as SaleListCell;
				cell.updateBackground(i);
				i++;
			}
		}
		
		/******************************************************************
		 * 响应全部收取按钮的事件
		 *******************************************************************/
		private function onButtonClick(event : Event) : void
		{
			var cmd : CSSaleReceiveAll = new CSSaleReceiveAll();
			Common.game_server.sendMessage(0xBf, cmd);

			// 全部收取后状态变化
			//_deleteall_Btn.enabled = false;
			_deleteall_Btn.hide();
			_timeout_item = 0;
			_itemList.source = [];
		}
		// =====================
		// @其他
		// =====================
		/******************************************************************
		 * 添加文本框函数
		 *******************************************************************/
		private function addText(text : String, width : int, height : int, x : int, y : int, size : int) : TextField
		{
			var textField : TextField = new TextField();
			var format : TextFormat = new TextFormat();
			format.size = size;
			format.color = 0xffffff;
			format.align = TextFormatAlign.CENTER;
			format.font = UIManager.defaultFont;
			textField.mouseEnabled = false;
			textField.width = width;
			textField.height = height;
			textField.text = text;
			textField.x = x;
			textField.y = y;

			textField.setTextFormat(format);
			addChild(textField);
			return textField;
		}

		override public function show() : void
		{
			super.show();
			GLayout.layout(this);
		}

		override public function hide() : void
		{
			super.hide();
		}
	}
}
