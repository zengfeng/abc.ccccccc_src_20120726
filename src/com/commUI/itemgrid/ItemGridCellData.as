package com.commUI.itemgrid
{
	import com.commUI.icon.ItemIconData;

	import gameui.cell.GCellData;

	/**
	 * @author jian
	 */
	public class ItemGridCellData extends GCellData
	{
		public var showName : Boolean = false;
		public var fakeRollOut : Boolean = false;
		public var iconData : ItemIconData = new ItemIconData();
	}
}
