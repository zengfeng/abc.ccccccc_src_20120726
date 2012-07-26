package game.module.riding
{
	import flash.events.Event;
	/**
	 * @author 1
	 */
	public class RidingUpdateEvent extends Event
	{
		public static const RIDINGUPDATE:String="riding_update" ;
		
		public var ridingVO:RidingVO;
		
		public function RidingUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
