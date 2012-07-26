package game.module.chat
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import game.module.chat.config.ChannelId;
    import game.net.core.Common;
    import game.net.data.CtoS.CSGlobalChat;
    import game.net.data.CtoS.CSGuildChat;
    import game.net.data.CtoS.CSLoudspeaker;
    import game.net.data.CtoS.CSTeamChat;
    import game.net.data.CtoS.CSWhisper;
//    import game.net.data.CtoS.CSAreaChat;


    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����4:37:54 
     */
    public class ProtoCtoSChat extends EventDispatcher
    {
        /** 单例对像 */
        private static var _instance : ProtoCtoSChat;

        public function ProtoCtoSChat(target : IEventDispatcher = null)
        {
            super(target);
        }

        /** 获取单例对像 */
        static public function get instance() : ProtoCtoSChat
        {
            if (_instance == null)
            {
                _instance = new ProtoCtoSChat();
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 模型 */
        private var modelChat:ModelChat = ModelChat.instance;
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        
		
		/**
		 * 发送消息
		 * */
		public function sendmsg(vo:VoChatMsg):void
		{
//			if(vo.color > 0) vo.content = "[color:" + vo.color + "]" + vo.content;
			switch(vo.channelId)
			{
				//世界 频道
				case ChannelId.WORLD:
					var globalChat:CSGlobalChat = new CSGlobalChat();
					globalChat.content = vo.content;
					Common.game_server.sendMessage(0x94,globalChat);
					break;
				//地区 频道 
				case ChannelId.AREA:
//					var areaChat:CSAreaChat = new CSAreaChat();
//					areaChat.content = vo.content;
//					Common.game_server.sendMessage(0x91,areaChat);
//					break;
				//队伍 频道 
				case ChannelId.TEAM:
					var teamChat:CSTeamChat = new CSTeamChat();
					teamChat.content = vo.content;
					Common.game_server.sendMessage(0x93,teamChat);
					break;
				//家族 频道 
				case ChannelId.CLAN:
					var guildChat:CSGuildChat = new CSGuildChat();
					guildChat.content = vo.content;
					Common.game_server.sendMessage(0x92,guildChat);
					break;
				//私聊 频道 
				case ChannelId.WHISPER:
					var whisper:CSWhisper = new CSWhisper();
					whisper.target = vo.recPlayerName;
					whisper.content = vo.content;
					Common.game_server.sendMessage(0x90,whisper);
					break;
				//大喇叭 频道 
				case ChannelId.NOTIC:
					var loudspeaker:CSLoudspeaker = new CSLoudspeaker();
					loudspeaker.content = vo.content;
					Common.game_server.sendMessage(0x95,loudspeaker);
					break;
				//提示 频道 
				case ChannelId.PROMPT:
					modelChat.addMsg(vo);
					break;
				//系统 频道 
				case ChannelId.SYSTEM:
					modelChat.addMsg(vo);
					break;
				//系统通告 频道 
				case ChannelId.SYSTEM_NOTIC:
					modelChat.addMsg(vo);
					break;
			}
		}
    }
}
