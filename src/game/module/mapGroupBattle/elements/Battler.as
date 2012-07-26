package game.module.mapGroupBattle.elements
{
	import game.module.mapGroupBattle.uis.UiPlayerItem;
	import game.module.mapGroupBattle.auxiliarys.Areas;
	import game.module.mapGroupBattle.GBConfig;

	import flash.geom.Point;

	import game.module.mapGroupBattle.auxiliarys.Status;

	import worlds.apis.MPlayer;
	import worlds.roles.cores.Player;
	import worlds.roles.structs.PlayerStruct;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-2
	 */
	public class Battler
	{
		public var installedPlayer:Boolean = false;
		public var installed : Boolean = false;
		public var playerId : int;
		public var playerName : String;
		public var colorStr : String;
		public var playerStruct : PlayerStruct;
		public var groupId : int;
		public var groupAB : int;
		/** 玩家状态 */
		public var statusId : int;
		/** 连杀数 */
		public var _killCount : int = 0;
		/** 最高连杀数 */
		public var _maxKillCount : int = 0;
		/** 胜利场数 */
		public var _winCount : uint = 0;
		/** 失败场数 */
		public var _loseCount : uint = 0;
		/** 银币 */
		public var _silver : int = 0;
		/** 玄铁 */
		public var _darksteel : int = 0;
		public var group : Group;
		public var point : Point;
		protected var player : Player;
		public var playerItem : UiPlayerItem;

		function Battler() : void
		{
		}

		public function install() : void
		{
			if (installed) return;
			playerStruct.x = x;
			playerStruct.y = y;
			installPlayer();
			if(!player) return;
			group.uiList.addPlayerData(this);
			initStatus();
			installed = true;
		}

		protected function installPlayer() : void
		{
			MPlayer.addStruct(playerStruct);
			player = MPlayer.getPlayer(playerId);
			if(!player) return;
			player.setColorStr(colorStr);
		}

		// =============
		// 销毁
		// =============
		public function destory(removeFromGroup : Boolean = false, destoryPlayer : Boolean = true) : void
		{
			if (!removeFromGroup) group.removeBattler(playerId);
			if (installed)
			{
				recoverNormal();
				if (destoryPlayer) this.destoryPlayer();
			}
			if (playerItem) playerItem.quit();
			group = null;
			playerStruct = null;
			player = null;
			playerItem = null;
		}

		protected function destoryPlayer() : void
		{
			player.setColorStr(playerStruct.colorStr);
			MPlayer.removePlayer(playerId);
		}

		protected function recoverNormal() : void
		{
			switch(statusId)
			{
				case Status.DIE:
					recoverDie();
					break;
				case Status.MOVE:
				case Status.WAIT:
					player.sWalkEnd.remove(statusWait);
					break;
				case Status.REST:
					player.sWalkEnd.remove(statusRest);
					break;
				case Status.VS:
					player.sWalkEnd.remove(statusVS);
					break;
			}
		}

		protected function initStatus() : void
		{
			switch(statusId)
			{
				case Status.DIE:
					statusDie();
					break;
				case Status.REST:
					statusRest();
					break;
				case Status.MOVE:
				case Status.WAIT:
					statusWait();
					break;
				case Status.VS:
					statusVS();
					break;
			}
		}

		public function setStatus(statusId : int, time:int = 0) : void
		{
			time;
			if (installed)
			{
				recoverNormal();
				this.statusId = statusId;
				switch(statusId)
				{
					case Status.DIE:
						if (Areas.isBirth(x, y, groupAB) == false)
						{
							point = Areas.getRandomBirth(groupAB);
							player.setPosition(x, y);
						}
						statusDie();
						break;
					case Status.REST:
						if (Areas.isRest(x, y) == false)
						{
							point = Areas.getRandomRestPoint(groupAB);
							player.sWalkEnd.add(statusRest);
							player.walkLineTo(x, y);
						}
						else
						{
							statusRest();
						}
						break;
					case  Status.MOVE:
					case  Status.WAIT:
						if (Areas.isRest(x, y) == false)
						{
							point = Areas.getRandomRestPoint(groupAB);
							player.sWalkEnd.add(statusWait);
							player.walkLineTo(x, y);
						}
						else
						{
							statusWait();
						}
						break;
					case Status.VS:
						player.sWalkEnd.add(statusVS);
						player.walkLineTo(x, y);
						break;
				}
				playerItem.status = statusId;
			}
			else
			{
				this.statusId = statusId;
			}
		}

		// ================
		// 回收状态
		// ================
		public function recoverDie():void
		{
			player.setGhost(false);
		}
		
		// ================
		// 设置状态
		// ================
		public function statusDie() : void
		{
			player.setGhost(true);
			player.setStandDirection(Areas.centerX, Areas.centerY);
		}

		public function statusVS() : void
		{
			player.sWalkEnd.remove(statusVS);
			player.actionAttack(player.x + (groupAB == GBConfig.GROUP_ID_A ? + 300 : -300));
		}

		public function statusRest() : void
		{
			player.sWalkEnd.remove(statusRest);
			player.sitDown();
		}

		public function statusWait() : void
		{
			player.sWalkEnd.remove(statusWait);
			player.setStandDirection(standX, y);
		}

		// ================
		// 位置信息
		// ================
		public function get standX() : int
		{
			return point.x + (groupAB == GBConfig.GROUP_ID_A ? 50 : - 50);
		}

		public function get x() : int
		{
			if (statusId == Status.VS)
			{
				return point.x + (groupAB == GBConfig.GROUP_ID_A ? -50 : + 50);
			}
			return point.x;
		}

		public function get y() : int
		{
			return point.y;
		}

		// ================
		// 设置信息
		// ================
		/** 连杀数 */
		public function get killCount() : uint
		{
			return _killCount;
		}

		public function set killCount(killCount : uint) : void
		{
			_killCount = killCount;
		}

		/** 最高连杀数 */
		public function get maxKillCount() : uint
		{
			return _maxKillCount;
		}

		public function set maxKillCount(maxKillCount : uint) : void
		{
			_maxKillCount = maxKillCount;
			if (playerItem)
			{
				playerItem.maxKill = maxKillCount;
			}
		}

		/** 胜利场数 */
		public function get winCount() : uint
		{
			return _winCount;
		}

		public function set winCount(winCount : uint) : void
		{
			_winCount = winCount;
		}

		/** 失败场数 */
		public function get loseCount() : uint
		{
			return _loseCount;
		}

		public function set loseCount(loseCount : uint) : void
		{
			_loseCount = loseCount;
		}

		/** 银币 */
		public function get silver() : int
		{
			return _silver;
		}

		public function set silver(value : int) : void
		{
			_silver = value;
		}

		/** 玄铁 */
		public function get darksteel() : int
		{
			return _darksteel;
		}

		public function set darksteel(value : int) : void
		{
			_darksteel = value;
		}
	}
}
