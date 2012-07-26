package game.module.chat
{
    import flash.events.Event;

    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����4:44:43 
     */
    public class EventChat extends Event
    {
		/** 添加消息 */
        public static const ADD_MSG:String = "addMsg";
		
		/** 频道发生改变 */
		public static const CHANNEL_CHANGE:String = "channelChange";
        
        /** 发送消息 */
        public static const SEND_MSG:String = "sendMsg";
        
        /** 选择面情 */
        public static const SELECTED_FACE:String = "selectedFace";
        
        /** 清除消息 */
        public static const CLEAR_MSG:String = "clearMsg";
        
        /** 选择频道 */
        public static const SELECTED_CHANNEL:String = "selectedChannel";
        /** 选择选家 */
        public static const SELECTED_PLAYER:String = "selectedPlayer";
        
        
        
		/** 消息 数据结构 */
        public var voMsg:VoChatMsg;
		/** 频道 数据结构 */
        public var voChannel:VoChannel;
        /** 面情ID */
        public var faceId:int;
        /** 玩家名称 */
        public var playerName:String;
        public function EventChat(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
