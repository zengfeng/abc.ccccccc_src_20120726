package game.module.chat {
	import game.core.user.SysMsgVo;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import game.module.chat.config.ChannelId;
	import game.net.core.Common;
	import game.net.data.StoC.SCGlobalChat;
	import game.net.data.StoC.SCGuildChat;
	import game.net.data.StoC.SCLoudspeaker;
	import game.net.data.StoC.SCOfflineWhisper;
	import game.net.data.StoC.SCSystemAnnounce;
	import game.net.data.StoC.SCTeamChat;
	import game.net.data.StoC.SCWhisper;

	// import game.net.data.StoC.SCAreaChat;
	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����4:38:49 
	 */
	public class ProtoStoCChat extends EventDispatcher {
		/** 单例对像 */
		private static var _instance : ProtoStoCChat;

		public function ProtoStoCChat(target : IEventDispatcher = null) {
			super(target);

			// 协议监听
			sToC();
			SCOfflineWhisper;
		}

		/** 获取单例对像 */
		static public function get instance() : ProtoStoCChat {
			if (_instance == null) {
				_instance = new ProtoStoCChat();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 模型 */
		private var model : ModelChat = ModelChat.instance;

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 协议监听 */
		private function sToC() : void {
			// 协议监听 -- 私聊
			Common.game_server.addCallback(0x90, sc_whisper);
			// 协议监听 -- 地区
			// Common.game_server.addCallback(0x91, sc_areaChat);
			// 协议监听 -- 家族
			Common.game_server.addCallback(0x92, sc_guildChat);
			// 协议监听 -- 队伍
			Common.game_server.addCallback(0x93, sc_teamChat);
			// 协议监听 -- 世界
			Common.game_server.addCallback(0x94, sc_globalChat);
			// 协议监听 -- 大喇叭
			Common.game_server.addCallback(0x95, sc_loudspeaker);
			// 协议监听 -- 系统
			Common.game_server.addCallback(0x97, sc_systemAnnounce);
		}

		/** 协议监听 -- 私聊 */
		private function sc_whisper(message : SCWhisper) : void {
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.WHISPER;
			vo.playerName = message.from;
			vo.recPlayerName = message.target;
			vo.content = message.content;
			vo.serverId = message.server;
			vo.playerColorPropertyValue = message.potential;

			model.addMsg(vo);
		}

		/** 协议监听 -- 地区 */
		// private function sc_areaChat(message:SCAreaChat):void
		// {
		// var vo:VoChatMsg = new VoChatMsg();
		// vo.channelId = ChannelId.AREA;
		// vo.playerName = message.from;
		// vo.content = message.content;
		// vo.serverId = message.server;
		// vo.playerColorPropertyValue = message.potential;
		//
		// model.addMsg(vo);
		// }
		/** 协议监听 -- 家族 */
		private function sc_guildChat(message : SCGuildChat) : void {
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.CLAN;
			vo.playerName = message.from;
			vo.content = message.content;
			vo.playerColorPropertyValue = message.potential;
			vo.serverId = message.server;

			model.addMsg(vo);
		}

		/** 协议监听 -- 队伍 */
		private function sc_teamChat(message : SCTeamChat) : void {
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.TEAM;
			vo.playerName = message.from;
			vo.content = message.content;
			vo.playerColorPropertyValue = message.potential;
			vo.serverId = message.server;

			model.addMsg(vo);
		}

		/** 协议监听 -- 世界 */
		private function sc_globalChat(message : SCGlobalChat) : void {
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.WORLD;
			vo.playerName = message.from;
			vo.content = message.content;
			vo.playerColorPropertyValue = message.potential;
			vo.serverId = message.server;

			model.addMsg(vo);
		}

		/** 协议监听 --  系统 */
		private function sc_systemAnnounce(message : SCSystemAnnounce) : void {
			if (message.hasType) {
				var tempVo:SysMsgVo=new SysMsgVo();
				tempVo.runMsg(null,null,null,message.type<<13,message.content);
				return;
			}
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.SYSTEM;
			vo.content = message.content;

			model.addMsg(vo);
		}

		/** 协议监听 -- 大喇叭 */
		private function sc_loudspeaker(message : SCLoudspeaker) : void {
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.NOTIC;
			vo.playerName = message.from;
			vo.content = message.content;
			vo.playerColorPropertyValue = message.potential;
			vo.serverId = message.server;

			model.addMsg(vo);
		}
	}
}
