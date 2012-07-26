package game.module.chat
{
	import flash.events.Event;

	/**
	 * @author jian
	 */
	public class SendToChatEvent extends Event
	{
		// =====================
		// 定义
		// =====================
		public static const ITEM : String = "send_to_chat_item";
		public static const HERO : String = "send_to_chat_hero";
		// =====================
		public var chatVO : *;

		public function SendToChatEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
