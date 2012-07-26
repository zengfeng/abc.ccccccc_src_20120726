package game.module.trade.exchange
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author qiujian
	 */
	public class ExchangeEvent extends Event
	{
		public static const REVIEW:String = "//trace_record_review";
		public static const CANCEL:String = "//trace_record_cancel";
		public static const DELETE:String = "//trace_record_delete";
		public static const RECEIVE:String = "//trace_record_receive";
		
		public var exchangeVO:ExchangeVO;
		
		public function ExchangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	
	}

}