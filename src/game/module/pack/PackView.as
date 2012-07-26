package game.module.pack
{
	import com.commUI.GCommonWindow;
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.itemgrid.ItemCellEvent;
	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.ColorUtils;
	import com.utils.ItemUtils;
	import com.utils.StringUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.ItemService;
	import game.core.item.equipment.Equipment;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.pack.merge.MergeView;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import game.net.data.CtoC.CCUserDataChangeUp;
	import game.net.data.CtoS.CSExtendPack;
	import game.net.data.StoC.SCPlayerInfoChange;
	import gameui.cell.LabelSource;
	import gameui.containers.GPanel;
	import gameui.containers.GTabbedPanel;
	import gameui.controls.GButton;
	import gameui.controls.GComboBox;
	import gameui.controls.GLabel;
	import gameui.controls.GTab;
	import gameui.core.GAlign;
	import gameui.core.ScaleMode;
	import gameui.data.GButtonData;
	import gameui.data.GComboBoxData;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GTabbedPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;





	/**
	 * @author yangyiqiang
	 */
	public class PackView extends GCommonWindow
	{
		// =====================
		// 属性
		// =====================
		private var _tabbedPanel : GTabbedPanel;
		private var _itemsPanel : GPanel;
		private var _comboBox : GComboBox;
		// private var _backIoc : Sprite;
		private var _cachedItems : Array /* of Item */;
		private var _batchView : BatchView;
		private var _mergeButton : GButton;
		private var _batchButton : GButton;
//		private var _expandButton : GButton;
		private var  _expandButtonBg : Sprite;
		private var _packLabel : GLabel;
		// private var _listPanel : PackListPanel;
		private var _itemGrid : ItemGrid;
		private var _batchClickTime : uint;
		private var _selectedTopType : uint;
		private var  _lastPackCurrent : uint;
		private var _lastPackTotal : uint;

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function PackView()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 373;
			data.height = 435;
			data.parent = ViewManager.instance.uiContainer;
			data.panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			title = "包裹";

			_batchClickTime = getTimer();
			addTabbedPanel();

			addMergeButton();

			addBatchButton();
			addExpendButton();
			addLabel();
			addItemGrid();
			addComboBox();
		}

		private function addTabbedPanel() : void
		{
			var panelData : GPanelData = new GPanelData();
			panelData.bgAsset = new AssetData(UI.PANEL_BACKGROUND);
			panelData.x = 5;
			panelData.y = 0;
			panelData.width = 358;
			panelData.height = 406;
			_itemsPanel = new GPanel(panelData);

			var data : GTabbedPanelData = new GTabbedPanelData();
			data.tabData.padding = 10;
			data.tabData.gap = 1;
			data.tabData.x = 5;
			data.viewStackData.width = 354;
			data.viewStackData.height = 411;

			data.align = new GAlign(0, 0, 0, 20, 0, -1);

			_tabbedPanel = new GTabbedPanel(data);
			_tabbedPanel.addTab("装备", _itemsPanel);
			(_tabbedPanel.group.model.getLast() as GTab).source = Item.EQ | Item.FRAGMENT;

			_tabbedPanel.addTab("消耗品", _itemsPanel);
			(_tabbedPanel.group.model.getLast() as GTab).source = Item.EXPEND;

			_tabbedPanel.addTab("元神", _itemsPanel);
			(_tabbedPanel.group.model.getLast() as GTab).source = Item.SOUL;

			if (UserData.instance.level >= 70)
			{
				_tabbedPanel.addTab("灵珠", _itemsPanel);
				(_tabbedPanel.group.model.getLast() as GTab).source = Item.GEM;
			}

			_tabbedPanel.addTab("材料", _itemsPanel);
			(_tabbedPanel.group.model.getLast() as GTab).source = Item.ENHANCE | Item.JEWEL;

			// _tabbedPanel.addTab("天材地宝", _itemsPanel);
			// (_tabbedPanel.group.model.getLast() as GTab).source = Item.JEWEL;

			_tabbedPanel.group.selectionModel.index = 0;
			this.contentPanel.add(_tabbedPanel);
		}

		private function addComboBox() : void
		{
			var data : GComboBoxData = new GComboBoxData();
			data.x = 260;
			data.y = 7;
			data.width = 60;
			data.buttonData.isHtmlColor = true;
			data.listData.width = 60;
			data.listData.height = 160;
			_comboBox = new GComboBox(data);
			_comboBox.selectionModel.index = 0;
			_itemsPanel.add(_comboBox);
		}

		private function addMergeButton() : void
		{
			var data : KTButtonData;
			data = new KTButtonData(KTButtonData.NORMAL_BUTTON);
			data.x = 166;
			data.y = 395;
			_mergeButton = new GButton(data);
			_mergeButton.text = "物品合成";

			if (UserData.instance.level >= 30)
				this.contentPanel.add(_mergeButton);
		}

		private function addBatchButton() : void
		{
			var data : KTButtonData;

			data = new KTButtonData(KTButtonData.NORMAL_BUTTON);
			data.x = 260;
			data.y = 395;
			_batchButton = new GButton(data);
			_batchButton.text = "批量出售";
			this.contentPanel.add(_batchButton);

			// data = new KTButtonData(KTButtonData.NORMAL_BUTTON, true);
			// data.x = 166;
			// data.y = 399;
			// _mergeAllButton = new GButton(data);
			// _mergeAllButton.text = "一键合成";
			// this.contentPanel.add(_mergeAllButton);
		}

		private function addExpendButton() : void
		{
			var bar : Sprite = UIManager.getUI(new AssetData(UI.PACK_EXPAND_BACKGROUND));
			bar.x = 20;
			bar.y = 382;
			bar.width = 125;
			_itemsPanel.add(bar);
		}

		private function addLabel() : void
		{
			var data : GLabelData = new GLabelData();
			data.width = 118;
			data.x = 23;
			data.y = 378;
			_packLabel = new GLabel(data);
			_packLabel.mouseEnabled = false;
			_packLabel.mouseChildren = false;
			_packLabel.text = "包裹容量： " + UserData.instance.packCurrent + "/" + UserData.instance.packTotal;
			_itemsPanel.add(_packLabel);
		}

		private function addItemGrid() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 9;
			gridData.y = 34;
			gridData.allowDrag = false;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 6;
			gridData.columns = 6;
			gridData.hgap = 6;
			gridData.vgap = 6;
			gridData.padding = 6;
			gridData.cell = ItemGridCell;

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 48;
			cellData.height = 48;
			cellData.allowSelect = true;
			cellData.fakeRollOut = true;
			cellData.iconData.showToolTip = true;
			cellData.iconData.showBg = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showBinding = true;
			cellData.iconData.showNums = true;
			cellData.iconData.showLevel = true;
			cellData.iconData.showPair = true;
			cellData.iconData.showRollOver = true;

			gridData.cellData = cellData;
			gridData.scrollBarData.visible = true;
			gridData.scrollBarData.movePre = 1;
			gridData.scrollBarData.wheelSpeed = 1;
			gridData.verticalScrollPolicy = GPanelData.ON;

			_itemGrid = new ItemGrid(gridData);
			_itemsPanel.add(_itemGrid);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		public function closeBatchView() : void
		{
			_batchButton.text = "批量出售";
			reloadItems();
			// updateItemGrid();
		}

		public function addItem(item : Item) : void
		{
			if (!item) return;
			_cachedItems.push(item);
			// updateComboBox();
			updateItemGrid();
		}

		public function addItems(arr : Array/* of Item */) : void
		{
			if (!arr) return;
			_cachedItems = _cachedItems.concat(arr);
			// updateComboBox();
			updateItemGrid();
		}

		public function removeItem(vo : Item) : void
		{
			if (_cachedItems.indexOf(vo) == -1) return;
			_cachedItems.splice(_cachedItems.indexOf(vo), 1);
			// updateComboBox();
			updateItemGrid();
		}

		public function removeItems(arr : Array/* of Item */) : void
		{
			if (!arr) return;

			for each (var item:Item in arr)
			{
				var index : uint = _cachedItems.indexOf(item);
				if (index >= 0)
					_cachedItems.splice(index, 1);
			}
			// updateComboBox();
			updateItemGrid();
		}

		private function reloadItems() : void
		{
			_cachedItems = [];

//			for each (var topType:int in Item.TOP_TYPES)
//			{
//				if ((_selectedTopType & topType) != 0)
//					_cachedItems = _cachedItems.concat(ItemManager.instance.packModel.getPageItems(topType));
//			}
			_cachedItems = ItemManager.instance.packModel.getMultiPageItems(_selectedTopType);

			if (PackVariable.isBattch)
			{
				for each (var vo:Item in _batchView.itemList)
				{
					if (_cachedItems.indexOf(vo) == -1) continue;
					_cachedItems.splice(_cachedItems.indexOf(vo), 1);
				}
			}
		}

		private function updateComboBox(reset : Boolean = false) : void
		{
			var selectedColor : int = (_comboBox.list.selection) ? (_comboBox.list.selection as LabelSource).value : 0;

			_comboBox.model.source = ItemUtils.changeComboBoxByColor(_cachedItems);

			if (reset)
			{
				selectDefaultComboBox();
				return;
			}

			var i : uint = 0;
			for each (var labelSource:LabelSource in _comboBox.model.source)
			{
				if (labelSource.value == selectedColor)
				{
					_comboBox.selectionModel.index = i;
					return;
				}
				i++;
			}

			_comboBox.selectionModel.index = 0;
		}

		private function selectDefaultComboBox() : void
		{
			_comboBox.selectionModel.index = 0;
		}

		// private function updateButtons() : void
		// {
		// if (_selectedTopType == Item.SOUL || _selectedTopType == Item.GEM)
		// {
		// _mergeButton.visible = false;
		// _batchButton.visible = false;
		// _mergeAllButton.visible = true;
		// _mergeAllButton.enabled = _cachedItems.length > 0 ? true : false;
		// }
		// else
		// {
		// _mergeButton.visible = true;
		// _batchButton.visible = true;
		// _mergeAllButton.visible = false;
		// }
		// }
		private function updatePackLabel() : void
		{
			if (_lastPackCurrent != UserData.instance.packCurrent || _lastPackTotal != UserData.instance.packTotal)
			{
				_lastPackCurrent = UserData.instance.packCurrent;
				_lastPackTotal = UserData.instance.packTotal;

				_packLabel.text = "包裹容量： " + _lastPackCurrent + "/" + _lastPackTotal ;
//				ToolTipManager.instance.refreshToolTip(_expandButton);
			}
		}

//		private function updateExpandButton() : void
//		{
//			if (UserData.instance.packTotal >= ManagePack.MAX)
//			{
//				_expandButton.visible = false;
//				_expandButtonBg.visible = false;
//			}
//		}

		private function updateItemGrid() : void
		{
			filterGoods(_cachedItems);
		}

		/** 刷新物品视图 */
		private function refreshSource(value : Array /* of Item */, level : int = 0) : void
		{
			if (!value) return;
			value.sort(ItemUtils.sortItemFunc);
			_itemGrid.source = value.concat();
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			initEvents();

			if (PackVariable.heroPanelOpen)
			{
				_tabbedPanel.group.selectionModel.index = 0;
			}
			tab_changeHandler(new Event(""));
			updatePackLabel();
			SignalBusManager.packPanelChange.dispatch();
		}

		override protected function onHide() : void
		{
			super.onHide();
			removeEvents();
			if (_batchView) _batchView.hide();
			_batchButton.text = "批量出售";
		}

		protected function initEvents() : void
		{
			_comboBox.selectionModel.addEventListener(Event.CHANGE, comboBox_changeHandler);
			_batchButton.addEventListener(MouseEvent.CLICK, batchButton_clickHandler);
			_tabbedPanel.group.selectionModel.addEventListener(Event.CHANGE, tab_changeHandler);

			_mergeButton.addEventListener(MouseEvent.CLICK, mergeButton_clickHandler);
			_itemGrid.addEventListener(ItemCellEvent.SELECT, itemGrid_selectCellHandler, true);
			Common.game_server.addCallback(0x11, onPlayerInfoChange);
			Common.game_server.addCallback(0xFFF2, onPackChange);
			Common.game_server.addCallback(0xFFF1, onHeroLevelUp);
			SignalBusManager.packPanelSelectPage.add(onExternalSelectPage);
		}

		private function removeEvents() : void
		{
			_comboBox.selectionModel.removeEventListener(Event.CHANGE, comboBox_changeHandler);
			_batchButton.removeEventListener(MouseEvent.CLICK, batchButton_clickHandler);
			_tabbedPanel.group.selectionModel.removeEventListener(Event.CHANGE, tab_changeHandler);
			_mergeButton.removeEventListener(MouseEvent.CLICK, mergeButton_clickHandler);
			_itemGrid.removeEventListener(ItemCellEvent.SELECT, itemGrid_selectCellHandler);
			Common.game_server.removeCallback(0x200, onPackChange);
			Common.game_server.removeCallback(0x203, onPackChange);
			Common.game_server.removeCallback(0x11, onPlayerInfoChange);
			Common.game_server.removeCallback(0xFFF1, onHeroLevelUp);
			SignalBusManager.packPanelSelectPage.remove(onExternalSelectPage);
		}

		private function onExternalSelectPage(page : uint) : void
		{
			_tabbedPanel.group.selectionModel.index = page;
		}

		private function onHeroLevelUp(msg : CCUserDataChangeUp) : void
		{
			if (msg.oldLevel < 70 && msg.level >= 70)
			{
				_tabbedPanel.addTab("灵珠", _itemsPanel, 3);
				(_tabbedPanel.group.model.getLast() as GTab).source = Item.GEM;
				_tabbedPanel.refresh();
			}

			if (msg.oldLevel < 30 && msg.level >= 30)
			{
				this.contentPanel.add(_mergeButton);
			}
		}

		private function mergeAllButton_clickHandler(event : MouseEvent) : void
		{
			if (_selectedTopType == Item.SOUL)
				ItemService.instance.sendMergeAllSoulMessage();
			else if (_selectedTopType == Item.GEM)
				ItemService.instance.sendMergeAllGemMessage();
		}

		private function comboBox_changeHandler(event : Event) : void
		{
			if (_comboBox.list.selection)
			{
				updateItemGrid();
			}
		}

		private function batchButton_clickHandler(event : Event) : void
		{
			var currentTime : uint = getTimer();
			if (currentTime - _batchClickTime < 500)
				return;
			_batchClickTime = currentTime;

			if (PackVariable.isBattch)
			{
				batchSelectAll();
			}
			else
			{
				openBatchPanel();
			}
		}

		private function batchSelectAll() : void
		{
			_batchView.addItems(_itemGrid.source);
			removeItems(_itemGrid.source);
		}

		private function openBatchPanel() : void
		{
			if (PackVariable.heroPanelOpen)
				MenuManager.getInstance().closeMenuView(MenuType.HERO_PANEL);

			if (!_batchView)
				_batchView = new BatchView(this);
			_batchView.show();
			layoutBatchView();

			_batchButton.text = "全部选择";
		}

		private function layoutBatchView() : void
		{
			GLayout.layout(_batchView, new GAlign(this.x + this.width, -1, -1, parent.height - this.y - this.height));
		}

		private function expandButton_clickHandler(event : Event) : void
		{
			StateManager.instance.checkMsg(77, null, expandButton_callback, [getExpandCost()]);
		}

		private function expandButton_callback(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				if (UserData.instance.trySpendTotalGold(getExpandCost()) >= 0)
				{
					Common.game_server.sendMessage(0x203, new CSExtendPack());
					return true;
				}
				else
				{
					return false;
				}
			}

			return true;
		}

		/** 切页 */
		private function tab_changeHandler(event : Event) : void
		{
			_selectedTopType = (_tabbedPanel.group.selection as GTab).source;

			reloadItems();
			updateComboBox(true);
			// ComboBox 会自动触发刷新ItemGrid

			// updateButtons();
			// updateItemGrid();
		}

		private function mergeButton_clickHandler(event : MouseEvent) : void
		{
			MenuManager.getInstance().openMenuView(MenuType.MERGE_MATERIAL);
		}

		/** 点击物品，物品进入其它界面*/
		private function itemGrid_selectCellHandler(event : ItemCellEvent) : void
		{
			var item : Item = event.item;

			if (PackVariable.heroPanelOpen && item is Equipment)
			{
				ManagePack.equipItem(item as Equipment);
			}
			else if (PackVariable.isBattch)
			{
				removeItem(item);
				_batchView.addItem(item);
			}
			else
			{
				showOperationPanel(item);
			}
		}

		private function showOperationPanel(item : Item) : void
		{
			var panel : GoodOperateBox = ManagePack.goodOperatePanel;
			// panel.x = stage.mouseX - panel.width/2;
			// panel.y = stage.mouseY - panel.height;
			panel.x = stage.mouseX + 20;
			panel.y = stage.mouseY;
			panel.source = item;
			panel.show();
		}

		/**  packChange 包裹里物品发生变化  **/
		private function onPackChange(msg : CCPackChange) : void
		{
			if (msg.topType | _selectedTopType)
			{
				reloadItems();
				updateComboBox();
				updatePackLabel();
				updateItemGrid();
			}
		}

		private function onPlayerInfoChange(info : SCPlayerInfoChange) : void
		{
			if (info.packSizeChange)
			{
				UserData.instance.packTotal = info.packSizeChange;
				updatePackLabel();
//				updateExpandButton();
			}
		}

		// ------------------------------------------------
		// 其它
		// ------------------------------------------------
		override public function set x(value : Number) : void
		{
			super.x = value;

			if (_batchView)
				layoutBatchView();
		}

		override public function set y(value : Number) : void
		{
			super.y = value;
			if (_batchView)
				layoutBatchView();
		}

		/** 筛选 */
		private function filterGoods(value : Array/* of Item */) : void
		{
			if (!value) return ;

			var arr : Array = [];
			var max : int = value.length;
			for (var i : int = 0;i < max;i++)
			{
				if ((Item(value[i]).topType & _selectedTopType) != 0 && (Number(_comboBox.list.selection["value"]) == 0 || Number(_comboBox.list.selection["value"]) == Item(value[i]).color))
					arr.push(value[i]);
			}
			refreshSource(arr);
		}

		private static function getExpandCost() : int
		{
			return Math.floor((UserData.instance.packTotal - 50) / 50) * 50;
		}

		private static function getExpandTipString() : String
		{
			return "花费" + StringUtils.addGoldColor(getExpandCost().toString()) + "元宝扩展50格包裹容量";
		}
	}
}
