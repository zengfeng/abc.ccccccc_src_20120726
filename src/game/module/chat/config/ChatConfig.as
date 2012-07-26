package game.module.chat.config {
	import flash.utils.Dictionary;
	import game.config.StaticConfig;
	import game.core.user.UserData;
	import game.module.chat.VoChannel;


//	import game.net.core.Common;

	public class ChatConfig
	{
		/** 自己名称 */
		public static var selfPlayerName:String = UserData.instance.playerName;
		/** 服务器id */
		public static var serverId:uint = StaticConfig.gameNumber;
		/** 发送CD时间 */
		public static var sendCDTime:uint = 2000;
        /** 一次最多发送多少字 */
        public static var contentMaxLength:uint = 100;
        /** 大喇叭显示多少时间 */
        public static var noticShowTime:int = 5000;
        
        
        
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 发送CD时间 */
        private static var _channelSendCDTimeDic:Dictionary;
        public static function get channelSendCDTimeDic():Dictionary
        {
            if(_channelSendCDTimeDic) return _channelSendCDTimeDic;
            _channelSendCDTimeDic = new Dictionary();
			_channelSendCDTimeDic[ChannelId.WORLD] = 2000;
			_channelSendCDTimeDic[ChannelId.AREA] = 0;
			_channelSendCDTimeDic[ChannelId.TEAM] = 0;
			_channelSendCDTimeDic[ChannelId.CLAN] = 2000;
			_channelSendCDTimeDic[ChannelId.WHISPER] = 0;
			_channelSendCDTimeDic[ChannelId.NOTIC] = 0;
            return _channelSendCDTimeDic;
        }
        
        private static var _channelLevelLimtDic:Dictionary;
        /** 频道等级限制 */
        public static function get channelLevelLimtDic():Dictionary
        {
            if(_channelLevelLimtDic) return _channelLevelLimtDic;
            _channelLevelLimtDic = new Dictionary();
			_channelLevelLimtDic[ChannelId.WORLD] = 0;
			_channelLevelLimtDic[ChannelId.AREA] = 0;
			_channelLevelLimtDic[ChannelId.TEAM] = 0;
			_channelLevelLimtDic[ChannelId.CLAN] = 0;
			_channelLevelLimtDic[ChannelId.WHISPER] = 0;
			_channelLevelLimtDic[ChannelId.NOTIC] = 0;
            return _channelLevelLimtDic;
        }
        
        private static var _channelSendCDLimitList:Vector.<int>;
        /** 发送CD时间限制 */
        public static function get channelSendCDLimitList():Vector.<int> 
        {
            if(_channelSendCDLimitList) return _channelSendCDLimitList;
            _channelSendCDLimitList = new Vector.<int>();
            _channelSendCDLimitList.push(ChannelId.WORLD);
            _channelSendCDLimitList.push(ChannelId.CLAN);
            return _channelSendCDLimitList;
        }
        
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 综合 频道 数据Vo */
		public static var allVo : VoChannel = new VoChannel(ChannelId.ALL, ChannelName.dic[ChannelId.ALL], ChannelColor.dic[ChannelId.ALL]);
		/** 世界 频道 数据Vo */
		public static var worldVo : VoChannel = new VoChannel(ChannelId.WORLD, ChannelName.dic[ChannelId.WORLD], ChannelColor.dic[ChannelId.WORLD]);
		/** 地区 频道 数据Vo */
		public static var areaVo : VoChannel = new VoChannel(ChannelId.AREA, ChannelName.dic[ChannelId.AREA], ChannelColor.dic[ChannelId.AREA],true, false);
		/** 队伍 频道 数据Vo */
		public static var teamVo : VoChannel = new VoChannel(ChannelId.TEAM, ChannelName.dic[ChannelId.TEAM], ChannelColor.dic[ChannelId.TEAM], true, false);
		/** 家族 频道 数据Vo */
		public static var clanVo : VoChannel = new VoChannel(ChannelId.CLAN, ChannelName.dic[ChannelId.CLAN], ChannelColor.dic[ChannelId.CLAN], true, true);
		/** 私聊 频道 数据Vo */
		public static var whisperVo : VoChannel = new VoChannel(ChannelId.WHISPER, ChannelName.dic[ChannelId.WHISPER], ChannelColor.dic[ChannelId.WHISPER], true, false);
		/** 大喇叭 频道 数据Vo */
		public static var noticVo : VoChannel = new VoChannel(ChannelId.NOTIC, ChannelName.dic[ChannelId.NOTIC], ChannelColor.dic[ChannelId.NOTIC]);
		/** 系统 频道 数据Vo */
		public static var systemVo : VoChannel = new VoChannel(ChannelId.SYSTEM, ChannelName.dic[ChannelId.SYSTEM], ChannelColor.dic[ChannelId.SYSTEM]);
		/** 系统通告 频道 数据Vo */
		public static var systemNoticVo : VoChannel = new VoChannel(ChannelId.SYSTEM_NOTIC, ChannelName.dic[ChannelId.SYSTEM_NOTIC], ChannelColor.dic[ChannelId.SYSTEM_NOTIC], true, false);
        
		/** 频道 数据Vo 字典 */
		private static var _channelVoDic : Dictionary;
		/** 频道 数据Vo 列表 */
		private static var _channelVos:Vector.<VoChannel>;
        
		/** 频道 数据Vo 字典 */
        public static function get channelVoDic():Dictionary
        {
            if(_channelVoDic) return _channelVoDic;
            //频道 数据Vo 字典
            _channelVoDic = new Dictionary();
			_channelVoDic[ChannelId.ALL] = allVo;
			_channelVoDic[ChannelId.WORLD] = worldVo;
			_channelVoDic[ChannelId.AREA] = areaVo;
			_channelVoDic[ChannelId.TEAM] = teamVo;
			_channelVoDic[ChannelId.CLAN] = clanVo;
			_channelVoDic[ChannelId.WHISPER] = whisperVo;
			_channelVoDic[ChannelId.NOTIC] = noticVo;
			_channelVoDic[ChannelId.SYSTEM] = systemVo;
			_channelVoDic[ChannelId.SYSTEM_NOTIC] = systemNoticVo;
            return _channelVoDic;
        }
		/** 频道 数据Vo 列表 */
        public static function get channelVos():Vector.<VoChannel>
        {
            if(_channelVos) return _channelVos;
			//频道 数据Vo 列表
			_channelVos = new Vector.<VoChannel>();
			_channelVos.push(allVo);
			_channelVos.push(worldVo);
			_channelVos.push(areaVo);
			_channelVos.push(teamVo);
			_channelVos.push(clanVo);
			_channelVos.push(whisperVo);
			_channelVos.push(noticVo);
			_channelVos.push(systemVo);
			_channelVos.push(systemNoticVo);
            return _channelVos;
        }
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 输入频道配置 */
        public static var inputChannels:Array = [ChannelId.WORLD, ChannelId.CLAN, ChannelId.WHISPER, ChannelId.NOTIC];
        /** 输出频道配置 */
        public static var outputChannels:Array = [ChannelId.WORLD, ChannelId.CLAN, ChannelId.WHISPER, ChannelId.NOTIC,ChannelId.SYSTEM];
        
        /** 选中的Tab */
		public static var defaultOutputChannel:VoChannel = worldVo;
        /** 选中的ComboBox */
		public static var defaultInputChannel:VoChannel = worldVo;
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 频道默认接收 */
		private static var _channelDefaultAccept:Dictionary;
		public static function get channelDefaultAccept():Dictionary
		{
			if(_channelDefaultAccept == null)
			{
				_channelDefaultAccept = new Dictionary();
				//综合 频道
				_channelDefaultAccept[ChannelId.ALL] = [ChannelId.WORLD, ChannelId.AREA, ChannelId.TEAM, ChannelId.CLAN, ChannelId.WHISPER, ChannelId.SYSTEM_NOTIC];
				//世界 频道
				_channelDefaultAccept[ChannelId.WORLD] = [ChannelId.WORLD, ChannelId.AREA, ChannelId.TEAM, ChannelId.CLAN, ChannelId.WHISPER, ChannelId.SYSTEM_NOTIC];
				//地区 频道
				_channelDefaultAccept[ChannelId.AREA] = [ChannelId.AREA, ChannelId.WHISPER, ChannelId.SYSTEM_NOTIC];
				//队伍 频道
				_channelDefaultAccept[ChannelId.TEAM] = [ChannelId.TEAM, ChannelId.WHISPER, ChannelId.SYSTEM_NOTIC];
				//家族 频道
				_channelDefaultAccept[ChannelId.CLAN] = [ChannelId.CLAN, ChannelId.WHISPER, ChannelId.SYSTEM_NOTIC];
				//大喇叭 频道
				_channelDefaultAccept[ChannelId.NOTIC] = [ChannelId.NOTIC, ChannelId.SYSTEM_NOTIC];
				//私聊 频道
				_channelDefaultAccept[ChannelId.WHISPER] = [ ChannelId.WHISPER, ChannelId.SYSTEM_NOTIC];
				//系统 频道
				_channelDefaultAccept[ChannelId.SYSTEM] = [ChannelId.SYSTEM, ChannelId.SYSTEM_NOTIC];
			}
			
			return _channelDefaultAccept;
		}
		
		public static function set channelDefaultAccept(value:Dictionary):void
		{
			_channelDefaultAccept = value;
		}
		
		/** 频道接收 */
		private static var _channelAccept:Dictionary;
		public static function get channelAccept():Dictionary
		{
			if(_channelAccept == null)
			{
				_channelAccept = new Dictionary();
				//综合 频道
				_channelAccept[ChannelId.ALL] = [ChannelId.PROMPT, ChannelId.WORLD, ChannelId.AREA, ChannelId.TEAM, ChannelId.CLAN,  ChannelId.SYSTEM_NOTIC];
				//世界 频道
				_channelAccept[ChannelId.WORLD] = [ChannelId.PROMPT, ChannelId.WORLD, ChannelId.AREA, ChannelId.TEAM, ChannelId.CLAN,  ChannelId.SYSTEM_NOTIC];
				//地区 频道
				_channelAccept[ChannelId.AREA] = [ChannelId.PROMPT, ChannelId.AREA, ChannelId.SYSTEM_NOTIC];
				//队伍 频道
				_channelAccept[ChannelId.TEAM] = [ChannelId.PROMPT, ChannelId.TEAM,  ChannelId.SYSTEM_NOTIC];
				//家族 频道
				_channelAccept[ChannelId.CLAN] = [ChannelId.PROMPT, ChannelId.CLAN,  ChannelId.SYSTEM_NOTIC];
				//私聊 频道
				_channelAccept[ChannelId.WHISPER] = [ChannelId.PROMPT, ChannelId.WHISPER, ChannelId.SYSTEM_NOTIC];
				//系统 频道
				_channelAccept[ChannelId.SYSTEM] = [ChannelId.PROMPT, ChannelId.SYSTEM, ChannelId.SYSTEM_NOTIC];
				//大喇叭 频道
				_channelAccept[ChannelId.NOTIC] = [ChannelId.NOTIC, ChannelId.PROMPT, ChannelId.SYSTEM_NOTIC];
			}
			
			return _channelAccept;
		}

		public static function set channelAccept(value:Dictionary):void
		{
			_channelAccept = value;
		}
        
		
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		
		/** 颜色配置 */
		private static var _colors:Array;
		public static function get colors():Array
		{
			if(_colors == null)
			{
				_colors = [
					0x000000, 0xffff7a, 0x89fc7d, 0x02fc7e, 0x8afaff, 0x0082f8, 0xff7bc0, 0xfd82f7,
					0xff0008, 0xfffc03, 0x82fc01, 0x00ff3f, 0x04fefc, 0x0084bb, 0x8080c0, 0xf902ff,
					0x78463f, 0xf9814f, 0x01ff01, 0x037e85, 0x004182, 0x7f82f7, 0x7e0240, 0xff0082,
					0x810000, 0xff7e02, 0x047c00, 0x0d793d, 0x0200fe, 0x0002a3, 0x85007a, 0x7c00ff,
					0x410005, 0x804100, 0x024000, 0x003f44, 0xa09fa4, 0x000043, 0x40003f, 0x3f0089,
					0xfe817f, 0x7f8000, 0x7f7e46, 0x7f7f7f, 0x408082, 0xbfc1c0, 0x2e032e, 0xfefff3
				
				];
			}
			return _colors;
		}
		
		public static function set colors(arr:Array):void
		{
			_colors = arr;
		}
		
        public static var color : uint = 0xFFFFFF;
        public static var defaultColor : uint = 0xFFFFFF;

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //

	}
}