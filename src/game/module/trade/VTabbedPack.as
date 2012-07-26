package game.module.trade {
	import game.core.item.IUnique;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.pile.PileItem;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import game.net.data.CtoC.CCUserDataChangeUp;

	import gameui.cell.LabelSource;
	import gameui.controls.GComboBox;
	import gameui.core.GComponent;
	import gameui.data.GComboBoxData;
	import gameui.data.GPanelData;

	import net.AssetData;

	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.commUI.vtab.VTabList;
	import com.utils.ItemUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.events.Event;





	/**
	 * @author jian
	 */
	public class VTabbedPack extends GComponent
	{
		// =====================
		// @属性
		// =====================
		private var _itemGrid : ItemGrid;
		private var _tabList : VTabList;
		private var _comboBox : GComboBox;
		private var _fetchFilterItemListFunc : Function;
		private var _filterItemColor : int = -1;
		private var _cachedItems:Array;

		// =====================
		// @公共
		// =====================
		public function get itemGrid() : ItemGrid
		{
			return _itemGrid;
		}

		public function get tabList() : VTabList
		{
			return _tabList;
		}

		// =====================
		// @创建
		// =====================
		// fetchFilterItemListFunc提供需要过滤的物品数组 Array
		public function VTabbedPack(fetchFilterItemListFunc : Function = null)
		{
			_fetchFilterItemListFunc = fetchFilterItemListFunc;
			var data : GPanelData = new GPanelData();
			data.width = 262;
			data.height = 320;
			super(data);
		}

		override protected function create() : void
		{
			super.create();
//			addTitle();
			addComboBox();
			addVTabList();
			addItemGrid();
		}

		private function addTitle() : void
		{
			addChild(UICreateUtils.createTextField("可交易物品", null, 100, 20, 10, 8, TextFormatUtils.panelSubTitle));
		}//删掉

		private function addComboBox() : void
		{
			var data : GComboBoxData = new GComboBoxData();
			data.x = 102;
			data.y = 5;
			data.width = 60;
			data.buttonData.isHtmlColor = true;
			data.listData.width = 60;
			data.listData.height = 160;
			_comboBox = new GComboBox(data);
			addChild(_comboBox);
		}

		private function addItemGrid() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 0;
			gridData.y = 33;
			gridData.allowDrag = false;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 5;
			gridData.columns = 3;
			gridData.hgap = 5;
			gridData.vgap = 6;
			gridData.padding = 5;
			gridData.autoHideScrollBar = false;
//			gridData.showEmptyText = "没有非绑定的物品可进行交易";
			gridData.cell = ItemGridCell;
			gridData.verticalScrollPolicy = GPanelData.ON;

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 50;
			cellData.height = 48;
			cellData.selected_upAsset = null;
			cellData.iconData.showBg = true;
			cellData.iconData.showNums = true;
			cellData.iconData.showToolTip = true;
			cellData.iconData.sendChat = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showLevel = true;
			cellData.iconData.showRollOver = true;
			cellData.iconData.showBinding = true;

			gridData.cellData = cellData;

			_itemGrid = new ItemGrid(gridData);
			addChild(_itemGrid);
		}

		private function addVTabList() : void
		{
			_tabList = new VTabList();
			_tabList.x = 185;
			_tabList.y = 0;
			updateVTabList();
			_tabList.select(0);
			addChild(_tabList);
		}

		// =====================
		// @更新
		// =====================
		public function updateView():void
		{
			_cachedItems = ItemManager.instance.packModel.getMultiPageItems(getTopType()).filter(filterBindingFunc).sort(ItemUtils.sortItemFunc);
			updateComboBox();
			updateItemGrid();
		}
		
		private function updateVTabList() : void
		{
			if (UserData.instance.level >= 70)
				_tabList.source = [new LabelSource("装备", Item.EQ | Item.FRAGMENT), new LabelSource("元神", Item.SOUL), new LabelSource("灵珠", Item.GEM), new LabelSource("材料", Item.ENHANCE|Item.JEWEL)];
			else
				_tabList.source = [new LabelSource("装备", Item.EQ | Item.FRAGMENT), new LabelSource("元神", Item.SOUL), new LabelSource("材料", Item.ENHANCE|Item.JEWEL)];
		}

		private function updateComboBox() : void
		{
			var selectedColor:int = (_comboBox.list.selection)? (_comboBox.list.selection as LabelSource).value:0;
			
			_comboBox.model.source = ItemUtils.changeComboBoxByColor(_cachedItems);
			
			var i:uint = 0;
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
		
		private function updateItemGrid() : void

		{
			var items : Array = _cachedItems.filter(filterColorFunc);

			if (_fetchFilterItemListFunc == null)
			{
				_itemGrid.source = ItemUtils.splitPileArray(items);
				return;
			}

			var filterItemList : Array = ItemUtils.mergePileArray(_fetchFilterItemListFunc());
			if (!filterItemList || filterItemList.length == 0)
			{
				_itemGrid.source = ItemUtils.splitPileArray(items);
				return;
			}

			var finalItems : Array = [];
			var match : Boolean;

			for each (var item:Item in items)
			{
				match = false;
				for each (var fItem:Item in filterItemList)
				{
					if (fItem.id == item.id)
					{
						if (fItem is IUnique && (fItem as IUnique).uuid == (item as IUnique).uuid)
						{
							match = true;
							break;
						}
						else if (fItem is PileItem)
						{
							match = true;
							break;
						}
					}
				}

				if (!match)
				{
					finalItems.push(item);
				}
				else if (item.nums > fItem.nums)
				{
					var newItem : Item = ItemManager.instance.newItem(item.id);
					newItem.nums = item.nums - fItem.nums;
					finalItems.push(newItem);
				}
			}
			_itemGrid.source = ItemUtils.splitPileArray(finalItems);
		}

		private function getTopType() : uint
		{
			var labelSource : LabelSource = _tabList.selection;
			return labelSource.value;
		}
		
//		private function selectDefaultCombo():void
//		{
//			_comboBox.model.fireEvent = false;
//			_comboBox.selectionModel.index = 0;
//			_comboBox.model.fireEvent = true;
//		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			_tabList.selectionModel.addEventListener(Event.CHANGE, tabSelectHandler);
			_comboBox.selectionModel.addEventListener(Event.CHANGE, comboChangeHandler);
			Common.game_server.addCallback(0xFFF2, packChangeCallback);
			Common.game_server.addCallback(0xFFF1, levelUpCallback);
		}

		override protected function onHide() : void
		{
			_tabList.selectionModel.removeEventListener(Event.CHANGE, tabSelectHandler);
			_comboBox.selectionModel.removeEventListener(Event.CHANGE, comboChangeHandler);
			Common.game_server.removeCallback(0xFFF2, packChangeCallback);
			Common.game_server.removeCallback(0xFFF1, levelUpCallback);
			super.onHide();
		}

		private function tabSelectHandler(event : Event) : void
		{
			updateView();
			selectDefaultComboBox();
		}

		private function comboChangeHandler(event : Event) : void
		{
			var index : int = _comboBox.selectionModel.index;
			if (index <= 0)
				_filterItemColor = -1;
			else
			{
				var label : LabelSource = _comboBox.model.getAt(index) as LabelSource;
				_filterItemColor = label.value;
			}

			updateItemGrid();
		}

		private function packChangeCallback(msg : CCPackChange) : void
		{
			if (msg.topType | getTopType())
			{
				updateView();
			}
		}

		private function levelUpCallback(msg : CCUserDataChangeUp) : void
		{
			updateVTabList();
		}

		// =====================
		// @其它
		// =====================
		private function filterBindingFunc (item:Item, index:int, arr:Array):Boolean
		{
			return !item.binding;
		}
		
		private function filterColorFunc(item : Item, index : int, arr : Array) : Boolean
		{
			return (!item.binding && (_filterItemColor == -1 || _filterItemColor == item.color));
		}
	}
}