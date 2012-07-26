package game.module.mapGroupBattle.uis
{
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.module.mapGroupBattle.GBConfig;
	import game.module.mapGroupBattle.GBData;
	import game.module.mapGroupBattle.elements.Battler;
	import game.net.data.StoC.GBUpdateData;
	import game.net.data.StoC.SCGroupBattlePlayerLost;

	import com.utils.ColorUtils;


	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-31 ����11:42:08
	 */
	public class NewsHTML
	{
		/** 玩家(蜀山论剑)数据结构管理 */
		private static var data : GBData = GBData.instance;

		/** 获取轮空信息 */
		public static function getEmptyWaitNews(msg : SCGroupBattlePlayerLost) : String
		{
			var player : Battler = data.getBattler(msg.playerId);
			var playerStr : String = NewsHTML.player(player.playerName, player.playerId, player.colorStr);

			var goodsStr : String = goods(GBConfig.awardGoodsId, msg.donateCnt);

			var str : String = GBConfig.htmlEmptyWait;
			str = str.replace(/__PLAYER__/gi, playerStr);
			str = str.replace(/__SILVER__/gi, msg.silver);
			str = str.replace(/__GOODS__/gi, goodsStr);
			return str;
		}

		/** 获取战斗信息 */
		public static function getBattleNewsList(msg : GBUpdateData) : Vector.<String>
		{
			var list : Vector.<String> = new Vector.<String>();
			var str : String = "";
			var winPlayer : Battler = data.getBattler(msg.winPlayerId);
			var losePlayer : Battler = data.getBattler(msg.losePlayerId);

			var winPlayerStr : String = player(winPlayer.playerName, winPlayer.playerId, winPlayer.colorStr);
			var losePlayerStr : String = player(losePlayer.playerName, losePlayer.playerId, losePlayer.colorStr);
			var winGoodsStr : String = goods(GBConfig.awardGoodsId, msg.winDonateCnt);
			var loseGoodsStr : String = goods(GBConfig.awardGoodsId, msg.loseDonateCnt);

			// A战胜B
			str = GBConfig.htmlWin;
			str = str.replace(/__WIN_PLAYER__/gi, winPlayerStr);
			str = str.replace(/__LOSE_PLAYER__/gi, losePlayerStr);
			str = str.replace(/__WIN_SILVER__/gi, msg.winSilver);
			str = str.replace(/__LOSE_SILVER__/gi, msg.loseSilver);
			str = str.replace(/__WIN_GOODS__/gi, winGoodsStr);
			str = str.replace(/__LOSE_GOODS__/gi, loseGoodsStr);
			var killCount : int = winPlayer.killCount + 1;
			if (killCount <= 1)
			{
				str = str.replace('已<font color="#FFFF00">__KILL_COUNT__</font>连胜，', "");
			}
			else
			{
				str = str.replace(/__KILL_COUNT__/gi, killCount);
			}
			list.push(str);

			// 如果是首杀
			if (msg.hasIsFirstBlood && msg.isFirstBlood == true)
			{
				str = GBConfig.htmlFirstKill;
				str = str.replace(/__WIN_PLAYER__/gi, winPlayerStr);
				str = str.replace(/__LOSE_PLAYER__/gi, losePlayerStr);
				list.push(str);
			}

			// 连胜
			killCount = winPlayer.killCount + 1;
			str = GBConfig.htmlWinKill(killCount);
			if (str)
			{
				str = str.replace(/__WIN_PLAYER__/gi, winPlayerStr);
				if (killCount > 10)
				{
					str = str.replace(/__KILL_COUNT__/gi, killCount);
				}
				list.push(str);
			}
			// 连胜被击杀
			killCount = losePlayer.killCount;
			str = GBConfig.htmlLoseKill(killCount);
			if (str)
			{
				str = str.replace(/__WIN_PLAYER__/gi, winPlayerStr);
				str = str.replace(/__LOSE_PLAYER__/gi, losePlayerStr);
				if (killCount > 10)
				{
					str = str.replace(/__KILL_COUNT__/gi, killCount);
				}
				list.push(str);
			}
			return list;
		}

		public static function player(playerName : String, playerId : int, playerColor : * = 0x0066EE) : String
		{
			var colorStr : String = colorToStr(playerColor);
			var str : String = "<font color='__COLOR__'><a href='event:player&__ID__&__NAME__'>[__NAME__]</a></font>";
			str = str.replace(/__NAME__/gi, playerName);
			str = str.replace(/__ID__/gi, playerId);
			str = str.replace(/__COLOR__/gi, colorStr);
			return str;
		}

		public static function goods(goodsId : int, num : int = 0) : String
		{
			var voItem : Item = ItemManager.instance.newItem(goodsId) ;
			var name : String = voItem ? voItem.name : "未知物品";
			var color : String = voItem ? ColorUtils.TEXTCOLOR[voItem.color] : ColorUtils.TEXTCOLOR[0];
//			var str : String = "<font color='__COLOR__'><a href='event:goods&__ID__' >[__NAME__]</a></font><font color='" + GBConfig.awardGoodsNumColor + "'>×__NUM__</font> ";
			var str : String = "<font color='__COLOR__'><a href='event:goods&__ID__' >[__NAME__]</a>×__NUM__</font> ";
			str = str.replace(/__NAME__/gi, name);
			str = str.replace(/__ID__/gi, goodsId);
			str = str.replace(/__COLOR__/gi, color);
			str = str.replace(/__NUM__/gi, num);
			return str;
		}

		public static function colorToStr(color : *) : String
		{
			var str : String = "";
			if (color is Number)
			{
				str = "#" + (color as Number).toString(16);
			}
			else
			{
				str = color + "";
			}
			//trace(str);
			return str;
		}
	}
}
