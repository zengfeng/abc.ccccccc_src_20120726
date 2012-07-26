package game.module.mapBossWar {
	import game.core.avatar.AvatarThumb;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.module.bossWar.BossWarSystem;
	import game.module.bossWar.BossWarUIC;
	import game.module.bossWar.ProxyBossWar;
	import game.module.mapDuplUI.NextDo;
	import game.module.mapDuplUI.NextDoButton;
	import game.module.quest.QuestUtil;
	import game.net.core.Common;
	import game.net.data.StoC.SCPlayerWalk;

	import worlds.apis.BarrierOpened;
	import worlds.apis.MNpc;
	import worlds.apis.MPlayer;
	import worlds.apis.MSelfPlayer;
	import worlds.apis.MTo;
	import worlds.apis.MWorld;
	import worlds.roles.cores.Npc;
	import worlds.roles.cores.Player;
	import worlds.roles.cores.SelfPlayer;

	import com.commUI.UIPlayerStatus;

	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;

	/**
	 * @author Lv
	 */
	public class BOOSControll
	{
		function BOOSControll(singleton : Singleton) : void
		{
			singleton;
		}

		/** 单例对像 */
		private static var _instance : BOOSControll;
		private const bosslist : Array = [5001, 5002];

		/** 获取单例对像 */
		public static function get instance() : BOOSControll
		{
			if (_instance == null)
			{
				_instance = new BOOSControll(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private  function get selfPlayer() : SelfPlayer
		{
			return MSelfPlayer.player;
		}

		private function getPlayer(playerId : int) : Player
		{
			return MPlayer.getPlayer(playerId);
		}

		private var enterTime : Number = 0;
		/** 死亡玩家列表 */
		private var diePlayerList : Vector.<uint> = new Vector.<uint>();
		/** 自己是否死亡 */
		private var isSelfDie : Boolean = false;

		// =======================================进入=================================================
		/** 进入 */
		public function enter() : void
		{
			// 清理死亡玩家
			clearDiePlayer();
			//
			// 协议监听 -- 0x20 玩家走路
			Common.game_server.addCallback(0x20, sc_playerWalk);
			enterTime = getTimer();
			MWorld.sInstallComplete.add(initPathPass);

			StateManager.instance.changeState(StateType.BOSS_BATTLE);
		}

		/** 进入地图时初始化关卡 */
		private function initPathPass() : void
		{
			MWorld.sInstallComplete.remove(initPathPass);
			MNpc.add(2005);
			doorNpc = MNpc.getNpc(2005);
			if (doorNpc)
			{
				doorsill = doorNpc.avatar;
				doorsill.mouseEnabled = false;
				doorsill.mouseChildren = false;
				doorNpc.avatar.hideShodow();
			}

			// if (isSelfDie == false) {
			// openDiePassPath();
			// }
			if (ProxyBossWar.isDoorOpen)
				openDiePassPath();
			else
				closeDiePassPath();
			addBossToMap();
		}

		private function addBossToMap() : void
		{
			for each ( var bid : uint in bosslist )
			{
				// if (_bossID) return;
				if ( bid == _bossID )
				{
					addBoss(bid);
				}
				else
				{
					removeBoss(bid);
				}
			}
		}

		private function addBoss(id : uint) : void
		{
			var npc : Npc = MNpc.getNpc(id);
			if (npc)
				npc.addToLayer();
			else
				MNpc.addInstallCall(id, function(arr : Array) : void
				{
					MNpc.getNpc(arr[0]).addToLayer();
				}, [id]);
		}

		private function removeBoss(id : uint) : void
		{
			var npc : Npc = MNpc.getNpc(id);
			if ( npc)
				npc.removeFromLayer();
			else
				MNpc.addInstallCall(id, function(...args) : void
				{
					MNpc.getNpc(args[0]).removeFromLayer();
				}, [id]);
		}

		// 清理死亡玩家
		private function clearDiePlayer() : void
		{
			while (diePlayerList.length > 0)
			{
				diePlayerList.shift();
			}
		}

		/** 玩家走路 */
		private function sc_playerWalk(msg : SCPlayerWalk) : void
		{
			var toX : int = msg.xy & 0x3FFF;
			var toY : int = msg.xy >> 14;
			var fromX : int;
			var fromY : int;
			if (msg.hasFromXY)
			{
				fromX = msg.fromXY & 0x3FFF;
				fromY = msg.fromXY >> 14;
			}

			checkPlayerIsReive(msg.playerId, toX, toY, fromX, fromY, msg.hasFromXY);
		}

		/** 检查玩家是否复活 */
		private function checkPlayerIsReive(playerId : int, toX : int, toY : int, fromX : int, fromY : int, hasFrom : Boolean) : void
		{
			if (isDie(playerId) == false)
			{
				return;
			}

			// if (hasFrom) {
			// if (fromX < 1800 && fromY < 1104) {
			// return;
			// }
			// }

			if (BWMapConfig.reviveArea.isInArea(toX, toY) == false)
			{
				revive(playerId);
			}
		}

		/** 是否死亡 */
		private function isDie(playerId : int) : Boolean
		{
			return diePlayerList.indexOf(playerId) != -1;
		}

		private var setPlayerBattleTimerDic : Dictionary = new Dictionary();

		// =======================================复活===============================================================
		/** 复活 */
		public function revive(playerId : int = 0) : void
		{
			var playerAnimal : Player;
			if (playerId == UserData.instance.playerId || playerId == 0)
			{
				SignalBusManager.battleEnd.remove(setSelfPlayerDie);
				openDiePassPath();
				stopReviveTime();
				playerAnimal = selfPlayer;
				isSelfDie = false;
				if(BossWarSystem.isJoin)
					BossWarUIC.instance.myHeroRive();
			}
			else
			{
				var timer : uint = setPlayerBattleTimerDic[playerId];
				if (timer) clearTimeout(timer);
				// playerAnimal = getPlayer(playerId);
				playerAnimal = MPlayer.getPlayer(playerId);
				removeDiePlayer(playerId);
			}

			if (playerAnimal)
			{
				playerAnimal.cancelAttack() ;
				playerAnimal.setGhost(false);
			}
		}

		/** 设置自己玩家死亡 */
		private function setSelfPlayerDie() : void
		{
			setPlayerDie(UserData.instance.playerId);
		}

		/** 移除死亡玩家 */
		private function removeDiePlayer(playerId : int) : void
		{
			var index : int = diePlayerList.indexOf(playerId);
			if (index != -1)
			{
				diePlayerList.splice(index, 1);
			}
		}

		/** 设置玩家死亡状态 */
		private function setPlayerDie(playerId : int) : void
		{
			var playerAnimal : Player;
			if (playerId == UserData.instance.playerId || playerId == 0)
			{
				closeDiePassPath();
				playerAnimal = selfPlayer;
				isSelfDie = true;
			}
			else
			{
				var timer : uint = setPlayerBattleTimerDic[playerId];
				if (timer) clearTimeout(timer);
				playerAnimal = getPlayer(playerId);
				addDiePlayer(playerId);
			}

			if (playerAnimal)
			{
				playerAnimal.sitUp();
				playerAnimal.setGhost(false);
			}
		}

		/** 加入死亡玩家 */
		private function addDiePlayer(playerId : int) : void
		{
			var index : int = diePlayerList.indexOf(playerId);
			if (index == -1)
			{
				diePlayerList.push(playerId);
			}
		}

		/** 开放复活路口 */
		public function openDiePassPath() : void
		{
			BarrierOpened.setState(BWMapConfig.diePassColor, true);
			if (doorNpc) doorNpc.removeFromLayer();
			setNextDo(NextDo.GOTO_BATTLE);
			if (nextDoButton) nextDoButton.visible = true;
			_isWayPass = true;
			if(BossWarSystem.isJoin)
				BossWarUIC.instance.myHeroRive();
		}

		private var doorNpc : Npc;
		private var doorsill : AvatarThumb;
		private var _isWayPass : Boolean;

		/** 关闭复活路口 */
		private function closeDiePassPath() : void
		{
			BarrierOpened.setState(BWMapConfig.diePassColor, false);
			if (doorNpc) doorNpc.addToLayer();
			if (nextDoButton) nextDoButton.visible = false;
			_isWayPass = false;
			if(BossWarSystem.isJoin)
				BossWarUIC.instance.myHeroDie();
		}

		private function setNextDo(what : String) : void
		{
			if (nextDoButton) nextDoButton.nextDo = what;
		}

		private function checkRestNextDo() : void
		{
			MSelfPlayer.sWalkStart.remove(checkRestNextDo);
			nextDoButton.nextDo = nextDoButton.nextDo;
		}

		// ==================================公共======================================================
		private var _bossID : int;
		public var _nextDoButton : NextDoButton;

		public function get bossID() : int
		{
			return _bossID;
		}

		public function set bossID(bossID : int) : void
		{
			_bossID = bossID;
		}

		public function get nextDoButton() : NextDoButton
		{
			return _nextDoButton;
		}

		/** 停止复活时间 */
		private function stopReviveTime() : void
		{
			uiPlayerStatus.clearCD();
		}

		/** 复活CD时间UI */
		private var _uiPlayerStatus : UIPlayerStatus;

		/** 复活CD时间UI */
		private function get uiPlayerStatus() : UIPlayerStatus
		{
			if (_uiPlayerStatus == null)
			{
				_uiPlayerStatus = UIPlayerStatus.instance;
			}
			return _uiPlayerStatus;
		}

		// ===================================退出======================================================
		/** 退出 */
		public function quit() : void
		{
			// 协议监听 -- 0x20 玩家走路
			Common.game_server.removeCallback(0x20, sc_playerWalk);

			// 复活
			revive();
			// 复活所有死亡玩家
			reviveAllDiePlayer();
			// 清理死亡玩家
			clearDiePlayer();
			StateManager.instance.changeState(StateType.NO_STATE);
		}

		/** 复活所有死亡玩家 */
		private function reviveAllDiePlayer() : void
		{
			while (diePlayerList.length > 0)
			{
				revive(diePlayerList.shift());
			}
		}

		// =======================寻路按钮==================================================================
		public function set nextDoButton(value : NextDoButton) : void
		{
			_nextDoButton = value;
			_nextDoButton.onClickGotoBattleCall = gotoBattle;
			_nextDoButton.visible = isSelfDie;
			setNextDo(NextDo.WALKING);
		}

		private function gotoBattle() : void
		{
			var npcAnimation : Npc = MNpc.getNpc(bossID);
			if (npcAnimation) npcAnimation.avatar.mouseClickAction();
			setNextDo(NextDo.WALKING);
			MTo.toNpc(0, bossID, 0,  QuestUtil.npcClick, [bossID]);
			MSelfPlayer.sWalkStart.add(checkRestNextDo);
		}

		public function findWay() : void
		{
			MTo.toNpc(0, bossID, 0,  QuestUtil.npcClick, [bossID]);
		}

		// =============================战斗中……====================================================================
		// 战斗状态
		public function attackStatic(playerId : int = 0) : void
		{
			var playerAnimal : Player;
			if (playerId == UserData.instance.playerId || playerId == 0)
			{
				playerAnimal = selfPlayer;
			}
			else
			{
				playerAnimal = MPlayer.getPlayer(playerId);
			}

			if (playerAnimal)
			{
				var boss : Npc = MNpc.getNpc(bossID);
				if (!boss) return;
				playerAnimal.attack(boss);
			}
		}

		// =============================死亡====================================================================
		/** 死亡 */
		public function die(playerId : int = 0) : void
		{
			var playerAnimal : Player;
			if (!getPlayer(playerId)) return;
			playerAnimal = getPlayer(playerId);
			playerAnimal.setGhost(true);
			playerAnimal.cancelAttack();
			if (playerId == UserData.instance.playerId || playerId == 0)
			{
				closeDiePassPath();
				if(BossWarSystem.isJoin)
					BossWarUIC.instance.myHeroDie();
			}
			addDiePlayer(playerId);
		}

		// =======================================设置复活时间============================================================
		/** 快速复活按钮 点击事件 */
		public var fastReviveButtonClickCall : Function;
		/** 复活时间到了 */
		public var reviveCompleteCall : Function;

		/** 设置复活时间 */
		public function setReviveTime(value : int = 0) : void
		{
			if (value > 1)
			{
				uiPlayerStatus.cdQuickenBtnCall = fastReviveButtonClickCall;
				uiPlayerStatus.cdCompleteCall = reviveCompleteCall;
				uiPlayerStatus.setCDTime(value);
			}
			else
			{
				uiPlayerStatus.clearCD();
			}
		}
		
		//获取当前复活时间
		public function getNowReviveTimer():Number{
			if(uiPlayerStatus)
				return uiPlayerStatus.cdTimer.time;
			else
				return -1;
		}

		/** 设置快速复活按钮的tips **/
		public function setReviveBtnTips(pic : int) : void
		{
			uiPlayerStatus.cdTimer.setTimersTip(pic);
		}

		public function get IsSelfDie() : Boolean
		{
			return isSelfDie;
		}

		public function get isWayPass() : Boolean
		{
			return _isWayPass;
		}
	}
}
class Singleton
{
}
