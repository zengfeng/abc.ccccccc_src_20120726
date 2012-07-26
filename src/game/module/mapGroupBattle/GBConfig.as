package game.module.mapGroupBattle
{
	import com.utils.StringUtils;

	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-31 ����4:05:06
	 */
	public class GBConfig
	{
		/** 级别1 */
		public static const LEVEL_1 : int = 0;
		/** 级别2 */
		public static const LEVEL_2 : int = 70;
		/**组A的ID */
		public static const GROUP_ID_A : int = 1;
		/** 组B的ID */
		public static const GROUP_ID_B : int = 2;
		/** 组A颜色 */
		public static const GROUP_COLOR_A : uint = 0x279F15;
		/** 组B颜色 */
		public static const GROUP_COLOR_B : uint = 0xFF7E00;
		/** 组A颜色字符串 */
		public static const GROUP_COLOR_STR_A:String = "#279F15";
		/** 组B颜色字符串 */
		public static const GROUP_COLOR_STR_B:String ="#FF7E00"; 
		/** 鼓舞最大等级 */
		public static var inspireMaxLevel : int = 5;
		/** 快速复活花费 */
		public static var faseReviveGold : int = 10;
		// ============
		// log配置
		// ============
		/** 战胜奖励物品 */
		public static var awardGoodsId : int = 1800;
		/** 战胜奖励物品数量颜色 */
		public static var awardGoodsNumColor : String = "#FFFFFF";
		// A战胜B
		public static var htmlWin : String = "__WIN_PLAYER__战胜了__LOSE_PLAYER__，__WIN_PLAYER__获得__WIN_SILVER__银币、__WIN_GOODS__，__LOSE_PLAYER__获得__LOSE_SILVER__银币、__LOSE_GOODS__";
		// 空等 轮空
		public static var htmlEmptyWait : String = "__PLAYER__轮空1分钟，获得__SILVER__银币，__GOODS__！";
		// 首杀
		public static var htmlFirstKill : String = "__WIN_PLAYER__干掉了__LOSE_PLAYER__，拿到了第一滴血！";
		// 连胜
		private static var _htmlWinKillDic : Dictionary;

		public static function get htmlWinKillDic() : Dictionary
		{
			if (_htmlWinKillDic == null)
			{
				_htmlWinKillDic = new Dictionary();
				_htmlWinKillDic[3] = "__WIN_PLAYER__ 连胜3场，初露锋芒，迈出胜利的第一步！";
				_htmlWinKillDic[4] = "__WIN_PLAYER__ 连胜4场，稳扎稳打，没有露出丝毫破绽！";
				_htmlWinKillDic[5] = "__WIN_PLAYER__ 连胜5场，击碎了对手的意志，对手已经溃不成军了！";
				_htmlWinKillDic[6] = "__WIN_PLAYER__ 连胜6场，的杀气几乎令敌人窒息！";
				_htmlWinKillDic[7] = "__WIN_PLAYER__ 连胜7场，嗜杀成性，已经丧失神智了！";
				_htmlWinKillDic[8] = "__WIN_PLAYER__ 连胜8场，神挡杀神，佛挡杀佛，快去阻止他（她）！";
				_htmlWinKillDic[9] = "__WIN_PLAYER__ 连胜9场，修罗附体，已经杀得变态了！";
				_htmlWinKillDic[10] = "__WIN_PLAYER__ 达到10连胜，已经天下无敌了，但求一败！";
				_htmlWinKillDic[100] = "__WIN_PLAYER__达到__KILL_COUNT__连胜： 已经天下无敌了，但求一败！";
			}
			return _htmlWinKillDic;
		}

		public static function htmlWinKill(killCount : int) : String
		{
			if (killCount > 10) return htmlWinKillDic[100];
			return htmlWinKillDic[killCount];
		}

		// 连胜被击杀
		private static var _htmlLoseKillDic : Dictionary;

		public static function get htmlLoseKillDic() : Dictionary
		{
			if (_htmlLoseKillDic == null)
			{
				_htmlLoseKillDic = new Dictionary();
				_htmlLoseKillDic[5] = "__LOSE_PLAYER__的5连胜被__WIN_PLAYER__终结了！";
				_htmlLoseKillDic[6] = "__LOSE_PLAYER__的6连胜被__WIN_PLAYER__终结了！";
				_htmlLoseKillDic[7] = "__LOSE_PLAYER__的7连胜被__WIN_PLAYER__终结了！";
				_htmlLoseKillDic[8] = "__LOSE_PLAYER__的8连胜被__WIN_PLAYER__终结了！";
				_htmlLoseKillDic[9] = "__LOSE_PLAYER__的9连胜被__WIN_PLAYER__终结了！";
				_htmlLoseKillDic[10] = "__LOSE_PLAYER__的10连胜被__WIN_PLAYER__终结了！";
				_htmlLoseKillDic[100] = "__LOSE_PLAYER__的__KILL_COUNT__连胜被__WIN_PLAYER__终结了！";
			}
			return _htmlLoseKillDic;
		}

		public static function htmlLoseKill(killCount : int) : String
		{
			if (killCount > 10) return htmlLoseKillDic[100];
			return htmlLoseKillDic[killCount];
		}

		public static function parseConfig(xml : XML) : void
		{
			var faseRevive : XML = xml.faseRevive[0];
			faseReviveGold = parseInt(faseRevive.@gold);
			var awardGood : XML = xml.awardGoods[0];
			awardGoodsId = parseInt(awardGood.@id);
			awardGoodsNumColor = StringUtils.colorToString(parseInt(awardGood.@numColor));
			htmlWin = xml.news.win.children()[0];
			htmlEmptyWait = xml.news.emptyWait.children()[0];
			htmlFirstKill = xml.news.firstKill.children()[0];
			var dic : Dictionary;
			var item : XML;
			var killCount : int;
			var str : String;
			dic = new Dictionary();
			for each (item in xml.news.winKillList.item)
			{
				killCount = parseInt(item.@killCount) ;
				str = item.children()[0];
				dic[killCount] = str;
			}
			_htmlWinKillDic = dic;

			dic = new Dictionary();
			for each (item in xml.news.loseKillList.item)
			{
				killCount = parseInt(item.@killCount) ;
				str = item.children()[0];
				dic[killCount] = str;
			}
			_htmlLoseKillDic = dic;
		}
	}
}
