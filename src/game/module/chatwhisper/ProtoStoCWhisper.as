package game.module.chatwhisper
{
	import game.module.friend.ManagerFriend;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import game.module.chat.VoChatMsg;
	import game.module.chat.config.ChannelId;
	import game.module.chat.config.ChatConfig;
	import game.module.friend.VoFriendItem;
	import game.net.core.Common;
	import game.net.data.StoC.SCOfflineWhisper;
	import game.net.data.StoC.SCOfflineWhisper.OfflineMessage;
	import game.net.data.StoC.SCWhisper;
	import game.net.data.StoC.SCWhisperPtnInfo;


	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����2:39:06 
	 */
	public class ProtoStoCWhisper extends EventDispatcher
	{
		/** 单例对像 */
		private static var _instance : ProtoStoCWhisper;

		public function ProtoStoCWhisper(target : IEventDispatcher = null)
		{
			super(target);
			// 协议监听
			sToC();
		}

		/** 获取单例对像 */
		static public function get instance() : ProtoStoCWhisper
		{
			if (_instance == null)
			{
				_instance = new ProtoStoCWhisper();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 私聊模型 */
		private var modelWhisper : ModelWhisper = ModelWhisper.instance;

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 协议监听 */
		private function sToC() : void
		{
			// 协议监听 -- [0x90] 私聊
			Common.game_server.addCallback(0x90, sc_whisper);
			// 协议监听 -- [0x96] 聊天对象的信息
			Common.game_server.addCallback(0x96, sc_WhisperPtnInfo);
			// 协议监听 -- [0x98] 离线消息
			Common.game_server.addCallback(0x98, sc_OfflineWhisper);
		}

		/** 协议监听 -- [0x98] 离线消息 */
		private function sc_OfflineWhisper(message : SCOfflineWhisper) : void
		{
			// 发关有离线消息事件
			if (message.msglist.length > 0)
			{
				modelWhisper.haveOfflineMsg();
			}

			var offlineMessage : OfflineMessage;
			var voMsg : VoChatMsg;
			// 所有玩家消息列表，以玩家为字典
			var palyerMsgDic : Dictionary = new Dictionary();

			// palyerMsgDic[playerName][date] = Vector.<VoChatMsg>;

			var date : Date = new Date();
			for (var i : int = 0; i < message.msglist.length; i++)
			{
				offlineMessage = message.msglist[i];
				if( ManagerFriend.getInstance().isInBackListByPlayerName(offlineMessage.name) )
					continue ;
				voMsg = new VoChatMsg();
				voMsg.channelId = ChannelId.WHISPER;
				voMsg.playerName = offlineMessage.name;
				voMsg.content = offlineMessage.content;
				voMsg.recPlayerName = ChatConfig.selfPlayerName;

				// 所有玩家消息列表，以玩家为字典
				if (palyerMsgDic[voMsg.playerName] == null)
				{
					palyerMsgDic[voMsg.playerName] = new Dictionary();
				}
				// 玩家所有天的消息，以日期为字典
				date.time = offlineMessage.time;
				if (palyerMsgDic[voMsg.playerName][date.dateUTC] == null)
				{
					palyerMsgDic[voMsg.playerName][date.dateUTC] = new Vector.<VoChatMsg>();
					var voMsgDate : VoChatMsg = new VoChatMsg();
					voMsgDate.channelId = ChannelId.DATE;
					voMsgDate.playerName = offlineMessage.name;
					voMsgDate.recPlayerName = ChatConfig.selfPlayerName;
					voMsgDate.content = offlineMessage.time.toString() + "000";
					modelWhisper.addMsg(voMsgDate);
				}

				modelWhisper.addMsg(voMsg);
			}
		}

		/** 协议监听 -- [0x96] 聊天对象的信息 */
		private function sc_WhisperPtnInfo(message : SCWhisperPtnInfo) : void
		{
			var voFriendItem : VoFriendItem = new VoFriendItem();
			voFriendItem.name = message.name;
			voFriendItem.level = message.level;
			var event : EventWhisper = new EventWhisper(EventWhisper.SC_PLAYER_INFO, true);
			event.voFriendItem = voFriendItem;
			dispatchEvent(event);
		}

		/** 协议监听 -- [0x90] 私聊 */
		private function sc_whisper(message : SCWhisper) : void
		{
			if( ManagerFriend.getInstance().isInBackListByPlayerName(message.from) || ManagerFriend.getInstance().isInBackListByPlayerName(message.target) )
				return ;
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.WHISPER;
			vo.playerName = message.from;
			vo.recPlayerName = message.target;
			vo.content = message.content;
			vo.serverId = message.server;
			vo.playerColorPropertyValue = message.potential;
			modelWhisper.addMsg(vo);
			// 写入消息缓存
			modelWhisper.writeHistory(vo);
		}
	}
}
