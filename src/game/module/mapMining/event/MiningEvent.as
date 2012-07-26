package game.module.mapMining.event
{
	import flash.events.Event;

	/**
	 * @author jian
	 */
	public class MiningEvent extends Event
	{
		public static const GO:String = "go";
		public static const OPEN_BASKET:String = "open_basket";
		
		public function MiningEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
