package test.debugTool
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	/**
	 * @author zheng
	 */
	public class DebugToolEvent extends Event
	{
		public static const ITEMSELECT:String = "itemselect";
		
		public var vo : DebugToolVO; 
		
		public function DebugToolEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	
	}
}
