package game.module.gem.attach
{
	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridData;
	import game.core.item.gem.Gem;
	import gameui.drag.DragData;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragTarget;



	/**
	 * @author jian
	 */
	public class GemGrid extends ItemGrid implements IDragTarget
	{
		public function GemGrid(data : ItemGridData)
		{
			super(data);
		}

		public function dragEnter(dragData : DragData) : Boolean
		{
			if (dragData.dragItem is Gem)
			{
				var gem : Gem = dragData.dragItem as Gem;

				if (gem && gem.slot)
				{
					gem.slot.release();
				}
			}
			return true;
		}
		
		public function canSwap (source:IDragItem,target:IDragItem):Boolean
		{
			return false;
		}
	}
}
