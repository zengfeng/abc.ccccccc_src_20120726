package game.module.mapFishing
{
	import framerate.FrameTimer;

	import flash.display.DisplayObject;

	import framerate.IFrame;

	import flash.geom.Point;
	import flash.utils.getTimer;

	/**
	 * @author jian
	 */
	public class AwardAnimationHelper implements IFrame
	{
		private var lastTime : uint;
		private var _delay : int;
		private var _target : DisplayObject;
		private var _path : Array = [new Point(133, 129), new Point(132, 123), new Point(133, 105), new Point(134, 84), new Point(141, 54), new Point(154, 12), new Point(149, -57), new Point(125, -116), new Point(102, -129), new Point(68, -127), new Point(42, -126),];
		private var _index : uint;

		public function AwardAnimationHelper(target : DisplayObject)
		{
			_target = target;
		}

		public function action(timer : uint) : void
		{
			if ((timer - lastTime) >= _delay)
			{
				timerHandler();
				lastTime = getTimer();
			}
		}

		public function play(delay : int) : void
		{
			_index = 0;
			_delay = delay;
			FrameTimer.add(this);
		}

		private function timerHandler() : void
		{
			_index++;
			var pt : Point = _path[_index];

			_target.x = pt.x;
			_target.y = pt.y;

			if (_index == _path.length - 1)
				FrameTimer.remove(this);
		}
	}
}
