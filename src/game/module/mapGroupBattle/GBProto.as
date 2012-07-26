package game.module.mapGroupBattle
{
	import game.core.user.UserData;
	import game.module.mapGroupBattle.auxiliarys.Areas;
	import game.module.mapGroupBattle.auxiliarys.Status;
	import game.module.mapGroupBattle.elements.Battler;
	import game.module.mapGroupBattle.elements.Group;
	import game.module.mapGroupBattle.elements.SelfBattler;
	import game.net.core.Common;
	import game.net.data.CtoS.CSGroupBattleEnter;
	import game.net.data.CtoS.CSGroupBattleGroupData;
	import game.net.data.CtoS.CSGroupBattleInspire;
	import game.net.data.CtoS.CSGroupBattleInstantRevive;
	import game.net.data.CtoS.CSGroupBattleQuit;
	import game.net.data.CtoS.CSGroupBattleReady;
	import game.net.data.CtoS.CSGroupBattleVsEnd;
	import game.net.data.StoC.GBPlayerUpdateData;
	import game.net.data.StoC.GBUpdateData;
	import game.net.data.StoC.GroupBattleGroupData;
	import game.net.data.StoC.GroupBattlePlayerData;
	import game.net.data.StoC.GroupBattleSortData;
	import game.net.data.StoC.SCGroupBattleEnter;
	import game.net.data.StoC.SCGroupBattleGroupDataReply;
	import game.net.data.StoC.SCGroupBattlePlayerEnter;
	import game.net.data.StoC.SCGroupBattlePlayerLeave;
	import game.net.data.StoC.SCGroupBattlePlayerLost;
	import game.net.data.StoC.SCGroupBattlePlayerUpdate;
	import game.net.data.StoC.SCGroupBattleQuit;
	import game.net.data.StoC.SCGroupBattleReadyReply;
	import game.net.data.StoC.SCGroupBattleSortUpdate;
	import game.net.data.StoC.SCGroupBattleTime;
	import game.net.data.StoC.SCGroupBattleUpdate;

	import log4a.Logger;

	import worlds.apis.MPlayer;
	import worlds.roles.structs.PlayerStruct;

	import flash.geom.Point;
	import flash.utils.getTimer;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-12 ����7:00:37
	 */
	public class GBProto
	{
		function GBProto(singleton : Singleton) : void
		{
			singleton;
			sToC();
		}

		/** 单例对像 */
		private static var _instance : GBProto;

		/** 获取单例对像 */
		public static function get instance() : GBProto
		{
			if (_instance == null)
			{
				_instance = new GBProto(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 协议监听 */
		private function sToC() : void
		{
			// 协议监听 -- 0xCB 准备参加蜀山论剑
			Common.game_server.addCallback(0xCB, sc_ready);
			// 协议监听 -- 0xC0 参加蜀山论剑
			Common.game_server.addCallback(0xC0, sc_enter);
			// 协议监听 -- 0xC1 退出蜀山论剑
			Common.game_server.addCallback(0xC1, sc_quit);
			// 协议监听 -- 0xC2 蜀山论剑挑战信息更新
			Common.game_server.addCallback(0xC2, sc_GroupBattleUpdateList);
			// 协议监听 -- 0xC3 个人状态更新
			Common.game_server.addCallback(0xC3, sc_GroupBattlePlayerUpdateList);
			// 协议监听 -- 0xC4 蜀山论剑时间
			Common.game_server.addCallback(0xC4, sc_time);
			// 协议监听 -- 0xC5 蜀山论剑玩家进入
			Common.game_server.addCallback(0xC5, sc_playerEnter);
			// 协议监听 -- 0xC6 蜀山论剑玩家离开
			Common.game_server.addCallback(0xC6, sc_playerLeave);
			// 协议监听 -- 0xC7 蜀山论剑玩家轮空继续等待
			Common.game_server.addCallback(0xC7, sc_playerEmptyWait);
			//            //  协议监听 -- 0xC8 蜀山论剑鼓舞
			// Common.game_server.addCallback(0xC8, sc_inspire);
			// 协议监听 -- 0xC9 蜀山论剑连杀前三名更新
			Common.game_server.addCallback(0xC9, sc_fontSortUpdate);
			// 协议监听 -- 0xCA 蜀山论剑其他组的人数得分返回
			Common.game_server.addCallback(0xCA, sc_groupInfo);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 发送协议[0xC0] -- 参加蜀山论剑 */
		public function cs_enter() : void
		{
			var msg : CSGroupBattleEnter = new CSGroupBattleEnter();
			Common.game_server.sendMessage(0xC0, msg);
		}

		/** 发送协议[0xC1] -- 退出蜀山论剑 */
		public function cs_quit() : void
		{
			var msg : CSGroupBattleQuit = new CSGroupBattleQuit();
			Common.game_server.sendMessage(0xC1, msg);
		}

		/** 发送协议[0xC2] -- 对决完成 */
		public function cs_vsEnd() : void
		{
			var msg : CSGroupBattleVsEnd = new CSGroupBattleVsEnd();
			Common.game_server.sendMessage(0xC2, msg);
		}

		/** 发送协议[0xC3] -- 花费元宝复活 */
		public function cs_fastResurrection() : void
		{
			var msg : CSGroupBattleInstantRevive = new CSGroupBattleInstantRevive();
			Common.game_server.sendMessage(0xC3, msg);
		}

		/** 发送协议[0xC8] -- 提升属性(战斗力和HP) */
		public function cs_inspire(type : uint) : void
		{
			var msg : CSGroupBattleInspire = new CSGroupBattleInspire();
			msg.type = type;
			Common.game_server.sendMessage(0xC8, msg);
		}

		/** 发送协议[0xCA] -- 蜀山论剑请求其他组的人数得分 */
		public function cs_groupInfo(groupId : int) : void
		{
			var msg : CSGroupBattleGroupData = new CSGroupBattleGroupData();
			msg.groupId = groupId;
			Common.game_server.sendMessage(0xCA, msg);
		}

		/** 发送协议[0xCB] -- 参加国战加载完成 */
		public function cs_ready() : void
		{
			var msg : CSGroupBattleReady = new CSGroupBattleReady();
			Common.game_server.sendMessage(0xCB, msg);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var data : GBData = GBData.instance;
		private var control : GBControl = GBControl.instance;

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 协议监听 -- 0xCB 准备蜀山论剑 */
		public function sc_ready(msg : SCGroupBattleReadyReply) : void
		{
			// 1:成功 2:失败
			if (msg.ret == false) return;
			GBData.enInstall = false;
			GBControl.instance.installMap();
		}

		/** 协议监听 -- 0xC0 参加蜀山论剑 */
		public function sc_enter(msg : SCGroupBattleEnter) : void
		{
			// 1:成功 2:失败
			if (msg.result == 2) return;
			GBData.enInstall = false;
			// 是否有高级组
			GBData.hasHighLevel = msg.hasHighlevel;
			Areas.reset();
			// 初始化组
			var playerData : GroupBattlePlayerData;
			playerData = msg.playerList[0];
			data.initGroup(GBUtil.getLevel(playerData.group));
			// 组信息
			var groupData : GroupBattleGroupData;
			var group : Group;
			for each (groupData in msg.groupData)
			{
				group = data.getGroup(groupData.group);
				// group.count = groupData.playerNum;
				group.score = groupData.score;
			}
			// 玩家列表
			var playerStruct : PlayerStruct;
			var battler : Battler;
			var selfId : int = UserData.instance.playerId ;

			Logger.info("0xC0 参加蜀山论剑");
			for each (playerData in msg.playerList)
			{
				playerStruct = MPlayer.getStructOfGlobal(playerData.playerId);
				if (playerStruct == null)
				{
					playerStruct = new PlayerStruct();
					playerStruct.id = playerData.playerId;
					MPlayer.addStructToGlobal(playerStruct);
				}
				// Logger.info("playerId = " + playerStruct.id);

				playerStruct.name = playerData.playerName;
				playerStruct.heroId = playerData.job * 2 - (playerData.isMale ? 1 : 0);
				playerStruct.speed = 4;
				playerStruct.modelId = 0;
				playerStruct.avatarVer = 1;
				playerStruct.newAvatarVer = playerStruct.avatarVer ;
				if (playerData.playerId != selfId)
				{
					battler = new Battler();
				}
				else
				{
					data.selfBattler = new SelfBattler();
					data.selfBattler.statusTime = playerData.waitTime;
					data.selfBattler.statusGTime = getTimer();
					battler = data.selfBattler;
				}

				battler.playerId = playerStruct.id;
				battler.playerName = playerStruct.name;
				battler.playerStruct = playerStruct;
				battler.groupId = playerData.group;
				battler.statusId = playerData.playerSatus;
				battler.killCount = playerData.killStreak;
				battler.maxKillCount = playerData.maxKillStreak;
				battler.winCount = playerData.winCount;
				battler.loseCount = playerData.loseCount;
				battler.groupAB = GBUtil.getGroupAB(battler.groupId);
				battler.colorStr = GBUtil.getColorStr(battler.groupAB);
				battler.point = Areas.getRandom(battler.statusId, battler.groupAB);
				data.addBattler(battler);
			}
			// 自己的附加信息
			data.selfBattler.winCount = msg.totalWin;
			data.selfBattler.loseCount = msg.totalLose;
			data.selfBattler.silver = msg.totalSilver;
			data.selfBattler.darksteel = msg.totalDonate;

			// 第一名信息
			var sortData : GroupBattleSortData = msg.sortList;
			FirstInfo.has = sortData != null;
			if (sortData)
			{
				FirstInfo.playerId = sortData.playerId;
				FirstInfo.playerName = sortData.playerName;
				FirstInfo.groupId = sortData.group;
				FirstInfo.maxKillCount = sortData.maxKillStreak;
			}

			GBControl.instance.setOverTime(msg.surplusTime);
			// 安装
			GBControl.instance.installGroupBattle();
		}

		/** 协议监听 -- 0xC1 退出蜀山论剑 */
		private function sc_quit(msg : SCGroupBattleQuit) : void
		{
			msg;
			GBControl.instance.uninstall();
		}

		/** 协议监听 -- 0xC2 蜀山论剑挑战信息更新 */
		private function sc_GroupBattleUpdateList(msg : SCGroupBattleUpdate) : void
		{
			var updateData : GBUpdateData;
			var list : Vector.<GBUpdateData> = msg.updateData;
			for each (updateData in list)
			{
				sc_GroupBattleUpdate(updateData);
			}
		}

		/** 协议监听 -- 0xC2 蜀山论剑挑战信息更新 */
		private function sc_GroupBattleUpdate(msg : GBUpdateData) : void
		{
			if (control.installed) control.uiNewsPanel.appendBattleNews(msg);
			var winer : Battler = data.getBattler(msg.winPlayerId);
			var loser : Battler = data.getBattler(msg.losePlayerId);
			if (winer == null) return;
			winer.group.score = msg.winGroupScore;
			loser.group.score = msg.loseGroupScore;

			winer.killCount = msg.winPlayerKill;
			loser.killCount = 0;
			if (winer.killCount > winer.maxKillCount)
			{
				winer.maxKillCount = winer.killCount;
			}

			winer.winCount += 1;
			loser.loseCount += 1;

			winer.silver += msg.winSilver;
			loser.silver += msg.loseSilver;

			winer.darksteel += msg.winDonateCnt;
			loser.darksteel += msg.loseDonateCnt;
		}

		/** 协议监听 -- 0xC3 个人状态更新 */
		public function sc_GroupBattlePlayerUpdateList(msg : SCGroupBattlePlayerUpdate) : void
		{
			var updateData : GBPlayerUpdateData;
			var list : Vector.<GBPlayerUpdateData> = msg.playerUpdateData;
			for each (updateData in list)
			{
				sc_GroupBattlePlayerUpdate(updateData);
			}
		}

		/** 协议监听 -- 0xC3 个人状态更新 */
		public function sc_GroupBattlePlayerUpdate(msg : GBPlayerUpdateData) : void
		{
			var battler : Battler = data.getBattler(msg.playerId);
			if (msg.playerSatus != Status.VS)
			{
				if (!battler) return;
				if (battler.installed == false)
				{
					var x : int = battler.x;
					var y : int = battler.y;
					var groupAB : int = battler.groupAB;
					switch(msg.playerSatus)
					{
						case Status.DIE:
							if (Areas.isBirth(x, y, groupAB) == false)
							{
								battler.point = Areas.getRandomBirth(groupAB);
							}
							break;
						case Status.REST:
							if (Areas.isRest(x, y) == false)
							{
								battler.point = Areas.getRandomRestPoint(groupAB);
							}
							break;
						case  Status.MOVE:
						case  Status.WAIT:
							if (Areas.isRest(x, y) == false)
							{
								battler.point = Areas.getRandomRestPoint(groupAB);
							}
							break;
					}
				}
				battler.setStatus(msg.playerSatus, msg.time);
			}
			else
			{
				var point : Point = Areas.getVSPoint();
				if (battler)
				{
					battler.point = point;
					battler.setStatus(msg.playerSatus);
				}

				var battler2 : Battler = data.getBattler(msg.playerId2);
				if (battler2)
				{
					battler2.point = point ;
					battler2.setStatus(msg.playerSatus);
				}
			}
		}

		/** 协议监听 -- 0xC4 蜀山论剑时间 */
		private function sc_time(msg : SCGroupBattleTime) : void
		{
		}

		/** 协议监听 -- 0xC5 蜀山论剑玩家进入 */
		public function sc_playerEnter(msg : SCGroupBattlePlayerEnter) : void
		{
			// Logger.info("0xC5 蜀山论剑玩家进入 playerId = " + msg.playerData.playerId);
			var playerData : GroupBattlePlayerData = msg.playerData;
			var playerStruct : PlayerStruct = MPlayer.getStructOfGlobal(playerData.playerId);
			if (playerStruct == null)
			{
				playerStruct = new PlayerStruct();
				playerStruct.id = playerData.playerId;
				MPlayer.addStructToGlobal(playerStruct);
			}

			playerStruct.name = playerData.playerName;
			playerStruct.heroId = playerData.job * 2 - (playerData.isMale ? 1 : 0);
			playerStruct.speed = 4;
			playerStruct.modelId = 0;
			playerStruct.avatarVer = 1;
			playerStruct.newAvatarVer = playerStruct.avatarVer ;

			var battler : Battler = data.getBattler(playerStruct.id);
			if (battler == null)
			{
				battler = new Battler();
			}
			else
			{
				Logger.info("陈治国发了两次玩家进入");
			}

			battler.playerId = playerStruct.id;
			battler.playerName = playerStruct.name;
			battler.playerStruct = playerStruct;
			battler.groupId = playerData.group;
			battler.statusId = playerData.playerSatus;
			battler.killCount = playerData.killStreak;
			battler.maxKillCount = playerData.maxKillStreak;
			battler.winCount = playerData.winCount;
			battler.loseCount = playerData.loseCount;
			battler.groupAB = GBUtil.getGroupAB(battler.groupId);
			battler.colorStr = GBUtil.getColorStr(battler.groupAB);
			battler.point = Areas.getRandom(battler.statusId, battler.groupAB);
			data.addBattler(battler);
		}

		/** 协议监听 -- 0xC6 蜀山论剑玩家进入 */
		public function sc_playerLeave(msg : SCGroupBattlePlayerLeave) : void
		{
			data.removeBattler(msg.playerId);
		}

		/** 协议监听 -- 0xC7 蜀山论剑玩家轮空继续等待 */
		private function sc_playerEmptyWait(msg : SCGroupBattlePlayerLost) : void
		{
			var battler : Battler = data.getBattler(msg.playerId);
			if (control.uiNewsPanel) control.uiNewsPanel.appendEmptyWaitNews(msg);
			if (battler)
			{
				battler.silver += msg.silver;
				battler.darksteel += msg.donateCnt;
				battler.group.score = msg.groupScore;
			}
		}

		/** 协议监听 -- 0xC9 蜀山论剑连杀前三名更新 */
		private function sc_fontSortUpdate(msg : SCGroupBattleSortUpdate) : void
		{
			var sortData : GroupBattleSortData = msg.sortList;
			FirstInfo.has = true;
			FirstInfo.playerId = sortData.playerId;
			FirstInfo.playerName = sortData.playerName;
			FirstInfo.groupId = sortData.group;
			FirstInfo.maxKillCount = sortData.maxKillStreak;
			FirstInfo.update();
		}

		/** 协议监听 -- 0xCA 蜀山论剑其他组的人数得分返回 */
		private function sc_groupInfo(msg : SCGroupBattleGroupDataReply) : void
		{
			var groupData : GroupBattleGroupData = msg.groupData;
			var group : Group = data.getGroup(groupData.group);

			if (group)
			{
				group.score = groupData.score;
				group.count = groupData.playerNum;
			}
		}
	}
}
class Singleton
{
}