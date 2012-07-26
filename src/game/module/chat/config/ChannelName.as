package game.module.chat.config
{
	import flash.utils.Dictionary;

	/**
	 * 频道名称配置
	 * */
	public class ChannelName
	{
		/** 综合 频道 */
		public static const ALL:String = "综合";
		/** 世界 频道 */
		public static const WORLD:String = "世界";
		/** 地区 频道 */
		public static const AREA:String = "区域";
		/** 队伍 频道 */
		public static const TEAM:String = "队伍";
		/** 家族 频道 */
		public static const CLAN:String = "家族";
		/** 私聊 频道 */
		public static const WHISPER:String = "私聊";
		/** 系统 频道 */
		public static const SYSTEM:String = "系统";
		/** 大喇叭 频道 */
		public static const NOTIC:String = "喇叭";
		/** 提示 频道 */
		public static const PROMPT:String = "提示";
		/** 系统通告 频道 */
		public static const SYSTEM_NOTIC:String = "通告";
		
		private static var _dic:Dictionary;
		
		public function ChannelName()
		{
		}
		
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