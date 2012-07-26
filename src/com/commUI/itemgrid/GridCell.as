package com.commUI.itemgrid
{
	import com.commUI.Component;

	import flash.display.DisplayObject;

	/**
	 * @author jian
	 */
	public class GridCell extends Component
	{
		// =====================
		// Attribute
		// =====================
		public var row : int;
		public var col : int;
		private var _itemDO : DisplayObject;

		// =====================
		// getter/setter
		// =====================
		public function set itemDO(value : DisplayObject) : void
		{
			if (_itemDO == value) return;

			if (_itemDO)
				removeChild(_itemDO);

			if (value)
				addChild(value);

			_itemDO = value;
		}

		public function get itemDO() : DisplayObject
		{
			return _itemDO;
		}
	}
}
