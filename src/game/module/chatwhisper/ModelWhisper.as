package game.module.chatwhisper {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import game.core.user.UserData;
	import game.module.chat.VoChatMsg;
	import game.module.chat.config.ChannelId;
	import game.module.chat.config.ChatConfig;
	import game.module.chatwhisper.config.WhisperConfig;
	import game.module.friend.ManagerFriend;
	import game.module.friend.VoFriendItem;


    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����2:40:24 
     */
    public class ModelWhisper extends EventDispatcher
    {
        /** 单例对像 */
        private static var _instance : ModelWhisper;

        public function ModelWhisper(target : IEventDispatcher = null)
        {
            super(target);
            // 读取消息缓存
            readHistory();
        }

        /** 获取单例对像 */
        static public function get instance() : ModelWhisper
        {
            if (_instance == null)
            {
                _instance = new ModelWhisper();
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 本地消息缓存对像 */
        protected var _sharedObject : SharedObject;

        public function get shareObjectKey() : String
        {
            return "ktpd_chat_history" + UserData.instance.playerId;
        }

        public function get shareObject() : SharedObject
        {
            if (_sharedObject) return _sharedObject;
            _sharedObject = SharedObject.getLocal(shareObjectKey);
            return _sharedObject;
        }

        public function get history() : Array
        {
            var obj : Object = shareObject.data["msgs"];
            if (obj == null) return null;
            return obj as Array;
        }

        public function set history(value : Array) : void
        {
            shareObject.data["msgs"] = value;
        }

        /** 写入消息缓存 */
        public function writeHistory(voMsg : VoChatMsg) : void
        {
            if (voMsg == null || voMsg.channelId != ChannelId.WHISPER) return;
            var arr : Array = history;
            if (arr == null) arr = [];
            while (arr.length > WhisperConfig.localCacheMsgMaxRow)
            {
                arr.shift();
            }
            arr.push(voMsg);
            history = arr;
        }

        /** 读取消息缓存 */
        public function readHistory() : void
        {
            var arr : Array = history;
            if (arr == null) return;
            var voMsg : VoChatMsg;
            for (var i : int = 0; i < arr.length; i++)
            {
                voMsg = new VoChatMsg();
                voMsg.mirrorValue(arr[i]);
                addMsg(voMsg, false);
            }
        }

        /** 清空缓存 */
        public function clearHistory() : void
        {
            delete shareObject.data["msgs"];
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 消息 */
        public var msgDic : Dictionary = new Dictionary();

        /** 添加消息 */
        public function addMsg(voMsg : VoChatMsg, isDispatchEvent : Boolean = true) : void
        {
            var bPlayerName : String = voMsg.playerName;
            if (bPlayerName == ChatConfig.selfPlayerName)
            {
                bPlayerName = voMsg.recPlayerName;
            }

            var voPlayerMsg : VoPlayerMsg = msgDic[bPlayerName];
            if (voPlayerMsg == null)
            {
                voPlayerMsg = new VoPlayerMsg();
                var voFriendItem : VoFriendItem = ManagerFriend.getInstance().findLastLinkByName(bPlayerName);

                if (voFriendItem == null)
                {
                    voFriendItem = ManagerFriend.getInstance().addLastLinkByName(bPlayerName);
                }
                voPlayerMsg.voPlayer = voFriendItem;
                msgDic[bPlayerName] = voPlayerMsg;
            }
            voPlayerMsg.appendMsg(voMsg);

            if (isDispatchEvent == true)
            {
                if (voMsg.channelId != ChannelId.DATE)
                {
                    voPlayerMsg.newMsgNum++;
                }
                
                // 抛出事件
                var event : EventWhisper = new EventWhisper(EventWhisper.ADD_MSG, true);
                event.voPlayerMsg = voPlayerMsg;
                event.voMsg = voMsg;
                dispatchEvent(event);
            }
        }

        /** 获取玩家消息数据结构 */
        public function getVoPlayerMsg(playerName : String) : VoPlayerMsg
        {
            var voPlayerMsg : VoPlayerMsg = msgDic[playerName];
            if (voPlayerMsg == null) return null;
            return voPlayerMsg;
        }

        /** 获取玩家消息 */
        public function getPlayerMsgs(playerName : String) : Vector.<VoChatMsg>
        {
            var voPlayerMsg : VoPlayerMsg = msgDic[playerName];
            if (voPlayerMsg == null) return null;
            return voPlayerMsg.msgs;
        }

        /** 发关有离线消息事件 */
        public function haveOfflineMsg() : void
        {
            // 抛出事件
            var event : EventWhisper = new EventWhisper(EventWhisper.HAVE_OFFLINE_MSG, true);
            dispatchEvent(event);
        }
    }
}
