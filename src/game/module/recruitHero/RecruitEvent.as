package game.module.recruitHero {
	import flash.events.Event;

	/**
	 * @author 1
	 */
	public class RecruitEvent extends Event {
		
		public static var PASS_TO_HERO_GET_ID:String = "pass_to_hero_get_id";
		
		public var heroID:int;
		
		
		//声望兑换 
		public static var EXCHANGE_HONOUT_NUM:String = "exchange_honour_num";
		
		public function RecruitEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
