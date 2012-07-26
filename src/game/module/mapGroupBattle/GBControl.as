package game.module.mapGroupBattle
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import game.core.user.StateManager;

	import com.commUI.alert.Alert;

	import worlds.apis.validators.Validator;
	import worlds.apis.MValidator;
	import worlds.apis.MapUtil;

	import game.module.battle.view.BTSystem;
	import game.manager.SignalBusManager;
	import game.module.mapGroupBattle.elements.Battler;
	import game.module.mapGroupBattle.elements.Group;
	import game.module.mapGroupBattle.uis.GBUC;
	import game.module.mapGroupBattle.uis.UIStatusIcon;
	import game.module.mapGroupBattle.uis.UiNewsPanel;
	import game.module.mapGroupBattle.uis.UiPlayerList;
	import game.module.mapGroupBattle.uis.UiSelfInfoBox;
	import game.net.data.StoC.SCCityPlayers;

	import worlds.apis.MMouse;
	import worlds.apis.MWorld;
	import worlds.maps.configs.MapId;

	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-2
	 */
	public class GBControl
	{
		/** 单例对像 */
		private static var _instance : GBControl;

		/** 获取单例对像 */
		public static function get instance() : GBControl
		{
			if (_instance == null)
			{
				_instance = new GBControl(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		function GBControl(singleton : Singleton) : void
		{
			singleton;
		}

		/** 界面容器 */
		public var uc : GBUC;

		public function uninstall() : void
		{
			installed = false;
			isEnterMap = false;
			onMapInstallCompleteCall = null;
			clearTimeout(csEnterTime);
			MWorld.sUninstallComplete.remove(uninstall);
			SignalBusManager.battleEnd.remove(battleEndCall);
			if (uc)
			{
				uc.overTimer.stop();
				uc.hide();
				if (uc.parent) uc.parent.removeChild(uc);
			}
			UIStatusIcon.clear();
			GBData.instance.clearup();

			if (quitButtonOnClickAlert) quitButtonOnClickAlert.hide();
			MValidator.walk.remove(validatorCall);
			MValidator.transport.remove(validatorCall);
			MValidator.changeMap.remove(validatorCall);
			MValidator.joinOtherActivity.remove(validatorCall);
			if (validator && validatorUse) validator.go();
			validator = null;
			validatorUse = false;
		}

		private function battleEndCall() : void
		{
			BTSystem.INSTANCE().endBattleDelay(1000);
		}

		// =================
		// 安装
		// =================
		public var installed : Boolean;

		public function installMap() : void
		{
			if(isEnterMap) return;
			isEnterMap = false;
			clearTimeout(csEnterTime);
			SignalBusManager.battleEnd.add(battleEndCall);
			MWorld.sInstallComplete.add(onMapInstallComplete);
			changeMap();

			MValidator.walk.add(validatorCall);
			MValidator.transport.add(validatorCall);
			MValidator.changeMap.add(validatorCall);
			MValidator.joinOtherActivity.add(validatorCall);
		}

		private var validator : Validator;
		private var validatorUse : Boolean = false;

		private function validatorCall(v : Validator) : Boolean
		{
			validator = v;
			validatorUse = false;
			if (quitButtonOnClickAlert)
			{
				quitButtonOnClickAlert.show();
			}
			else
			{
				quitButtonOnClickAlert = StateManager.instance.checkMsg(193, null, quitButtonOnClickAlertCall);
			}
			return false;
		}

		private var quitButtonOnClickAlert : Alert;

		private function quitButtonOnClickAlertCall(eventType : String) : Boolean
		{
			switch(eventType)
			{
				case Alert.OK_EVENT:
					validatorUse = true;
					GBProto.instance.cs_quit();
					break;
			}
			return true;
		}

		/** 切换地图 */
		private function changeMap() : void
		{
			var changeMapMsg : SCCityPlayers = new SCCityPlayers();
			changeMapMsg.cityId = MapId.GROUPBATTLE;
			changeMapMsg.myX = 1920;
			changeMapMsg.myY = 771;
			MWorld.scChangeMap(changeMapMsg, false);
		}

		/** 当地图安装完成 */
		private function onMapInstallComplete() : void
		{
			if (MapUtil.isGroupBattleMap() == false)
			{
				uninstall();
				return;
			}
			MWorld.sInstallComplete.remove(onMapInstallComplete);
			MMouse.enableWalk = false;
			MWorld.needSendWalk = false;
			MWorld.sUninstallComplete.add(uninstall);
			isEnterMap = true;
			if(onMapInstallCompleteCall == null)
			{
				csEnterTime = setTimeout(GBProto.instance.cs_enter, 2000);
			}
			else
			{
				onMapInstallCompleteCall();
			}
		}
		private var csEnterTime:uint = 0;
		private var isEnterMap:Boolean = false;
		private var onMapInstallCompleteCall:Function;
		
		public function installGroupBattle():void
		{
			if(isEnterMap == false)
			{
				onMapInstallCompleteCall = installGroupBattle;
				installMap();
				return;
			}
			installUI();
			installOverTime();
			installBattlers();
			installed = true;
		}

		/** 安装玩家 */
		private function installBattlers() : void
		{
			var dic : Dictionary;
			if (GBData.instance.groupA)
			{
				dic = GBData.instance.groupA.dic;
				var battler : Battler;
				for each (battler in dic)
				{
					battler.install();
				}

				dic = GBData.instance.groupB.dic;
				for each (battler in dic)
				{
					battler.install();
				}
			}
			GBData.enInstall = true;
		}

		/** 安装UI */
		public function installUI() : void
		{
			var data : GBData = GBData.instance;
			if (!uc) uc = new GBUC();
			var group : Group;
			var uiGroup : UiPlayerList;
			// A组
			group = data.groupA;
			uc.centerMain.setIconA(group.id);
			uiGroup = uc.playerListA;
			// 设置组名
			uiGroup.setGroupName(group.id, group.name, group.colorStr, group.minLevel, group.maxLevel);
			uiGroup.setGroupIcon(group.id);
			uiGroup.setPlayerCount(group.count);
			// 设置积分
			uc.centerMain.setScore(group.score, group.id);
			group.uiList = uiGroup;

			// A副组
			group = data.groupAc;
			group.uiGroup = uiGroup.cGroup;
			group.uiGroup.groupId = group.id;
			group.uiGroup.setGroupName(group.name, group.colorStr, group.minLevel, group.maxLevel);
			group.uiGroup.setTip(group.count, group.score);

			// B组
			group = data.groupB;
			uc.centerMain.setIconB(group.id);
			uiGroup = uc.playerListB;
			// 设置组名
			uiGroup.setGroupName(group.id, group.name, group.colorStr, group.minLevel, group.maxLevel);
			uiGroup.setGroupIcon(group.id);
			uiGroup.setPlayerCount(group.count);
			// 设置积分
			uc.centerMain.setScore(group.score, group.id);
			group.uiList = uiGroup;

			// B副组
			group = data.groupBc;
			group.uiGroup = uiGroup.cGroup;
			group.uiGroup.groupId = group.id;
			group.uiGroup.setGroupName(group.name, group.colorStr, group.minLevel, group.maxLevel);
			group.uiGroup.setTip(group.count, group.score);

			// 设置排名
			FirstInfo.setCall(uc.centerMain.setFirstPlayer);
			// 玩家信息
			var selfInfo : UiSelfInfoBox = uc.selfInfo;
			data.selfBattler.uiSelfInfo = selfInfo;
			uc.show();
		}

		// ==================
		// 结束时间
		// ==================
		private var overTime : Number = -1;
		private var overGetTime : Number = 0;

		public function setOverTime(time : Number) : void
		{
			if (installed)
			{
				uc.overTimer.time = time;
				overTime = -1;
			}
			else
			{
				overGetTime = getTimer();
				overTime = time;
			}
		}

		public function installOverTime() : void
		{
			if (overTime != -1)
			{
				uc.overTimer.time = overTime - (getTimer() - overGetTime) / 1000;
				overTime = -1;
			}
		}

		/** 动态消息面板 */
		public function get uiNewsPanel() : UiNewsPanel
		{
			if (uc != null && uc.newsPanel != null)
			{
				return uc.newsPanel;
			}
			return null;
		}
	}
}
class Singleton
{
}