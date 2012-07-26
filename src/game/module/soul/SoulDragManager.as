package game.module.soul
{
	import flash.utils.setTimeout;
	import gameui.drag.DragManage;
	/**
	 * @author jian
	 */
	public class SoulDragManager
	{
		public static const IDLE:uint = 0;
		public static const DRAGGING:uint = 1;
		public static const WAITING_REPLY:uint = 2;
		
		private static var _state:uint = IDLE;
		
		public static function set state(value:uint):void
		{
			//trace("set state "+ value);
			_state = value;
			
			if (_state == WAITING_REPLY)
				setTimeout(onReplayTimeOut, 1000);
		}

		private static function onReplayTimeOut() : void
		{
		}
		
		public static function get state():uint
		{
			//trace("get state " + _state);
			return _state;
		}
	}
}
