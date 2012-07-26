package com.commUI.itemgrid
{
	import com.commUI.Component;

	/**
	 * @author jian
	 */
	public class StaticGrid extends Component implements IGrid
	{
		// =====================
		// Attribute
		// =====================
		private var _rows : int;
		private var _cols : int;
		private var _cellWidth : Number;
		private var _cellHeight : Number;
		private var _spacingX : Number;
		private var _spacingY : Number;
		protected var _cells : Array;

		// =====================
		// getter/setter
		// =====================
		public function get cells() : Array
		{
			return _cells;
		}

		public function get rows() : int
		{
			return _rows;
		}

		public function get columns() : int
		{
			return _cols;
		}
		
		public function get cellWidth():Number
		{
			return _cellWidth;
		}
		
		public function get cellHeight():Number
		{
			return _cellHeight;
		}
		
		public function get spacingX():Number
		{
			return _spacingX;
		}
		
		public function get spacingY():Number
		{
			return _spacingY;
		}
		
		override public function get height():Number
		{
			return _rows * _cellHeight + (_rows - 1) * _spacingY;
		}
		
		override public function get width():Number
		{
			return _cols * _cellWidth + (_cols - 1) * _spacingX;
		}
		
		public function getIndex (row:int, col:int):int
		{
			return _cols * row + col;
		}
		
		public function getCell (row:int, col:int):GridCell
		{
			return _cells[getIndex(row, col)];
		}
		
		public function getCellByIndex (index:int):GridCell
		{
			return _cells[index];
		}

		// =====================
		// Method
		// =====================
		public function StaticGrid(rows : int, cols : int, cellWidth : Number, cellHeight : Number, spacingX : Number, spacingY : Number)
		{
			_rows = rows;
			_cols = cols;
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			_spacingX = spacingX;
			_spacingY = spacingY;
			_cells = [];
		}
		
		public function addCell (cell:GridCell):void
		{
			var index:uint = _cells.length;
			
			cell.col = index % _cols;
			cell.row = index / _cols;
			
			_cells[index] = cell;
			addChild(cell);
		}

		public function layout() : void
		{
			var len : uint = _cells.length;
			var locX : Number = 0;
			var locY : Number = 0;
			var w : Number = _spacingX + _cellWidth;
			var h : Number = _spacingY + _cellHeight;
			var col : uint = 0;

			for (var i : uint = 0; i < len; i++)
			{
				var cell : GridCell = _cells[i] as GridCell;

				cell.x = locX;
				cell.y = locY;

				col++;

				if (col == _cols)
				{
					col = 0;
					locX = 0;
					locY += h;
				}
				else
				{
					locX += w;
				}
			}
		}
	}
}

