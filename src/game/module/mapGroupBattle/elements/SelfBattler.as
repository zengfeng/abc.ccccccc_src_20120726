package game.module.mapGroupBattle.elements
{
	import game.module.mapGroupBattle.GBProto;
	import game.module.mapGroupBattle.GBConfig;
	import game.core.user.UserData;
	import game.core.user.StateManager;

	import com.commUI.alert.Alert;
	import com.commUI.UIPlayerStatus;

	import flash.utils.getTimer;

	import game.module.mapGroupBattle.uis.UiSelfInfoBox;

	import worlds.apis.MPlayer;
	import worlds.apis.MSelfPlayer;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-2
	 */
	public class SelfBattler extends Battler
	{
		public function SelfBattler()
		{
		}

		override protected function installPlayer() : void
		{
			MPlayer.addSelf();
			player = MSelfPlayer.player;
			player.setColorStr(colorStr);
			player.setGlow(true);
		}

		override protected function destoryPlayer() : void
		{
			player.setGlow(false);
			player.setColorStr(playerStruct.colorStr);
			if(faseReviveAlert) faseReviveAlert.hide();
		}

		// =================
		// 复活UI
		// =================
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

		/** 快速复活对话框 */
		private var faseReviveAlert : Alert;

		/** 快速复活 */
		private function faseReviveCall() : void
		{
			if (faseReviveAlert == null)
			{
				faseReviveAlert = StateManager.instance.checkMsg(126, [], faseReviveAlertCall);
			}
			else
			{
				faseReviveAlert.show();
			}
		}

		/** 快速复活对话框回调 */
		private function faseReviveAlertCall(eventType : String) : Boolean
		{
			switch(eventType)
			{
				case Alert.OK_EVENT:
					if (UserData.instance.trySpendTotalGold(GBConfig.faseReviveGold) < 0 )
					{
						StateManager.instance.checkMsg(4);
						return false;
					}
					GBProto.instance.cs_fastResurrection();
					break;
			}
			return true;
		}

		/** 设置复活时间 */
		private function setDieTime(value : int = 0) : void
		{
			if (value > 1)
			{
				uiPlayerStatus.cdQuickenBtnCall = faseReviveCall;
				uiPlayerStatus.setCDTime(value);
				uiPlayerStatus.cdTimer.setTimersTip(10);
			}
			else
			{
				uiPlayerStatus.clearCD();
			}
		}

		// =================
		// 复活时间
		// =================
		public var statusTime : Number = 0;
		public var statusGTime : Number = 0;

		override public function setStatus(statusId : int, time : int = 0) : void
		{
			statusTime = time;
			statusGTime = getTimer();
			super.setStatus(statusId, time);
		}

		override public function statusDie() : void
		{
			super.statusDie();
			statusTime = statusTime - (getTimer() - statusGTime) / 1000;
			setDieTime(statusTime);
		}

		override public function recoverDie() : void
		{
			super.recoverDie();
			setDieTime(0);
		}

		// =================
		// 自己信息面板
		// =================
		private var _uiSelfInfo : UiSelfInfoBox;

		/** UI自己玩家信息面板 */
		public function get uiSelfInfo() : UiSelfInfoBox
		{
			return _uiSelfInfo;
		}

		public function set uiSelfInfo(uiSelfInfo : UiSelfInfoBox) : void
		{
			_uiSelfInfo = uiSelfInfo;
			if (_uiSelfInfo)
			{
				_uiSelfInfo.setPlayer(this);
			}
		}

		// ================
		// 设置信息
		// ================
		/** 连杀数 */
		override public function set killCount(killCount : uint) : void
		{
			super.killCount = killCount;
			if (uiSelfInfo)
			{
				uiSelfInfo.killCount = killCount;
			}
		}

		/** 最高连杀数 */
		override public function set maxKillCount(maxKillCount : uint) : void
		{
			super.maxKillCount = maxKillCount;
			if (uiSelfInfo)
			{
				uiSelfInfo.maxKillCount = maxKillCount;
			}
		}

		/** 胜利场数 */
		override public function set winCount(winCount : uint) : void
		{
			super.winCount = winCount;
			if (uiSelfInfo)
			{
				uiSelfInfo.winCount = winCount;
			}
		}

		/** 失败场数 */
		override public function set loseCount(loseCount : uint) : void
		{
			super.loseCount = loseCount;
			if (uiSelfInfo)
			{
				uiSelfInfo.loseCount = loseCount;
			}
		}

		/** 银币 */
		override public function set silver(value : int) : void
		{
			super.silver = value;
			if (uiSelfInfo)
			{
				uiSelfInfo.silver = value ;
			}
		}

		/** 玄铁 */
		override public function set darksteel(value : int) : void
		{
			super.darksteel = value;
			if (uiSelfInfo)
			{
				uiSelfInfo.darksteel = value ;
			}
		}
	}
}
