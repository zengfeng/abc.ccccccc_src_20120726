package game.module.soul.pack
{
	import com.commUI.itemgrid.GridCell;
	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import game.core.item.soul.Soul;
	import gameui.drag.DragData;



	/**
	 * @author jian
	 */
	public class SoulGrid extends ItemGrid
	{
		
		public function SoulGrid(data : ItemGridData)
		{
			super(data);
		}
		
		public function dragEnter(dragData : DragData) : Boolean
		{
			if (dragData.dragItem is Soul)
			{
				var soul : Soul = dragData.dragItem as Soul;

				if (soul && soul.slot)
				{
					soul.slot.release();
				}
			}
			return true;
		}
		
		override protected function createCell ():GridCell
		{
			var cellData:ItemGridCellData = _data.cellData as ItemGridCellData;
			return new _data.cell(cellData, this);
		}
	}
}
