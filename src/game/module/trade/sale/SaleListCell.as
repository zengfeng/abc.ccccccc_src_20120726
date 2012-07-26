package game.module.trade.sale
{
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.icon.ItemIcon;
	import com.commUI.icon.ItemIconData;
	import com.commUI.tooltip.ToolTipData;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.net.data.StoC.SCSaleState;
	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;









	/**
	 * @author zhenyuhang
	 */
	public class SaleListCell extends GCell
	{
		// 重构笔记
		// 1. 参考TradeMySaleItem.as, GoodsListItem.as
		// 2. ToolTip要使用新的方法
		// 3. 非私有成员不要用带"_" prefix的命名
		// 4. 将_statusPanel改为GComponent
		// 5. 重命名 button1, button2，这里的逻辑有点复杂，能否使用多个按钮解决问题？
		// 6. 很多地方调用hide, show方法，Review一下
		// 7. filters 并没有被使用，注销掉
		// 8. 请将VoUserSaleItem.saleStatus的数值定义为常量，否则很难理解
		// 9. recv -> cancel 以免混淆
		// 10. Yuhang, 寄售需要在客户端判断银币是否够
		
		// private var _name : TextField;
		// private var _itemImage : GImage;
		// private var _names : Array = new Array();
		// private var _counts : Array = new Array();
		// private var _owners : Array = new Array();
		// private var _pricese : Array = new Array();
		// private var clearBtn_Label : GLabel;
		// private var _ownerText:TextField;
		// private var _priceText:TextField;
		// private var _goodsName : String = "";
		// private var _goodsCount : String = "";
		// private var _goodsPrice:String="";
		// private static var _filterOver : Array;
		// private static var _filterUp : Array;
		// private static var _filterOverSelected : Array;
		// private static var _filterUpSelected : Array;
		// private function initFilters() : void
		// {
		// var filterOver : ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 24, 0, 1, 0, 0, 24, 0, 0, 1, 0, 24, 0, 0, 0, 1, 0]);
		// var filterSelected : GlowFilter = new GlowFilter(0xFFFF99, 1, 4, 4, 16);
		// var filterSelected2 : GlowFilter = new GlowFilter(0x000000, 1, 1, 1, 32);
		// _filterOver = [filterOver];
		// _filterUp = [];
		// _filterUpSelected = [filterSelected, filterSelected2];
		// _filterOverSelected = [filterSelected, filterSelected2, filterOver];
		// }
		// =====================
		// @静态
		// =====================
		private static const RESALE_COST : uint = 100;
		// =====================
		// @属性
		// =====================
		private var _itemIcon : ItemIcon;
		private var _statusPanel : GComponent;
		private var _background : Sprite;
		private var _saleButton : GButton;
		private var _fetchButton : GButton;
		private var _nameText : TextField;
		private var _countText : TextField;
		private var _pricePanel : PricePanel;
		private var _newitem : SaleVO;

		// =====================
		// @创建
		// =====================
		public function SaleListCell(data : GCellData)
		{
			data.upAsset = new AssetData(SkinStyle.emptySkin);
			data.overAsset = null;
			data.selected_upAsset = null;
			data.selected_overAsset = null;
			data.disabledAsset = null;
			super(data);
		}

		/*
		 * 重载create函数 对获取data数据 添加面板
		 */
		override protected function create() : void
		{
			super.create();

			addBg();
			addButton();
			addLabel();
			addStatusPanel();
			addItemIcon();
		}

		/*
		 * 根据物品id设置图片的icon
		 */
		private function addItemIcon() : void
		{
			var data : ItemIconData = new ItemIconData();
			data.x = 2;
			data.y = 0.7;
			data.showToolTip = true;
			data.showBorder = true;
			data.showLevel = true;

			_itemIcon = new ItemIcon(data);
			addChild(_itemIcon);
			_itemIcon.hide();
		}

		/*
		 *添加超时信息 将超时信息设置为panel方便隐藏
		 */
		private function addStatusPanel() : void
		{
			var data : GComponentData = new GComponentData();
			data.width = 55;
			data.height =40;
			data.x = 250;
			data.y = 2.3;
			data.toolTipData=new ToolTipData();
			_statusPanel = new GComponent(data);

		//	var ttdata : GToolTipData = new GToolTipData();
		//	_statusPanel.toolTip = new GToolTip(ttdata);

			var outDateIcon : Sprite = UIManager.getUI(new AssetData(UI.TRADE_ITEMTIEMOUT));
			outDateIcon.width = 45;
			outDateIcon.height = 23;
			var hitArea:Sprite = new Sprite();
			hitArea.graphics.beginFill(0xFFFFFF);
			hitArea.graphics.drawRect(0, 0, outDateIcon.width, outDateIcon.height);
			outDateIcon.hitArea = hitArea;
			outDateIcon.mouseChildren = true;
			outDateIcon.mouseEnabled = true;
			outDateIcon.x = 0.5;
			outDateIcon.y = 10.7;			
			_statusPanel.addChild(outDateIcon);

			addChild(_statusPanel);

			_statusPanel.hide();
		}

		private function addBg() : void
		{
			_background = UIManager.getUI(new AssetData(SkinStyle.emptySkin));
			_background.width = 410;
			_background.height = 50;
			_background.x = 0;
			_background.y = 0;
			addChild(_background);
		}

		/*
		 * 添加按钮
		 */
		private function addButton() : void
		{
			var data : KTButtonData= new KTButtonData(KTButtonData.SMALL_BUTTON);
			data.width = 51;
			data.height = 24;
			data.x = 357;
			data.y = 15;
			_saleButton = new GButton(data);
			_saleButton.text = "寄售";
			addChild(_saleButton);
			_saleButton.hide();

			data.x = 302;
			_fetchButton = new GButton(data);
			_fetchButton.text = "收取";

			addChild(_fetchButton);
			_fetchButton.hide();
		}

		/*
		 * 将价格设置为panel  方便使用tooltip
		 */
		private function addLabel() : void
		{
			_nameText = UICreateUtils.createTextField(null, null, 90, 19, 55, 18.2, TextFormatUtils.panelContent);
			_countText = UICreateUtils.createTextField(null, null, 35, 19, 150, 18.2, TextFormatUtils.panelContent);

			_pricePanel = new PricePanel();
			_pricePanel.x = 190;
			_pricePanel.y = 18.2;
		//	_pricePanel.width=20;

			addChild(_nameText);
			addChild(_countText);
			addChild(_pricePanel);
		}

		// =====================
		// @更新
		// =====================
		/*
		 * 收到状态修改事件的同时 决定显示按钮 或者是派发删除事件 没有使用
		 */
		public function updateStatus(event : SCSaleState) : void
		{
			Alert.show("状态修改成功");
			if (event.status == 0)
			{
				_saleButton.text = "撤销";
				_saleButton.name = "cancel";
				_statusPanel.show();
				_fetchButton.hide();
			}
			else if (event.status == 1 || event.status == 1)
			{
				var myEvent : EventSale = new EventSale(EventSale.UPDATESATUS_MYITEM);
				myEvent.itemCell = this;
				dispatchEvent(myEvent);
			}
		}

		/*
		 * 界面刷新操作，根据传入的物品状态 来决定显示的按钮类型和其他参数
		 */
		public function updateLabel() : void
		{
		//	_nameText.text = _newitem.item.name;
		    _nameText.htmlText = StringUtils.addColorById(_newitem.item.name, _newitem.item.color);
			_countText.text = _newitem.item.nums.toString();

			_itemIcon.source = _newitem.item;
			_itemIcon.show();

			_pricePanel.setPrice(_newitem.salePrice.toString());
			_pricePanel.toolTip.source = "元宝" + _newitem.salePrice.toString();
			


			if (_newitem.saleStatus == 4)
			{
				_saleButton.text = "寄售";
				_saleButton.name = "sale";
				_fetchButton.text = "收取";
				_statusPanel.show();
				var outdays:int= _newitem.time_outdays;
				if(outdays==0)
				   outdays=1;
				_statusPanel.toolTip.source = "此物品已过期" + outdays + "天";

				_saleButton.show();
				_fetchButton.show();
			}
			else
			{
				_saleButton.text = "撤销";
				_saleButton.name = "cancel";
				_saleButton.show();
				_fetchButton.hide();
			}
		}

		/*
		 * 背景刷新函数，根据当前条目的奇偶刷新条目背景
		 */
		public function updateBackground(i : int) : void
		{
			if (i % 2 == 0)
			{
				if (_background) this.removeChild(_background);
				_background = UIManager.getUI(new AssetData(UI.TRADE_LIGTH_BACKGRAND));
				_background.height = 50;
				addChildAt(_background, 0);
			}
			else if (i % 2 == 1)
			{
				if (_background) this.removeChild(_background);
				_background = UIManager.getUI(new AssetData(UI.TRADE_DARK_BACKGRAND));
				_background.height = 50;
				addChildAt(_background, 0);
			}
		}

		/*
		 * 读取条目数据 source
		 */
		override public function set source(value : *) : void
		{
			_newitem = value as SaleVO;
			updateLabel();
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			_saleButton.addEventListener(MouseEvent.CLICK, saleButton_clickHandler);
			_fetchButton.addEventListener(MouseEvent.CLICK, fetchButton_clickHandler);
		}

		override protected function onHide() : void
		{
			_saleButton.removeEventListener(MouseEvent.CLICK, saleButton_clickHandler);
			_fetchButton.removeEventListener(MouseEvent.CLICK, fetchButton_clickHandler);
			super.onHide();
		}

		/*
		 * 按钮A点击事件的判断 sale是重新寄售 cancel为收取事件
		 */
		private function saleButton_clickHandler(event : Event) : void
		{
			if (_saleButton.name == "sale")
				StateManager.instance.checkMsg(56, null, confirmResaleHandler);
			else if (_saleButton.name == "cancel")
				StateManager.instance.checkMsg(54, null, confirmCancelHandler, [_newitem.item.id, _newitem.item.nums]);
		}

		private function confirmResaleHandler(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				if (UserData.instance.silver < RESALE_COST)
				{
					StateManager.instance.checkMsg(129);
					return true;
				}

				var myEvent : EventSale;
				myEvent = new EventSale(EventSale.UPDATESATUS_MYITEM);
				myEvent.itemCell = this;
				myEvent.status = 1;
				myEvent.voSaleItem = _newitem;
				dispatchEvent(myEvent);
			}
			return true;
		}

		private function confirmCancelHandler(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				var myEvent : EventSale = new EventSale(EventSale.UPDATESATUS_MYITEM);
				myEvent.status = 0;
				myEvent.voSaleItem = _newitem;
				dispatchEvent(myEvent);
			}
			return true;
		}

		/*
		 * 按钮B点击事件的判断，物品收取事件
		 */
		private function fetchButton_clickHandler(event : Event) : void
		{
			var myEvent : EventSale = new EventSale(EventSale.UPDATESATUS_MYITEM);
			myEvent.status = 2;
			myEvent.voSaleItem = _newitem;
			dispatchEvent(myEvent);
		}

		// =====================
		// @其它
		// =====================
		override protected function viewSkin() : void
		{
		}
	}
}
