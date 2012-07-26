package game.module.soul.abyss
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author jian
	 */
	public class ShuffleBarEvent extends Event
	{
		public static const SELECT:String = "select";
		
		public var cell : DisplayObject; 
		
		public function ShuffleBarEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
