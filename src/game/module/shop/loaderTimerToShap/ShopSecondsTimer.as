package game.module.shop.loaderTimerToShap {
	import flash.events.TimerEvent;
	import framerate.ExactTimer;
	/**
	 * @author Lv
	 */
	public class ShopSecondsTimer {
		private static var _timer : ExactTimer = new ExactTimer(100,100,0);

		private static var _funList : Vector.<Function> = new Vector.<Function>();
		public static function addFunction(fun : Function) : void
		{
			var index : int = _funList.indexOf(fun);
			if (index == -1)
			{
				_funList.push(fun);
				if (!_timer.running)
				{
					_timer.addEventListener(TimerEvent.TIMER,timerHandler);
					_timer.start();
				}
			}
		}

		public static function removeFunction(fun : Function) : void
		{
			var index : int = _funList.indexOf(fun);
			if (index == -1)
				return;
			_funList.splice(index,1);
			if (_funList.length == 0)
			{
				if (_timer.running)
				{
					_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
					_timer.stop();
				}
			}
		}

		public static function get running() : Boolean
		{
			return _timer.running ? true : _funList.length <= 0;
		}

		private static function timerHandler(event : TimerEvent) : void
		{
			if ( _funList.length == 0)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_timer.stop();
				return;
			}
			for each (var fun:Function in _funList)
			{
				fun();
			}
			event.updateAfterEvent();
		}
	}
}
