package game.module.mapGroupBattle
{
	import flash.net.SharedObject;
	import worlds.roles.cores.SelfPlayer;
	import worlds.roles.cores.Player;
	import flash.utils.Dictionary;
	import worlds.players.PlayerControl;
	import game.module.debug.GMMethod;
	import com.commUI.alert.Alert;
	import game.module.mapGroupBattle.uis.UiNewsPanel;
	import game.module.chat.marquee.MarqueeManager;
	import game.net.data.StoC.GroupBattleGroupData;
	import game.net.data.StoC.GroupBattleSortData;
	import game.net.data.StoC.SCGroupBattlePlayerLeave;
	import game.net.data.StoC.SCGroupBattlePlayerEnter;

	import log4a.Logger;

	import game.net.data.StoC.SCGroupBattlePlayerUpdate;

	import worlds.auxiliarys.MapMath;

	import game.module.mapGroupBattle.auxiliarys.Status;

	import worlds.apis.MSelfPlayer;
	import worlds.roles.structs.PlayerStruct;

	import game.net.data.StoC.GroupBattlePlayerData;
	import game.net.data.StoC.SCGroupBattleEnter;

	import gameui.controls.GButton;
	import gameui.data.GButtonData;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-2
	 */
	public class GBTest extends Sprite
	{
		public function GBTest()
		{
			initView();
		}

		/** 单例对像 */
		private static var _instance : GBTest;

		/** 获取单例对像 */
		public static function get instance() : GBTest
		{
			if (_instance == null)
			{
				_instance = new GBTest();
			}
			return _instance;
		}

		private function initView() : void
		{
			var buttonData : GButtonData;
			var button : GButton;
			/*
			buttonData = new GButtonData();
			buttonData.labelData.text = "进入国战";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, enter);

			buttonData = new GButtonData();
			buttonData.labelData.text = "DIE";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, die);

			buttonData = new GButtonData();
			buttonData.labelData.text = "WAIT";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, wait);

			buttonData = new GButtonData();
			buttonData.labelData.text = "REST";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, rest);

			buttonData = new GButtonData();
			buttonData.labelData.text = "VS";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, vs);

			buttonData = new GButtonData();
			buttonData.labelData.text = "ADD";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, add);

			buttonData = new GButtonData();
			buttonData.labelData.text = "REMOVE";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, remove);
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "ADD_NEWS";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, addNews);
			
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "Alert";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, alert);
			
			*/
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "地点1";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, go1);
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "地点2";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, go2);
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "地点3";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, go3);
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "地点4";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, go4);
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "ADD";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, addPlayer);
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "走路";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, walk);
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "不走路";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, noWalk);
			
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "同屏";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, limit);
			
			buttonData = new GButtonData();
			buttonData.labelData.text = "不同屏";
			button = new GButton(buttonData);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, onLimit);

			for (var i : int = 0; i < numChildren; i++)
			{
				var dis : DisplayObject = getChildAt(i);
				dis.x = i * 100;
			}

			x = 500;
			y = 250;
		}
		
		/** 本地消息缓存对像 */
		private static var _sharedObject:SharedObject;
        private static function get sharedObject() : SharedObject
		{
			if(_sharedObject == null)
			{
				_sharedObject = SharedObject.getLocal("ktpd_playerLimit");
			}
			return _sharedObject;
		}
		
		public static function get historyStartup() :Boolean
        {
            var obj : Object = sharedObject.data["isStartup"];
            if (obj == null) return false;
            return obj == "true";
        }

        public static function set historyStartup(value : Boolean) : void
        {
            sharedObject.data["isStartup"] = value ? "true" : "false";
			sharedObject.flush();
        }

		private function onLimit(event : MouseEvent) : void
		{
			historyStartup = false;
		}

		private function limit(event : MouseEvent) : void
		{
			historyStartup = true;
		}


		private function noWalk(event : MouseEvent) : void
		{
			var dic:Dictionary = PlayerControl.instance.playerDic;
			for each(var player:Player in dic)
			{
				if(player is SelfPlayer) continue;
				player.wanderCancel();
			}
		}

		private function walk(event : MouseEvent) : void
		{
			var dic:Dictionary = PlayerControl.instance.playerDic;
			for each(var player:Player in dic)
			{
				if(player is SelfPlayer) continue;
				player.wander();
			}
		}
		
		private function addPlayer(event : MouseEvent) : void
		{
			GMMethod.addPlayers(10);
		}
		
		private function go4(event : MouseEvent) : void {
			MSelfPlayer.player.walkPathTo(4351, 512);
		}

		private function go3(event : MouseEvent) : void {
			MSelfPlayer.player.walkPathTo(2204, 4348);
		}

		private function go2(event : MouseEvent) : void
		{
			MSelfPlayer.player.walkPathTo(5135, 3064);
		}

		private function go1(event : MouseEvent) : void
		{
			MSelfPlayer.player.walkPathTo(1375, 1760);
		}

		private function alert(event : MouseEvent) : void
		{
			Alert.show("", "", Alert.YES|Alert.CANCEL);
		}
		
		private var newsIndex:int = 0;
		private function addNews(event : MouseEvent) : void
		{
			GBControl.instance.uiNewsPanel.allMsg.appendHtmlText(newsIndex + ".可进尽快的实际付款了时间反馈" );
			newsIndex ++;
		}

		private function remove(event : MouseEvent) : void
		{
			var msg : SCGroupBattlePlayerLeave = new SCGroupBattlePlayerLeave();
			msg.playerId = 36;
			GBProto.instance.sc_playerLeave(msg);
		}

		private function add(event : MouseEvent) : void
		{
			var  i : int = 35;
			var playerData : GroupBattlePlayerData = new GroupBattlePlayerData();
			playerData.playerId = i + 1;
			playerData.playerName = "玩家" + playerData.playerId ;
			playerData.playerSatus = MapMath.randomInt(5, 1);
			playerData.isMale = Math.random() > 0.5;
			playerData.job = MapMath.randomInt(3, 1);
			playerData.group = i % 2 == 0 ? 2 : 3;
			playerData.killStreak = MapMath.randomInt(50, 0);
			playerData.maxKillStreak = MapMath.randomInt(100, playerData.killStreak);
			playerData.winCount = MapMath.randomInt(100, 50);
			playerData.loseCount = MapMath.randomInt(100, 10);
			var msg : SCGroupBattlePlayerEnter = new SCGroupBattlePlayerEnter();
			msg.playerData = playerData;
			GBProto.instance.sc_playerEnter(msg);
		}

		private var playerId : int = 25;

		private function vs(event : MouseEvent) : void
		{
			playerId = MapMath.randomInt(30, 7);
			if (playerId % 2 == 0) playerId -= 1;
			var msg : SCGroupBattlePlayerUpdate = new SCGroupBattlePlayerUpdate();
			msg.playerId = MSelfPlayer.id;
			msg.playerSatus = Status.VS;
			msg.playerId2 = playerId;
			Logger.info(playerId);
//			GBProto.instance.sc_GroupBattlePlayerUpdate(msg);
		}

		private function rest(event : MouseEvent) : void
		{
			var msg : SCGroupBattlePlayerUpdate = new SCGroupBattlePlayerUpdate();
			msg.playerId = MSelfPlayer.id;
			msg.playerSatus = Status.REST;
//			GBProto.instance.sc_GroupBattlePlayerUpdate(msg);

			msg = new SCGroupBattlePlayerUpdate();
			msg.playerId = playerId;
			msg.playerSatus = Status.DIE;
//			GBProto.instance.sc_GroupBattlePlayerUpdate(msg);
		}

		private function wait(event : MouseEvent) : void
		{
			var msg : SCGroupBattlePlayerUpdate = new SCGroupBattlePlayerUpdate();
			msg.playerId = MSelfPlayer.id;
			msg.playerSatus = Status.WAIT;
//			GBProto.instance.sc_GroupBattlePlayerUpdate(msg);
		}

		private function die(event : MouseEvent) : void
		{
			var msg : SCGroupBattlePlayerUpdate = new SCGroupBattlePlayerUpdate();
			msg.playerId = MSelfPlayer.id;
			msg.playerSatus = Status.DIE;
//			GBProto.instance.sc_GroupBattlePlayerUpdate(msg);

			msg = new SCGroupBattlePlayerUpdate();
			msg.playerId = playerId;
			msg.playerSatus = Status.REST;
//			GBProto.instance.sc_GroupBattlePlayerUpdate(msg);
		}

		private function enter(event : MouseEvent) : void
		{
			var msg : SCGroupBattleEnter = new SCGroupBattleEnter();
			msg.result = 1;
			msg.hasHighlevel = true;
			msg.totalWin = 20;
			msg.totalLose = 6;
			msg.totalSilver = 5000;
			msg.totalDonate = 6000;
			msg.surplusTime = 30 * 60;

			var groupData : GroupBattleGroupData;
			groupData = new GroupBattleGroupData();
			groupData.group = 0;
			groupData.playerNum = 15;
			groupData.score = 15 * 3;
			msg.groupData.push(groupData);
			groupData = new GroupBattleGroupData();
			groupData.group = 1;
			groupData.playerNum = 16;
			groupData.score = 16 * 3;
			msg.groupData.push(groupData);
			groupData = new GroupBattleGroupData();
			groupData.group = 2;
			groupData.playerNum = 66;
			groupData.score = 66 * 3;
			msg.groupData.push(groupData);
			groupData = new GroupBattleGroupData();
			groupData.group = 3;
			groupData.playerNum = 54;
			groupData.score = 54 * 3;
			msg.groupData.push(groupData);

			var playerData : GroupBattlePlayerData = new GroupBattlePlayerData();
			var struct : PlayerStruct = MSelfPlayer.struct;
			playerData.playerId = struct.id;
			playerData.playerName = struct.name;
			playerData.playerSatus = Status.WAIT;
			playerData.isMale = struct.heroId % 2 == 0;
			playerData.job = Math.ceil(struct.heroId / 2);
			playerData.group = 3;
			playerData.killStreak = MapMath.randomInt(50, 0);
			playerData.maxKillStreak = MapMath.randomInt(100, playerData.killStreak);
			playerData.winCount = MapMath.randomInt(100, 50);
			playerData.loseCount = MapMath.randomInt(100, 10);
			msg.playerList.push(playerData);

			for (var i : int = 10000; i < 11000; i++)
			{
				playerData = new GroupBattlePlayerData();
				playerData.playerId = i + 1;
				playerData.playerName = "玩家" + playerData.playerId ;
				playerData.playerSatus = i % 60 == 0 ? Status.VS : Status.REST;
				if ( i % 50 == 0) playerData.playerSatus = Status.DIE;
				if ( i % 30 == 0) playerData.playerSatus = Status.WAIT;
				playerData.isMale = Math.random() > 0.5;
				playerData.job = MapMath.randomInt(3, 1);
				playerData.group = i % 2 == 0 ? 2 : 3;
				playerData.killStreak = MapMath.randomInt(50, 0);
				playerData.maxKillStreak = MapMath.randomInt(100, playerData.killStreak);
				playerData.winCount = MapMath.randomInt(100, 50);
				playerData.loseCount = MapMath.randomInt(100, 10);
				msg.playerList.push(playerData);
			}

			var sortData : GroupBattleSortData = new  GroupBattleSortData();
			sortData.group = playerData.group;
			sortData.playerId = playerData.playerId;
			sortData.playerName = playerData.playerName;
			sortData.maxKillStreak = 70;
			msg.sortList.push(sortData);
			GBProto.instance.sc_enter(msg);
			
//			MarqueeManager.instance.showMarquee("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
		}
	}
}
