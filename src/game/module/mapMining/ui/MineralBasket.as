package game.module.mapMining.ui {
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.pile.PileItem;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.pack.GoodOperateBox;
	import game.module.pack.merge.MergeConfig;
	import game.module.pack.merge.MergeManager;
	import game.module.pack.merge.MergeType;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import game.net.data.CtoS.CSEnhanceStoneMerge;
	import game.net.data.CtoS.CSMaterialMerge;

	import gameui.cell.LabelSource;
	import gameui.controls.GButton;
	import gameui.controls.GCheckBox;
	import gameui.controls.GComboBox;
	import gameui.core.GAlign;
	import gameui.data.GComboBoxData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;
	import com.commUI.alert.Alert;
	import com.commUI.itemgrid.ItemCellEvent;
	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.utils.ItemUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jian
	 */
	public class MineralBasket extends GCommonSmallWindow
	{
		// =====================
		// 属性
		// =====================
		private var _openButton : GButton;
		private var _itemGrid : ItemGrid;
		private var _bgSkin : Sprite;
		private var _operateBox : GoodOperateBox;
		private var _comboBox : GComboBox;
		private var _checkBox : GCheckBox;
		private var _cachedItems : Array;
		private var _totalCost : int;

		// =====================
		// setter/getter
		// =====================
		override public function set source(value : *) : void
		{
			_itemGrid.source = value;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function MineralBasket()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 258;
			data.height = 367;
			data.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			data.allowDrag = true;
			data.align = new GAlign(-1, -1, -1, -1, 0, 0);
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			
			title = "仙石";
			addBgSkin();
			addPackage();
			addButtons();
			addCheckBox();
			addComboBox();
		}

		private function addCheckBox() : void
		{
			_checkBox = UICreateUtils.createGCheckBox("只显示可交易", 120, 20, 14, 6);

			contentPanel.addChild(_checkBox);
		}

		private function addComboBox() : void
		{
			var data : GComboBoxData = new GComboBoxData();
			data.x = 148;
			data.y = 8;
			data.width = 85;
			data.buttonData.isHtmlColor = true;
			data.listData.width = 85;
			data.listData.height = 160;
			_comboBox = new GComboBox(data);
			_comboBox.selectionModel.index = 0;
			contentPanel.addChild(_comboBox);
		}

		private function addBgSkin() : void
		{
			_bgSkin = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			_bgSkin.x = 5;
			_bgSkin.width = width - 10;
			_bgSkin.height = height - 5;
			contentPanel.addChild(_bgSkin);
		}

		private function addPackage() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 13;
			gridData.y = 40;
			gridData.allowDrag = false;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 5;
			gridData.columns = 4;
			gridData.hgap = 7;
			gridData.vgap = 7;
			gridData.padding = 5;
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
			cellData.iconData.showNums = true;
			gridData.cellData = cellData;

			_itemGrid = new ItemGrid(gridData);
			_itemGrid.source = [];
			contentPanel.addChild(_itemGrid);
		}

		private function addButtons() : void
		{
			_openButton = UICreateUtils.createGButton('一键合成至下级', 105, 0, 70, 325);
			addChild(_openButton);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateCacheItem() : void
		{
			_cachedItems = ItemManager.instance.getEnhanceStones();
		}

		private function updateItemGrid() : void
		{
			_itemGrid.source = _cachedItems.filter(filterItemFunc).sortOn("id", 18);

			// if ((_itemGrid.source as Array).length > 0)
			// _openButton.enabled = true;
			// else
			// _openButton.enabled = false;
		}

		private function filterItemFunc(item : Item, index : int, arr : Array) : Boolean
		{
			var id : int = Number(_comboBox.list.selection["value"]);
			return (!_checkBox.selected || _checkBox.selected && item.binding == false) && (id == 0 || item.id == id);
		}

		private function updateComboBox(reset : Boolean = false) : void
		{
			var selectedId : int = (_comboBox.list.selection) ? (_comboBox.list.selection as LabelSource).value : 0;

			_comboBox.model.source = ItemUtils.changeComboBoxByItemId(_cachedItems);

			if (reset)
			{
				_comboBox.selectionModel.index = 0;
				return;
			}

			var i : uint = 0;
			for each (var labelSource:LabelSource in _comboBox.model.source)
			{
				if (labelSource.value == selectedId)
				{
					_comboBox.selectionModel.index = i;
					return;
				}
				i++;
			}

			_comboBox.selectionModel.index = 0;
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();

			Common.game_server.addCallback(0xfff2, onPackChange);

			_openButton.addEventListener(MouseEvent.CLICK, mergeButton_clickHandler);
			_itemGrid.addEventListener(ItemCellEvent.SELECT, itemGrid_selectCellHandler, true);
			_comboBox.selectionModel.addEventListener(Event.CHANGE, comboBox_changeHandler);
			_checkBox.addEventListener(Event.CHANGE, checkBox_changeHandler);

			GLayout.update(UIManager.root, this);
			updateCacheItem();
			updateComboBox();
		}

		private function checkBox_changeHandler(event : Event) : void
		{
			updateItemGrid();
		}

		override protected function onHide() : void
		{
			Common.game_server.removeCallback(0xfff2, onPackChange);

			_itemGrid.removeEventListener(ItemCellEvent.SELECT, itemGrid_selectCellHandler, true);
			_openButton.removeEventListener(MouseEvent.CLICK, mergeButton_clickHandler);
			_comboBox.selectionModel.removeEventListener(Event.CHANGE, comboBox_changeHandler);
			_checkBox.removeEventListener(Event.CHANGE, checkBox_changeHandler);

			super.onHide();
		}

		private function comboBox_changeHandler(event : Event) : void
		{
			if (_comboBox.list.selection)
			{
				updateItemGrid();
			}
		}

		private function mergeButton_clickHandler(event : Event) : void
		{
			_totalCost = calculateMergeCost();

			if (_itemGrid.source.length <= 0 || _totalCost == 0)
			{
				StateManager.instance.checkMsg(81);
				return;
			}

			StateManager.instance.checkMsg(401, null, onMergeConfirm, [_totalCost]);
		}

		private function onMergeConfirm(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				if (UserData.instance.trySpendSilver(_totalCost) < 0)
				{
					StateManager.instance.checkMsg(129);
					return true;
				}
				if (_comboBox.selectionModel.index == 0)
				{
					var msg : CSEnhanceStoneMerge = new CSEnhanceStoneMerge();
					if (_checkBox.selected)
						msg.type = MergeType.MERGE_UNBIND;
					else
						msg.type = MergeType.MERGE_ALL;
					Common.game_server.sendMessage(0x2B1, msg);
				}
				else
				{
					var itemId : int = _comboBox.model.getAt(_comboBox.selectionModel.index)["value"];

					var msg2 : CSMaterialMerge = new CSMaterialMerge();
					if (_checkBox.selected)
						msg2.itemId = itemId | MergeType.MERGE_UNBIND << 16;
					else
						msg2.itemId = itemId | MergeType.MERGE_ALL << 16;
					Common.game_server.sendMessage(0x2B0, msg2);
				}
			}

			return true;
		}

		private function calculateMergeCost() : int
		{
			var items : Array = ItemUtils.mergePileArray(_itemGrid.source);
			var cost : int = 0;
			for each (var item:PileItem in items)
			{
				var config : MergeConfig = MergeManager.instance.getConfig(item.id);
				if (config)
				{
					cost += config.moneyCount * int(item.nums / config.count);
				}
			}

			return cost;
		}

		// 0xfff2
		private function onPackChange(msg : CCPackChange) : void
		{
			if (msg.topType | Item.ENHANCE)
			{
				updateCacheItem();
				updateComboBox();
				updateItemGrid();
			}
		}

		private function itemGrid_selectCellHandler(event : ItemCellEvent) : void
		{
			if (!_operateBox)
				_operateBox = new GoodOperateBox();

			var item : Item = event.item;

			// panel.x = stage.mouseX - panel.width/2;
			// panel.y = stage.mouseY - panel.height;
			_operateBox.x = stage.mouseX + 20;
			_operateBox.y = stage.mouseY;
			_operateBox.source = item;
			_operateBox.show();
		}
	}
}

