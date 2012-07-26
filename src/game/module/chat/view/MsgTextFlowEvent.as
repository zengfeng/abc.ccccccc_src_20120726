package game.module.chat.view
{
	import flash.events.Event;
	
	/**
	 * 消息组件事件
	 * */
	public class MsgTextFlowEvent extends Event
	{
		/** 点击频道 */
		public static const CLICK_CHANNEL:String = "clickChannel";
		
		/** 点击玩家 */
		public static const CLICK_PLAYER:String = "clickPlayer";
		
		/** 点击物品 */
		public static const CLICK_GOODS:String = "clickGoods";
		
		/** 点击NPC */
		public static const CLICK_NPC:String = "clickNPC";
		
		/** 点击地图 */
		public static const CLICK_MAP:String = "clickMap";
		/** 点击地图 */
		public static const CLICK_MAP_TRANSPORT:String = "clickMapTransport";
		/** 点击Item */
		public static const CLICK_ITEM:String = "clickItem";
		/** 点击Hero */
		public static const CLICK_HERO:String = "clickHero";
			
		private var _data:Object;
		public function MsgTextFlowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}