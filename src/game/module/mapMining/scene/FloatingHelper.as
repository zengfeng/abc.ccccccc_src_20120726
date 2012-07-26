package game.module.mapMining.scene
{
	import framerate.FrameTimer;
	import framerate.IFrame;

	import flash.display.DisplayObject;
	import flash.utils.getTimer;

	/**
	 * @author jian
	 */
	public class FloatingHelper implements IFrame
	{
		private var _target : DisplayObject;
		private var _startTime : uint;
		private var _startY : Number;
		private var _amplitude : Number;
		private var _period : Number;
		
		public function get target():DisplayObject
		{
			return _target;
		}

		public function setTarget(target : DisplayObject, amp : Number, period : Number) : void
		{
			_target = target;
			_amplitude = amp;
			_period = period;
			_startY = target.y;
			_startTime = getTimer();

			FrameTimer.add(this);
		}
		
		private var _lastTime:int = 0;

		public function action(time : uint) : void
		{
			if (time - _lastTime < 80)
				return;
				
			var t : Number = Math.PI * (getTimer() - _startTime) / (_period * 1000) ;
			_target.y = _startY + _amplitude * Math.sin(t);
			
			_lastTime = time;
		}

		public function restore() : void
		{
			_target.y = _startY;
			FrameTimer.remove(this);
		}
	}
}
