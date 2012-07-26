package game.module.soul.pack
{
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.soul.Soul;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.manager.ViewManager;
	import game.module.quest.guide.GuideMange;
	import game.module.soul.SoulDragManager;
	import game.module.soul.SoulSlotCell;
	import game.module.soul.soulBD.SoulBD;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;

	import gameui.drag.DragData;
	import gameui.drag.DragManage;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragSource;
	import gameui.drag.IDragTarget;

	import com.commUI.icon.ItemIcon;
	import com.commUI.itemgrid.IGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	 * @author jian
	 */
	public class SoulGridCell extends ItemGridCell implements IDragSource, IDragTarget
	{
		// ------------------------------------------------
		// Attribute
		// ------------------------------------------------
		private var _grid : IGrid;

		// ------------------------------------------------
		// Creation
		// ------------------------------------------------
		public function SoulGridCell(data : ItemGridCellData, grid : IGrid)
		{
			_grid = grid;
			super(data);
		}

		// ------------------------------------------------
		// Drag
		// ------------------------------------------------
		public function get dragImage() : DisplayObject
		{
			var icon : SoulBD = new SoulBD();
			icon.source = _source as Soul;
			icon.mouseEnabled = false;
			icon.mouseChildren = false;
			return icon;
		}

		public function canSwap(source : IDragItem, target : IDragItem) : Boolean
		{
			return false;
		}

		public function dragEnter(dragData : DragData) : Boolean
		{
			if (dragData.dragItem as Soul)
			{
				var sourceSoul : Soul = dragData.dragItem as Soul;
				var targetSoul : Soul = source as Soul;
				var targetIndex : int = _grid.getIndex(row, col);

				// 吞噬
				if (targetSoul)
				{
					sourceSoul.mergeTo(source as Soul, targetIndex);
				}
				else if (dragData.dragSource is SoulSlotCell)
				{
					if (UserData.instance.tryPutPack(1) < 0)
					{
						StateManager.instance.checkMsg(153);
						SoulDragManager.state = SoulDragManager.IDLE;
						return false;
					}
					SoulDragManager.state = SoulDragManager.WAITING_REPLY;
					(dragData.dragSource as SoulSlotCell).slot.releaseTo(targetIndex);
				}
				else if (dragData.dragSource is SoulGridCell)
				{
					if (SoulDragManager.state == SoulDragManager.DRAGGING)
					{
						SoulDragManager.state = SoulDragManager.IDLE;
						DragManage.getInstance().finishDrag(true);
					}

					var sourceCell : ItemGridCell = dragData.dragSource as ItemGridCell;
					var sourceIndex : int = _grid.getIndex(sourceCell.row, sourceCell.col);
					ItemManager.instance.soulModel.setAt(targetIndex, sourceCell.source);
					ItemManager.instance.soulModel.removeAt(sourceIndex);

					var msg : CCPackChange = new CCPackChange();
					msg.topType |= Item.SOUL;
					Common.game_server.sendCCMessage(0xFFF2, msg);
				}
			}

			return true;
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

		private function mouseDownHandler(event : MouseEvent) : void
		{
			if (SoulDragManager.state != SoulDragManager.IDLE)
				return;
				
			if (!_source) return;
			var dragData : DragData = new DragData();
			dragData.dragSource = this;
			dragData.dragItem = (itemDO as ItemIcon).source;
			dragData.isAuto = false;
			dragData.callBack = onDragRelease;
			GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL, 2);
			DragManage.getInstance().darg(this, dragData, ViewManager.instance.uiContainer, true, false);
		}

		public function onDragRelease(dragTarget : IDragTarget, dragData : DragData) : Boolean
		{
			if (dragTarget != this && dragTarget is IDragTarget)
			{
				dragTarget.dragEnter(dragData);
			}

			if (SoulDragManager.state == SoulDragManager.IDLE)
			{
				DragManage.getInstance().finishDrag(false);
			}

			return false;
		}
	}
}
