package game.module.chatwhisper
{
    import flash.events.Event;
    import game.module.chat.VoChatMsg;
    import game.module.friend.VoFriendItem;


    /**
     * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-20 ����5:11:21
     */
    public class EventWhisper extends Event
    {
        
		/** 服务器发来玩家消息 */
        public static const SC_PLAYER_INFO:String = "scPlayerInfo";
        /** 关闭玩家列表中的某个 */
        public static const CLOSE_PLAYER_LIST_ITEM:String = "closePlayerListItem";
        /** 选中玩家列表中的某个 */
        public static const SELECTED_PLAYER_LIST_ITEM:String = "selectedPlayerListItem";
        
        /** 窗口状态改变 */
        public static const WINDOW_STATE_CHANGE:String = "windowStateChange";
        
        /** 发送消息 */
        public static const SEND_MSG:String = "sendMsg";
		/** 添加消息 */
        public static const ADD_MSG:String = "addMsg";
		/** 有离线消息 */
        public static const HAVE_OFFLINE_MSG:String = "haveOfflineMsg";
        
        public var voFriendItem:VoFriendItem;
        public var voPlayerMsg:VoPlayerMsg;
		/** 消息 数据结构 */
        public var voMsg:VoChatMsg;
        public function EventWhisper(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
