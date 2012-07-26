package com.commUI.itemgrid {
	import game.core.avatar.AvatarManager;
	import game.core.item.Item;

	import gameui.controls.BDPlayer;
	import gameui.controls.GScrollBar;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GPanelData;
	import gameui.data.GScrollBarData;
	import gameui.events.GScrollBarEvent;
	import gameui.manager.UIManager;

	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;





	/**
	 * @author jian
	 */
	public class ItemGrid extends GComponent implements IGrid
	{
		// ==============================================================
		// Attribute
		// ==============================================================
		// protected var _cellData : ItemGridCellData;
		// protected var _cellClass : Class;
		protected var _data : ItemGridData;
		private var _items : Array;
		private var _grid : StaticGrid;
		private var _background : Sprite;
		private var _scrollBar : GScrollBar;
//		private var _scrollPosition : int = 0;
		private var _emptyText : TextField;
		private var _selectEffect : BDPlayer;

		// private var _bgAsset:AssetData;
		// private var _allowDrag : Boolean;
		// private var _showScrollBar : Boolean;
		// private var _padding : Number;
		// ==============================================================
		// getter/setter
		// ==============================================================
		public function set showBorder(value : Boolean) : void
		{
			updateCellConf("showBorder", value);
		}

		public function set showOwner(value : Boolean) : void
		{
			updateCellConf("showOwner", value);
		}

		public function set showLevel(value : Boolean) : void
		{
			updateCellConf("showLevel", value);
		}

		override public function set source(value : *) : void
		{
			_items = value ? value : [];
			updateScrollBar();
			updateCells();
			updateEmptyText();
		}

		override public function get source() : *
		{
			return _items;
		}
		
		private function get scrollPosition():int
		{
			if (_scrollBar)
				return _scrollBar.value;
			else
				return 0;
		}

		// =====================
		// Method
		// =====================
		// ------------------------------------------------
		// Creation
		// ------------------------------------------------
		public function ItemGrid(data : ItemGridData)
		{
			_data = data;
			_items = [];
			super(data);
		}

		override protected function create() : void
		{
			addBackground();
			addGrid();
			addScrollBar();
			addEmptyText();
			layout();
		}

		private function addBackground() : void
		{
			if (_data.bgAsset)
			{
				_background = UIManager.getUI(_data.bgAsset);
				addChild(_background);
			}
		}

		private function addGrid() : void
		{
			_grid = new StaticGrid(_data.rows, _data.columns, _data.cellData.width, _data.cellData.height, _data.hgap, _data.vgap);
			_grid.x = _data.padding;
			_grid.y = _data.padding;
			addChild(_grid);

			for (var row : uint = 0; row < _data.rows; row++)
			{
				for (var col : uint = 0; col < _data.columns; col++)
				{
					var cell : GridCell = createCell();
					cell.col = col;
					cell.row = row;
					_grid.addCell(cell);
				}
			}

			_grid.layout();
		}

		private function addScrollBar() : void
		{
			if (_data.verticalScrollPolicy==GPanelData.ON)
			{
				var data : GScrollBarData = new GScrollBarData();
				data.movePre = 1;
				_scrollBar = new GScrollBar(data);
				updateScrollBar();

				addChild(_scrollBar);
			}
		}

		private function addEmptyText() : void
		{
			if (_data.showEmptyText)
			{
				_emptyText = UICreateUtils.createTextField(_data.showEmptyText, null, 200, 20, 0, 0, TextFormatUtils.panelSubTitleCenter);
				addChild(_emptyText);
			}
		}

		public function removeItem(item : Item) : void
		{
			for (var i : uint = _items.length - 1; i >= 0; i--)
			{
				if (_items[i] == item)
					source = _items.splice(i, 1);
			}
		}

		public function getIndex(row : int, col : int) : int
		{
			return (scrollPosition + row) * _data.columns + col;
		}

		protected function createCell() : GridCell
		{
			return new _data.cell(_data.cellData);
		}

		// ------------------------------------------------
		// Update
		// ------------------------------------------------
		public function selectItem (item:Item):void
		{
			var index:int = -1;
			if (item)
				index = _items.indexOf(item);
			
			var start : uint = scrollPosition * _data.columns;
			index -= start;
			
			if (index < 0)
			{
				if (_selectEffect)
				_selectEffect.hide();
			}
			else
			{
				if (!_selectEffect)
				{
					var data:GComponentData = new GComponentData();
					data.parent = this;
					_selectEffect=AvatarManager.instance.getCommBDPlayer(AvatarManager.COMM_CIRCLEEFFECT, data);
					_selectEffect.mouseEnabled = false;
					_selectEffect.mouseChildren = false;
					_selectEffect.scaleX = 0.65;
					_selectEffect.scaleY = 0.65;
				}
				
				var cell:ItemGridCell = _grid.cells[index];
				
				_selectEffect.x = cell.x + 32;
				_selectEffect.y = cell.y + 30;
				_selectEffect.show();
				_selectEffect.play(80, null, 0);
			}
			
		}

		private function updateCellConf(method : String, value : Boolean) : void
		{
			for each (var cell:ItemGridCell in _grid.cells)
			{
				(cell.itemDO)[method] = value;
			}
		}

		private function updateCells() : void
		{
			var itemLen : uint = _items.length;
			var cells : Array = _grid.cells;
			var cellLen : uint = cells.length;
			var start : uint = scrollPosition * _data.columns;

			for (var i : uint = 0, j : uint = start; i < cellLen; i++,j++)
			{
				var cell : ItemGridCell = cells[i] as ItemGridCell;
				if (j < itemLen)
					cell.source = _items[j];
				else
					cell.source = null;
			}
		}

		private function updateEmptyText() : void
		{
			if (_emptyText)
				_emptyText.visible = !(_items && _items.length > 0);
		}

		private function updateScrollBar() : void
		{
			if (_data.verticalScrollPolicy==GPanelData.ON)
			{
				var nscrollItems : uint = Math.max(_items.length - _data.columns * _data.rows, 0);
				
				if (_data.autoHideScrollBar)
					_scrollBar.visible = (nscrollItems > 0);
					
				_scrollBar.resetValue(_data.rows, 0, Math.ceil(nscrollItems / _data.columns), scrollPosition);
			}
		}

		override protected function layout() : void
		{
			_height = _grid.height + _data.padding * 2 + 2;
			_width = _grid.width + _data.padding + (_scrollBar ? _scrollBar.width + _data.padding : _data.padding);

			if (_scrollBar)
			{
				_scrollBar.x = _width - _scrollBar.width - 2;
				_scrollBar.height = _height - 2;
			}

			if (_emptyText)
			{
				_emptyText.x = (_width - _emptyText.width) / 2;
				_emptyText.y = (_height - _emptyText.height) / 2;
			}

			_background.width = _width;
			_background.height = _height;
		}

		// ------------------------------------------------
		// Event
		// ------------------------------------------------
		override protected function onShow() : void
		{
			if (_data.verticalScrollPolicy==GPanelData.ON)
			{
				_scrollBar.addEventListener(GScrollBarEvent.SCROLL, scrollHandler);
				addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
		}

		override protected function onHide() : void
		{
			if (_data.verticalScrollPolicy==GPanelData.ON)
			{
				_scrollBar.removeEventListener(GScrollBarEvent.SCROLL, scrollHandler);
				removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
		}

		private function scrollHandler(event : GScrollBarEvent) : void
		{
			if (event.direction == GScrollBarData.VERTICAL)
			{
				if (event.delta != 0)
				{
//					_scrollPosition += event.delta;
					updateCells();
				}
			}
		}

		private function mouseWheelHandler(event : MouseEvent) : void
		{
			if (event.delta == 0)
				return;
				
			if (_scrollBar.visible)
			{
				event.stopPropagation();
				_scrollBar.scroll(event.delta < 0 ? -1 : 1);
			}
		}
	}
}
