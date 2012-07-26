package game.module.chat
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import game.module.chat.config.ChannelId;
	import game.module.chat.config.ChannelMaxMsg;
	import game.module.chat.config.ChatConfig;
	import game.module.friend.ManagerFriend;


	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����4:39:58 
	 */
	public class ModelChat extends EventDispatcher {
		/** 单例对像 */
		private static var _instance : ModelChat;

		public function ModelChat(target : IEventDispatcher = null) {
			super(target);
			// 频道 消息池 字典
			channelMsgDic[ChannelId.WORLD] = worldMsgs;
			channelMsgDic[ChannelId.AREA] = areaMsgs;
			channelMsgDic[ChannelId.TEAM] = teamMsgs;
			channelMsgDic[ChannelId.CLAN] = clanMsgs;
			channelMsgDic[ChannelId.WHISPER] = whisperMsgs;
			channelMsgDic[ChannelId.SYSTEM] = systemMsgs;
			channelMsgDic[ChannelId.NOTIC] = noticMsgs;
			channelMsgDic[ChannelId.PROMPT] = promtMsgs;
			channelMsgDic[ChannelId.SYSTEM_NOTIC] = systemNoticMsgs;
		}

		/** 获取单例对像 */
		public static function get instance() : ModelChat {
			if (_instance == null) {
				_instance = new ModelChat();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 频道 消息池 字典 */
		public var channelMsgDic : Dictionary = new Dictionary();
		/** 世界 频道 消息池 */
		private var worldMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		/** 地区 频道 消息池 */
		private var areaMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		/** 队伍 频道 消息池 */
		private  var teamMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		/** 家族 频道 消息池 */
		private  var clanMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		/** 私聊 频道 消息池 */
		private  var whisperMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		/** 系统 频道 消息池 */
		private var systemMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		/** 系统通告 频道 消息池 */
		private var systemNoticMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		/** 大喇叭 频道 消息池 */
		private var noticMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		/** 提示 频道 消息池 */
		private var promtMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		/** 大喇叭播放完的 消息池 */
		public var noticPlayedMsgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 添加消息 */
		public function addMsg(vo : VoChatMsg) : void {
			
			if( ManagerFriend.getInstance().isInBackListByPlayerName(vo.playerName)  )
				return ;
			
			// 判断参数合法
			var channelId : uint = vo.channelId;
//			var msgs : Vector.<VoChatMsg> = channelMsgDic[channelId];
//			if (msgs == null) return;
//			// 执行
//			while (msgs.length > ChannelMaxMsg.getValue(channelId)) {
//				msgs.shift();
//			}
//			msgs.push(vo);
            //如果是私聊加入最近联系人
            if(vo.channelId == ChannelId.WHISPER)
            {
                if(vo.playerName != ChatConfig.selfPlayerName) ManagerFriend.getInstance().addLastLinkByName(vo.playerName);
                if(vo.recPlayerName != ChatConfig.selfPlayerName)ManagerFriend.getInstance().addLastLinkByName(vo.recPlayerName);
            }
			// 抛出事件
			var event : EventChat = new EventChat(EventChat.ADD_MSG, true);
			event.voMsg = vo;
			dispatchEvent(event);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		
	}
}
