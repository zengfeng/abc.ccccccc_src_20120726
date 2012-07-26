package game.module.chat.config
{
    import flash.utils.Dictionary;
    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����5:55:45 
     */
    public class ChannelMaxMsg
    {
        /** 综合 频道 */
		public static var ALL:uint = 50;
        /** 世界 频道 */
		public static var WORLD:uint = 50;
		/** 地区 频道 */
		public static var AREA:uint = 50;
		/** 队伍 频道 */
		public static var TEAM:uint = 50;
		/** 家族 频道 */
		public static var CLAN:uint = 50;
		/** 私聊 频道 */
		public static var WHISPER:uint = 100;
		/** 系统 频道 */
		public static var SYSTEM:uint = 50;
		/** 大喇叭 频道 */
		public static var NOTIC:uint = 50;
		/** 提示 频道 */
		public static var PROMPT:uint = 50;
		/** 系统通告 频道 */
		public static var SYSTEM_NOTIC:uint = 9;
		
		private static var _dic:Dictionary;
		private static function setDic():void
		{
			_dic = new Dictionary();
			dic[ChannelId.ALL] = ALL;
			dic[ChannelId.WORLD] = WORLD;
			dic[ChannelId.AREA] = AREA;
			dic[ChannelId.TEAM] = TEAM;
			dic[ChannelId.CLAN] = CLAN;
			dic[ChannelId.WHISPER] = WHISPER;
			dic[ChannelId.SYSTEM] = SYSTEM;
			dic[ChannelId.NOTIC] = NOTIC;
			dic[ChannelId.PROMPT] = PROMPT;
			dic[ChannelId.SYSTEM_NOTIC] = SYSTEM_NOTIC;
		}
		
		public static function get dic():Dictionary
		{
			if(_dic == null) setDic();
			return _dic;
		}
        public static function getValue(channelId:uint):uint
        {
            return dic[channelId] ? dic[channelId] : 1;
        }
    }
}
