package game.module.mapFishing
{
	import flash.utils.Timer;
	/**
	 * @author jian
	 */
	public class FishingModel
	{
		// =====================
		// 定义
		// ===================== 
		public static const MAX_SECONDS:uint = 180;
		
		// =====================
		// 属性
		// =====================
		private var _totalSeconds:uint;
		
		public function set totalSeconds (value:uint):void
		{
			_totalSeconds = value;
			timer.repeatCount = value;
			timer.reset();
		}
		
		public function get totalSeconds ():uint
		{
			return _totalSeconds;
		}
		
		
		public var bait: int = -1;
		public var state : uint;
		public var timer:Timer;
		public var resume:Boolean;
		public var leftTimes : uint;
		public var awardId:uint;
	}
}
