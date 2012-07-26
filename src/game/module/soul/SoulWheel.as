package game.module.soul
{
	import game.core.item.soul.SoulSlot;
	import game.definition.UI;
	import game.module.soul.abyss.AbyssView;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.geom.Point;





	/**
	 * @author jian
	 */
	public class SoulWheel extends GComponent
	{
		private var SLOT_POSITIONS : Array = [new Point(70, 44), new Point(267, 43), new Point(309, 145), new Point(272, 248), new Point(68, 248), new Point(27, 145)];
		private var _slotArray : Array;
		private var _taiChi : Sprite;

		public function SoulWheel()
		{
			var data : GComponentData = new GComponentData();
			super(data);
		}

		override protected function create() : void
		{
			addBackground();
			addTaiChi();
			addSlots();
		}

		private function addBackground() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.SOUL_WHEEL_BACKGROUND, "soul"));
			addChild(bg);
		}

		private function addTaiChi() : void
		{
			_taiChi = UIManager.getUI(new AssetData(UI.SOUL_WHEEL_TAICHI, "soul"));
			_taiChi.x = 168;
			_taiChi.y = 147;
			addChild(_taiChi);
		}

		private function addSlots() : void
		{
			_slotArray = new Array();

			for (var pos : uint = 0; pos < 6; pos++)
			{
				var pt : Point = SLOT_POSITIONS[pos];
				var slot : SoulSlotCell = new SoulSlotCell();
				slot.x = pt.x;
				slot.y = pt.y;
				slot.openLevel = 20 + pos * 10;
				
				addChild(slot);
				_slotArray[pos] = slot;
			}
		}

		public function set slotNum(num : uint) : void
		{
			if (num < 0 || num > 6) return;

			for (var pos : uint = 0; pos < 6; pos++)
			{
				var slot : SoulSlotCell = _slotArray[pos];
				slot.enabled = (pos < num);
			}
			
			updateView();
		}

		private function updateView() : void
		{
			for each (var slotView:SoulSlotCell in _slotArray)
			{
				slotView.updateView();
			}
		}

		public function set slots(soulSlots : Array) : void
		{
			removeSouls();
			for each (var slot:SoulSlot in soulSlots)
			{
				var slotView : SoulSlotCell = _slotArray[slot.pos];
				slotView.slot = slot;
			}
		}
		
		public function rollTaiChi():void
		{
			TweenLite.to(_taiChi, 2, {rotation:360});
		}

		private function removeSouls() : void
		{
			for each (var slotView:SoulSlotCell in _slotArray)
			{
				slotView.slot = null;
			}
		}
	}
}
