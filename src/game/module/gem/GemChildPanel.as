package game.module.gem {
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.gem.Gem;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;

	import gameui.cell.LabelSource;
	import gameui.containers.GPanel;
	import gameui.controls.GComboBox;
	import gameui.data.GPanelData;

	import model.SelectionModel;

	import net.AssetData;

	import utils.DictionaryUtil;

	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.utils.UICreateUtils;

	import flash.events.Event;
	import flash.utils.Dictionary;







	/**
	 * @author jian
	 */
	public class GemChildPanel extends GPanel
	{
		// ===========================================================
		// @属性
		// ===========================================================
		protected var _comboBox : GComboBox;
		protected var _filterType : int = -1;
		protected var _itemGrid : ItemGrid;
		protected var _itemGridClass : Class = ItemGrid;
		protected var _itemGridCellClass : Class = ItemGridCell;

		// ==========================================================
		// @创建
		// ==========================================================
		public function GemChildPanel()
		{
			var data : GPanelData = new GPanelData();
			data.width = 611;
			data.height = 355;
			data.bgAsset = new AssetData(UI.PANEL_BACKGROUND);
			super(data);
		}

		/*
		 * 创建面板
		 */
		override protected function create() : void
		{
			super.create();
			addSplitters();
			addPack();
		}

		/*
		 * 添加背景分割线
		 */
		private function addSplitters() : void
		{
//			var bgSplit2 : Sprite = UIManager.getUI(new AssetData(UI.FORGE_BACKGROUND_SPLITTER));
//			bgSplit2.x = 337;
//			bgSplit2.y = 0;
//			_content.addChild(bgSplit2);
		}

		/*
		 * 添加包裹
		 */
		private function addPack() : void
		{
			addPackCommboBox();
			addItemGrid();
		}

		/*
		 * 添加包裹筛选
		 */
		private function addPackCommboBox() : void
		{
			_comboBox = UICreateUtils.createGComboBox([new LabelSource("全部", -1)], 75, 75, 100, 520, 6);
			_comboBox.selectionModel.index = 0;
			_content.addChild(_comboBox);
		}

		/*
		 * 添加物品格
		 */
		protected function addItemGrid() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 418;
			gridData.y = 34;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 5;
			gridData.columns = 3;
			gridData.hgap = 6;
			gridData.vgap = 6;
			gridData.padding = 6;
			gridData.cell = _itemGridCellClass;
			gridData.filterFuncs = [itemFilterFunc];
			gridData.sortFuncs = [itemSortFunc];
			gridData.enabled = true;

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 48;
			cellData.height = 48;
			cellData.enabled = true;
			cellData.selected_upAsset = null;
			cellData.showName = true;
			cellData.iconData.showToolTip = true;
			cellData.iconData.showNums = true;
			cellData.iconData.showBinding = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showLevel = true;
			cellData.iconData.showBg = true;
			cellData.iconData.showRollOver = true;
			cellData.iconData.sendChat = true;

			gridData.cellData = cellData;

			_itemGrid = new _itemGridClass(gridData);
			_content.addChild(_itemGrid);
		}

		// ==============================================================
		// @更新
		// ==============================================================
		/*
		 * 更新包裹
		 */
		public function updatePack() : void
		{
			updateItemGrid();
			updatePackComboBox();
		}

		/*
		 * 更新筛选框
		 */
		protected function updatePackComboBox() : void
		{
			var sourceLabelByType : Dictionary = new Dictionary();

			for each (var item:Item in _itemGrid.source)
			{
				if (sourceLabelByType[item.type])
					continue;
				sourceLabelByType[item.type] = new LabelSource(item.name, item.type);
			}

			var items : Array = [new LabelSource("全部", -1)].concat(DictionaryUtil.getValues(sourceLabelByType).sort(function(a : LabelSource, b : LabelSource) : int
			{
				return a.value - b.value;
			}));

			_comboBox.model.max = items.length;
			_comboBox.model.source = items;
			// _comboBox.selectionModel.index = 0;
		}

		/*
		 * 更新物品格
		 */
		protected function updateItemGrid() : void
		{
			_itemGrid.source = ItemManager.instance.packModel.getPageItems(Item.GEM);
		}

		// ==============================================================
		// @交互
		// ==============================================================
		/*
		 * 进入面板
		 */
		override protected function onShow() : void
		{
			super.onShow();
			_comboBox.selectionModel.addEventListener(Event.CHANGE, typeSelectHandler);
			Common.game_server.addCallback(0xFFF2, packChangeHandler);
		}

		/*
		 * 退出面板
		 */
		override protected function onHide() : void
		{
			Common.game_server.removeCallback(0xFFF2, packChangeHandler);
			_comboBox.selectionModel.removeEventListener(Event.CHANGE, typeSelectHandler);
			super.onHide();
		}

		/*
		 * 包裹更新
		 */
		private function packChangeHandler(msg : CCPackChange) : void
		{
			updatePack();
		}

		/*
		 * 响应灵珠种类选择
		 */
		private function typeSelectHandler(event : Event) : void
		{
			var selectionModel : SelectionModel = SelectionModel(event.currentTarget);

			if (selectionModel.isSelected)
			{
				var source : * = _comboBox.model.getAt(selectionModel.index);
				if (source is LabelSource)
				{
					_filterType = LabelSource(source).value;
					updateItemGrid();
				}
			}
		}

		/*
		 * 灵珠筛选函数
		 */
		protected function itemFilterFunc(item : Item, index : int, arr : Array/* of Item */) : Boolean
		{
			return item is Gem && (_filterType == -1 || item.type == _filterType);
		}

		/*
		 * 灵珠排序函数
		 */
		protected function itemSortFunc(a : Item, b : Item) : int
		{
			if (a.id != b.id) return b.id - a.id;
			return (b.binding ? 1 : 0) - (a.binding ? 1 : 0);
		}
	}
}
