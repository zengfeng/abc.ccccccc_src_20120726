package game.module.chat.config
{
    import flash.utils.Dictionary;

	/**
	 * 频道颜色配置
	 * */
	public class ChannelColor
	{
		
		/** 综合 频道 */
		public static var ALL:int = 0xffffff;
		/** 世界 频道 */
		public static var WORLD:int = 0xffffff;
		/** 地区 频道 */
		public static var AREA:int = 0x00a0e9;
		/** 队伍 频道 */
		public static var TEAM:int = 0x0078B244;
		/** 家族 频道 */
		public static var CLAN:int =0x98DE88;
		/** 私聊 频道 */
		public static var WHISPER:int = 0x22ac38;
		/** 系统 频道 */
		public static var SYSTEM:int = 0xFFFFFF;
		/** 大喇叭 频道 */
		public static var NOTIC:int = 0xFF9900;
		/** 提示 频道 */
		public static var PROMPT:int = 0xFFFF00;
		/** 系统通告 频道 */
		public static var SYSTEM_NOTIC:int = 0xFFFF00;
		public function ChannelColor()
		{
		}
		
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
		
		
	}
}