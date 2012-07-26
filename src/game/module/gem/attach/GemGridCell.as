package game.module.gem.attach
{
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import game.core.item.Item;
	import game.manager.ViewManager;
	import gameui.controls.GImage;
	import gameui.data.GImageData;
	import gameui.drag.DragData;
	import gameui.drag.DragManage;
	import gameui.drag.IDragSource;




	/**
	 * @author jian
	 */
	public class GemGridCell extends ItemGridCell implements IDragSource
	{
		
		public function GemGridCell (data:ItemGridCellData)
		{
			super(data);
		}
		
		protected function mouseDownHandler(event : MouseEvent) : void
		{
			if (!_source) return;
			
			var dragData : DragData = new DragData();
			dragData.dragSource = this;
			dragData.dragItem = this.source;
			DragManage.getInstance().darg(this, dragData, ViewManager.instance.uiContainer, true, false);
		}

		public function get dragImage() : DisplayObject
		{
			var imageData : GImageData = new GImageData();
			var image : GImage = new GImage(imageData);

			image.url = (_source as Item).imgUrl;
			return image;
		}

		override protected function onShow() : void
		{
			super.onShow();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		override protected function onHide() : void
		{
			super.onHide();
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}		
		
	}
}
