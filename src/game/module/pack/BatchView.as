package game.module.pack
{
	import game.core.item.Item;
	import game.core.user.StateManager;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.net.core.Common;
	import game.net.data.CtoC.CCHeroPanelOpen;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.itemgrid.ItemCellEvent;
	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;

	import flash.events.MouseEvent;





	/**
	 * @author yangyiqiang
	 */
	public class BatchView extends GCommonSmallWindow
	{
		// =====================
		// 属性
		// =====================
		private var _itemList : Array /* of Item */;
		private var _packView : PackView;
		private var _itemsPanel : GPanel;
		private var _itemGrid : ItemGrid;
		private var _sellButton : GButton;

		// =====================
		// Getter/Setter
		// =====================
		public function get itemList() : Array /* of Item */
		{
			return _itemList;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function BatchView(value : PackView)
		{
			_packView = value;

			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 259;
			data.height = 397;
			data.parent = ViewManager.instance.uiContainer;
			data.allowDrag = false;
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			title = "批量出售";
			_itemList = [];
			addItemsPanel();
			addButtons();
			addItemGrid();
		}

		private function addItemsPanel() : void
		{
			var data : GPanelData = new GPanelData();
			data.bgAsset = new AssetData(UI.PANEL_BACKGROUND);
			data.x = 5;
			data.y = 3;
			data.width = 249;
			data.height = 389;
			_itemsPanel = new GPanel(data);
			contentPanel.addChild(_itemsPanel);
			// refresh();
		}

		private function addButtons() : void
		{
			var data : KTButtonData = new KTButtonData();
			_sellButton = new GButton(data);
			_sellButton.text = "全部出售";
			_sellButton.x = 85;
			_sellButton.y = 353;
			_itemsPanel.addChild(_sellButton);
		}

		private function addItemGrid() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 9;
			gridData.y = 16;
			gridData.allowDrag = false;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 6;
			gridData.columns = 4;
			gridData.hgap = 6;
			gridData.vgap = 6;
			gridData.padding = 6;
			gridData.cell = ItemGridCell;
			gridData.verticalScrollPolicy = GPanelData.ON;

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 48;
			cellData.height = 48;
			cellData.allowSelect = true;
			cellData.iconData.showToolTip = true;
			cellData.iconData.showBg = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showBinding = true;
			cellData.iconData.showRollOver = true;
			cellData.iconData.showLevel = true;
			cellData.iconData.showNums = true;

			gridData.cellData = cellData;
			gridData.scrollBarData.visible = true;
			gridData.scrollBarData.movePre = 1;
			gridData.scrollBarData.wheelSpeed = 1;

			_itemGrid = new ItemGrid(gridData);
			_itemsPanel.add(_itemGrid);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		public function removeItem(value : Item) : void
		{
			_itemList.splice(_itemList.indexOf(value), 1);
			refresh();
		}

		public function addItem(item : Item) : void
		{
			_itemList[_itemList.length] = item;
			refresh();
		}

		public function addItems(value : Array/* of Item */) : void
		{
			_itemList = _itemList.concat(value);
			refresh();
		}

		public function refresh() : void
		{
			if (!_itemsPanel || !_itemList) return;
			_itemGrid.source = _itemList;
			// _itemsPanel.setData(_itemList);
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			_sellButton.addEventListener(MouseEvent.CLICK, onSellAll);
			_itemGrid.addEventListener(ItemCellEvent.SELECT, onCallClick, true);
			Common.game_server.addCallback(0xFFF5, onHeroPanelOpen);
		}

		override protected function onHide() : void
		{
			_sellButton.removeEventListener(MouseEvent.CLICK, onSellAll);
			_itemGrid.removeEventListener(ItemCellEvent.SELECT, onCallClick, true);
			Common.game_server.removeCallback(0xFFF5, onHeroPanelOpen);
			super.onHide();
		}

		private function onSellAll(event : MouseEvent) : void
		{
			if (_itemList.length == 0)
				hide();
			else
				StateManager.instance.checkMsg(250, null, onConfirmSell);
		}

		private function onConfirmSell(type : String) : Boolean
		{
			if (type == Alert.YES_EVENT || type == Alert.OK_EVENT)
			{
				ManagePack.sellItem(_itemList.slice());
				_itemList = [];
				hide();
			}

			return true;
		}

		private function onCallClick(event : ItemCellEvent) : void
		{
			_itemList.splice(_itemList.indexOf(event.item), 1);
			refresh();
			_packView.addItem(event.item);
		}

		private function onHeroPanelOpen(msg : CCHeroPanelOpen) : void
		{
			if (msg.status)
				this.hide();
		}

		override public function show() : void
		{
			PackVariable.isBattch = true;
			super.show();
		}

		override public function hide() : void
		{
			PackVariable.isBattch = false;
			super.hide();
			_itemGrid.source = [];
			if (_itemList.length > 0)
			{
				_packView.addItems(_itemList);
				_itemList.splice(0, _itemList.length);
			}
			
			if (_packView)
				_packView.closeBatchView();
		}
	}
}
