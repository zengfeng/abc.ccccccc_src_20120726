package game.module.gem.attach
{
	import com.commUI.icon.ItemIcon;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.UICreateUtils;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.core.item.Item;
	import game.core.item.equipable.IEquipable;
	import game.core.item.equipable.IEquipableSlot;
	import game.core.item.gem.Gem;
	import game.definition.UI;
	import game.manager.ViewManager;
	import gameui.controls.GImage;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.drag.DragData;
	import gameui.drag.DragManage;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragSource;
	import gameui.drag.IDragTarget;
	import gameui.manager.GToolTipManager;
	import gameui.manager.UIManager;
	import net.AssetData;






	/**
	 * @author jian
	 */
	public class GemSlotCell extends GComponent implements IDragTarget, IDragSource
	{
		private var _icon : ItemIcon;
		private var _lock : Sprite;
		public var unlockLevel : uint;

		public function GemSlotCell()
		{
			var data : GComponentData = new GComponentData();
			super(data);
		}

		override protected function create() : void
		{
			_icon = UICreateUtils.createItemIcon({showBg:true, showBorder:true, showToolTip:true});
			_icon.background = UIManager.getUI(new AssetData(UI.GEM_SLOT));
			_icon.x = - _icon.width/2;
			_icon.y = - _icon.width/2;
			addChild(_icon);

			_lock = UIManager.getUI(new AssetData(UI.GEM_SLOT_DISABLE));
			_lock.visible = false;
			addChild(_lock);
		}

		public function set lock(value : Boolean) : void
		{
			_lock.visible = value;

			if (value)
			{
				toolTip = ToolTipManager.instance.getToolTip(ToolTip);
				toolTip.source = unlockLevel + "级解封";
				GToolTipManager.registerToolTip(toolTip);
			}
			else
			{
				if (toolTip)
					toolTip = null;
			}
		}

		override public function set source(value : *) : void
		{
			_source = value;
			_icon.source = IEquipableSlot(value).equipable as Item;
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		override protected function onHide() : void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			super.onHide();
		}

		// =====================
		// @Drag
		// =====================
		public function dragEnter(dragData : DragData) : Boolean
		{
			if (dragData.dragItem is Gem)
			{
				IEquipableSlot(_source).equip(IEquipable(dragData.dragItem));
			}
			return true;
		}

		public function canSwap(source : IDragItem, target : IDragItem) : Boolean
		{
			return false;
		}

		public function get dragImage() : DisplayObject
		{
			return UICreateUtils.createGImage((IEquipableSlot(_source).equipable as Item).imgUrl);
		}

		private function mouseDownHandler(event : MouseEvent) : void
		{
			var slot : IEquipableSlot = _source as IEquipableSlot;
			if (slot.equipable)
			{
				var dragData : DragData = new DragData();
				dragData.dragSource = this;
				dragData.dragItem = slot.equipable;
				dragData.stageX = 22;
				dragData.stageY = 22;

				DragManage.getInstance().darg(this, dragData, ViewManager.instance.uiContainer, true, false);
			}
		}
	}
}
