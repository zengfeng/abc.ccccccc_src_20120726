package game.module.chat.config
{

	/**
	 * 频道ID配置
	 * */
	public class ChannelId
	{
		/** 综合 频道 */
		public static const ALL:uint = 0;
		/** 世界 频道 */
		public static const WORLD:uint = 1;
		/** 地区 频道 */
		public static const AREA:uint = 2;
		/** 队伍 频道 */
		public static const TEAM:uint = 3;
		/** 家族 频道 */
		public static const CLAN:uint = 4;
		/** 私聊 频道 */
		public static const WHISPER:uint = 5;
		/** 系统 频道 */
		public static const SYSTEM:uint = 6;
		/** 大喇叭 频道 */
		public static const NOTIC:uint = 7;
		/** 提示 频道 */
		public static const PROMPT:uint = 8;
		/** 系统通告 频道 */
		public static const SYSTEM_NOTIC:uint = 9;
        
        // --------- 特殊类型 --------- //
        /** 日期 */
         public static const DATE:uint = 10;
		
		public function ChannelId()
		{
		}

	}
}