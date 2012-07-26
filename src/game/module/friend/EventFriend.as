package game.module.friend
{
    import flash.events.Event;
    import game.module.friend.view.FriendItem;

    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-9  ����11:10:28 
     */
    public class EventFriend extends Event
    {
        /** 好友列表 -- 加载完成事件 */
        public static const FRIEND_LIST_DATA_LOAD_COMPLETED:String = "friendListData_loadCompleted";
        /** 好友数量发生改变 */
        public static const FRIEND_COUNT_CHANGE:String = "friendCountChange";
        /** 在线好友数量发生改变 */
        public static const ONLINE_FRIEND_COUNT_CHANGE:String = "onlineFriendCountChange";
        
        /** 添加组事件 */
        public static const ADD_GROUP:String = "addGroup";
        /** 删除组事件 */
        public static const REMOVE_GROUP:String = "removeGroup";
        /** 组重命名事件 */
        public static const GROUP_RENAME:String = "groupRename";
        
        
        /** 组中加入好友事件 */
        public static const GROUP_ADD_FRIEND:String = "groupAddFriend";
        /** 组中删除好友事件 */
        public static const GROUP_REMOVE_FRIEND:String = "groupRemoveFriend";
        
        
        /** 添加好友事件 */
        public static const ADD_FRIEND:String = "addFriend";
        /** 移除好友事件 */
        public static const Remove_FRIEND:String = "removeFriend";
        /** 好友数据更新事件 */
        public static const UPDATE_FRIEND:String = "updateFriend";
        /** 好友选中事件 */
        public static const SELECTED_FRIEND:String = "selectedFriend";
        
        
        /** 称出黑名单事件 */
        public static const MOUVE_OUT_BACKLIST:String = "moveOutBacklist";
        /** 称入黑名单事件 */
        public static const MOUVE_IN_BACKLIST:String = "moveInBacklist";
        
        /** 更新最近联系人列表 */
        public static const UPDATE_LAST_LINK:String = "updateLastLink";
        
        /** 新增好友申请 */
        public static const ADD_FRIEND_APPLY:String = "addFriendApply";
        
        //好友组件开始拖拽事件
        public static const FRIEND_ITEM_START_DRAG:String = "friendItemStartDrag";
        //好友组件停止拖拽事件
        public static const FRIEND_ITEM_STOP_DRAG:String = "friendItemStopDrag";
        
        /** 关闭事件 */
        public static const HIDE:String = "hide";
        
        /** 高度改变事件 */
        public static const HEIGHT_CHANGE:String = "heightChange";
        
        public var voFriendGroup:VoFriendGroup;
        public var voFriendItem:VoFriendItem;
        
        public var friendItem:FriendItem;
        public function EventFriend(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
