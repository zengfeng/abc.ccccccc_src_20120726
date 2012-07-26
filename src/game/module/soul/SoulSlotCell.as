package game.module.soul
{
	import game.core.user.UserData;
	import game.core.item.Item;
	import game.core.item.soul.Soul;
	import game.core.item.soul.SoulSlot;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.quest.guide.GuideMange;
	import game.module.soul.soulBD.SoulBD;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.drag.DragData;
	import gameui.drag.DragManage;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragSource;
	import gameui.drag.IDragTarget;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.alert.Alert;
	import com.commUI.tooltip.SmallTip;
	import com.commUI.tooltip.SoulTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.ItemUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author jian
	 */
	public class SoulSlotCell extends GComponent implements IDragTarget, IDragSource
	{
		private var _slot : SoulSlot;
		private var _background : Sprite;
		private var _mc : SoulBD;
		private var _openLevel : uint;

		public function set openLevel(value : uint) : void
		{
			_openLevel = value;
		}

		public function SoulSlotCell()
		{
			var data : GComponentData = new GComponentData();
			super(data);
		}

		public function set slot(slot : SoulSlot) : void
		{
			_slot = slot;
			updateView();
		}

		public function get slot() : SoulSlot
		{
			return _slot;
		}

		public function get soul() : Soul
		{
			return _slot.equipable as Soul;
		}

		override public function set enabled(value : Boolean) : void
		{
			if (value)
				ToolTipManager.instance.destroyToolTip(this);
			else
				ToolTipManager.instance.registerToolTip(this, SmallTip, _openLevel + "级开启");
			super.enabled = value;
			mouseEnabled = mouseChildren = true;
		}

		public function updateView() : void
		{
			updateBackground();
			updateSoul();
		}

		private function updateBackground() : void
		{
			if (_background)
				removeChild(_background);

			if (_enabled)
			{
				if (_slot && _slot.equipable)
				{
					_background = UIManager.getUI(new AssetData(ItemUtils.getBorderByColor((_slot.equipable as Item).color)));
					_background.x = -23;
					_background.y = -23;
				}
				else
				{
					_background = UIManager.getUI(new AssetData(UI.SOUL_WHEEL_SLOT));
					_background.x = 0;
					_background.y = 0;
				}
			}
			else
			{
				_background = UIManager.getUI(new AssetData(UI.SOUL_WHEEL_SLOT_DISABLE));
				_background.x = 0;
				_background.y = 0;
			}

			addChild(_background);
		}

		private function updateSoul() : void
		{
			if (_mc)
			{
				removeChild(_mc);
				_mc.clear();
				_mc = null;
			}

			if (_slot)
			{
				var soul : Soul = _slot.equipable as Soul;

				if (soul)
				{
					_mc = new SoulBD(true, true);
					_mc.showRollOver = true;
					_mc.source = _slot.equipable as Soul;
					ToolTipManager.instance.registerToolTip(_mc, SoulTip, provideToolTipSoul);
					_mc.y = -5;
					_mc.x = 1;
					addChild(_mc);
				}
			}
		}

		public function dispose() : void
		{
			if (_background)
			{
				removeChild(_background);
				_background = null;
			}
			if (_mc)
			{
				removeChild(_mc);
				_mc.clear();
				_mc = null;
			}
		}

		public function provideToolTipSoul() : Soul
		{
			return _slot.equipable as Soul;
		}

		public function dragEnter(dragData : DragData) : Boolean
		{
			if (dragData.dragItem is Soul)
			{
				if (!enabled)
				{
					SoulDragManager.state = SoulDragManager.IDLE;
					return true;
				}

				var sourceSoul : Soul = dragData.dragItem as Soul;
				var targetSoul : Soul = _slot.equipable as Soul;

				if (targetSoul)
				{
					SoulDragManager.state = SoulDragManager.DRAGGING;
					sourceSoul.merge(targetSoul);
				}
				else
				{
					// _toolTip.source = sourceSoul;
					_slot.equip(sourceSoul);
					GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL, 3);
				}
				// TODO 测试
				(parent as SoulWheel).rollTaiChi();
			}
			return true;
		}

		public function canSwap(source : IDragItem, target : IDragItem) : Boolean
		{
			// TODO: Auto-generated method stub
			return false;
		}

		public function get dragImage() : DisplayObject
		{
			var icon : SoulBD = new SoulBD();
			icon.source = _slot.equipable as Soul;
			icon.mouseChildren = false;
			icon.mouseEnabled = false;

			// return UICreateUtils.createGImage((_slot.equipable as Item).mcUrl);
			return icon;
		}

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

		private function mouseDownHandler(event : MouseEvent) : void
		{
			if (SoulDragManager.state != SoulDragManager.IDLE)
				return;
				
			if (_slot.equipable)
			{
				var dragData : DragData = new DragData();
				dragData.dragSource = this;
				dragData.dragItem = _slot.equipable;
				dragData.isAuto = false;
				dragData.callBack = onDragRelease;
				DragManage.getInstance().darg(this, dragData, ViewManager.instance.uiContainer, true, false);
			}
		}

		public function onDragRelease(dragTarget : IDragTarget, dragData : DragData) : Boolean
		{
			if (!(dragTarget is IDragTarget) || dragTarget != this && !dragTarget.dragEnter(dragData))
			{
				StateManager.instance.checkMsg(231, null, confirmReleaseSoul, [(_slot.equipable as Soul).id]);
			}
			else
			{
				if (SoulDragManager.state == SoulDragManager.IDLE)
				{
					DragManage.getInstance().finishDrag(false);
				}
			}

			return true;
		}

		private function confirmReleaseSoul(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				if (UserData.instance.tryPutPack(1) < 0)
				{
					StateManager.instance.checkMsg(153);
					SoulDragManager.state = SoulDragManager.IDLE;
					DragManage.getInstance().finishDrag(false);
				}
				else
				{
					SoulDragManager.state = SoulDragManager.WAITING_REPLY;
					_slot.release();
				}
			}
			else
			{
				SoulDragManager.state = SoulDragManager.IDLE;
				DragManage.getInstance().finishDrag(false);
			}

			return true;
		}
	}
}
