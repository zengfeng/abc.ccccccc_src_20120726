package com.commUI.itemgrid
{
	import gameui.data.GGirdData;

	/**
	 * @author jian
	 */
	public class ItemGridData extends GGirdData
	{
		public var filterFuncs : Array /* of Function */;
		public var sortFuncs: Array /* of Function */;
		public var showEmptyText : String = null;
		public var autoHideScrollBar:Boolean = true;

		override public function clone() : *
		{
			var data : ItemGridData = new ItemGridData();
			parse(data);
			return data;
		}

		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : ItemGridData = source as ItemGridData;
			if (data == null) return;
			data.filterFuncs = filterFuncs;
			data.sortFuncs = sortFuncs;
		}
	}
}
