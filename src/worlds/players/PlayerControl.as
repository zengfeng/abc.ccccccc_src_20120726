package worlds.players {
	import worlds.auxiliarys.PlayerGridInstance;

	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;

	import worlds.auxiliarys.listeners.Listener;
	import worlds.WorldStartup;
	import worlds.mediators.PlayerMediator;
	import worlds.roles.cores.Player;
	import worlds.roles.cores.SelfPlayer;
	import worlds.roles.structs.PlayerStruct;

	import mx.core.Singleton;

	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-25
	 */
	public class PlayerControl {
		/** 单例对像 */
		private static var _instance : PlayerControl;

		/** 获取单例对像 */
		public static  function get instance() : PlayerControl {
			if (_instance == null) {
				_instance = new PlayerControl(new Singleton());
			}
			return _instance;
		}

		function PlayerControl(singleton : Singleton) : void {
			singleton;
			PlayerMediator.getPlayer.register(getPlayer);
			PlayerMediator.cAddInstallListener.register(installListener.add);
			PlayerMediator.cRemoveInstallListener.register(installListener.remove);
			PlayerMediator.cAddDestoryistener.register(destoryListener.add);
			PlayerMediator.cRemoveDestoryistener.register(destoryListener.remove);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var playerData : PlayerData = PlayerData.instance;
		private var playerFactory : PlayerFactory = PlayerFactory.instance;
		private var selfPlayerManager : SelfManager = SelfManager.instance;
		public var playerDic : Dictionary = new Dictionary();
		private var installListener : Listener = new Listener();
		private var destoryListener : Listener = new Listener();
		private var tempKeyArr : Array = new Array();
		public var isLimitPlayer : Boolean = false;
		private var selfId : int = 0;

		public function getPlayer(playerId : int) : Player {
			return playerDic[playerId];
		}

		// ================
		// 自己玩家
		// ================
		/** 安装自己 */
		public function installSelf() : void {
			if (!playerData.hasSelf || !playerData.selfInfoNewest || playerData.selfInstalled) {
				return;
			}
			var playerStruct : PlayerStruct = playerData.self;
			selfId = playerStruct.id;
			selfPlayerManager.reset();
			var player : Player = SelfPlayer.instance;
			playerDic[playerStruct.id] = player;
			PlayerMediator.selfInstalled.dispatch();
			installListener.call(playerStruct.id);
			PlayerGridInstance.setSelf(player);
		}

		/** 卸载自己 */
		public function uninstallSelf() : void {
			selfPlayerManager.cache();
			destoryListener.call(WorldStartup.userId);
			installListener.clearID(WorldStartup.userId);
			destoryListener.clearID(WorldStartup.userId);
			delete playerDic[WorldStartup.userId];
		}

		// ================
		// 其他玩家
		// ================
		/** 安装(执行) */
		private function installPlayerExe(playerStruct : PlayerStruct) : void {
			if (_isHideOther) return;
			var player : Player;
			if (isLimitPlayer && (playerStruct.modelId == 0 || playerStruct.modelId == 20)) {
				player = playerFactory.makePlayer(playerStruct.id, playerStruct.name, playerStruct.colorStr, playerStruct.heroId, playerStruct.clothId, playerStruct.rideId);
//				 player = playerFactory.makePlayerNoAnimation();
				player.resetPlayer(playerStruct.id, playerStruct.name, playerStruct.colorStr, playerStruct.heroId, playerStruct.clothId, playerStruct.rideId);
				player.initPosition(playerStruct.x, playerStruct.y, playerStruct.speed, playerStruct.walking, getTimer() - playerStruct.walktimeStart, playerStruct.fromX, playerStruct.fromY, playerStruct.toX, playerStruct.toY);
				PlayerGridInstance.addPlayer(player);
				player.wander();
			} else {
				player = playerFactory.makePlayer(playerStruct.id, playerStruct.name, playerStruct.colorStr, playerStruct.heroId, playerStruct.clothId, playerStruct.rideId);
				player.resetPlayer(playerStruct.id, playerStruct.name, playerStruct.colorStr, playerStruct.heroId, playerStruct.clothId, playerStruct.rideId);
				player.initPosition(playerStruct.x, playerStruct.y, playerStruct.speed, playerStruct.walking, getTimer() - playerStruct.walktimeStart, playerStruct.fromX, playerStruct.fromY, playerStruct.toX, playerStruct.toY);
				player.addToLayer();
			}
			playerDic[playerStruct.id] = player;
			PlayerMediator.playerInstalled.dispatch(playerStruct.id);
			installListener.call(playerStruct.id);
		}

		/** 卸载(执行) */
		private function uninstallPlayerExe(playerId : int) : void {
			var player : Player = playerDic[playerId];
			if (!player) return;
			if (isLimitPlayer) PlayerGridInstance.removePlayer(player);
			var struct : PlayerStruct = playerData.getPlayer(playerId);
			if (struct) ModelOut.instance.execute(struct.id, struct.modelId);
			PlayerMediator.playerDestory.dispatch(playerId);
			player.destory();
			destoryListener.call(playerId);
			installListener.clearID(playerId);
			destoryListener.clearID(playerId);
			delete playerDic[playerId];
		}

		/** 安装所有可安装的 */
		public function installOtherPlayers() : void {
			if (_isHideOther) return;
			// startInstallOtherPlayers();
			var list : Vector.<PlayerStruct>= playerData.waitInstallInfoNewestList;
			while (list.length > 0) {
				installPlayerExe(list.shift());
			}
		}

		// ----------------  我是优美的分隔线 ---------------- //
		/** 安装 */
		public function installPlayer(playerStruct : PlayerStruct) : void {
			if (_isHideOther) return;
			if (playerDic[playerStruct.id]) return;
			if (!waitPlayerDic[playerStruct.id]) {
				waitPlayerList.push(playerStruct);
				waitPlayerDic[playerStruct.id] = playerStruct;
				if(!waitPlayerInstalling)
				{
					startInstallWaitPlayers();
				}
			}
		}

		/** 卸载 */
		public function uninstallPlayer(playerId : int) : void {
			if (_isHideOther) return;
			if (playerDic[playerId]) {
				uninstallPlayerExe(playerId);
			} else {
				var playerStruct : PlayerStruct = waitPlayerDic[playerId];
				if (playerStruct) {
					var index : int = waitPlayerList.indexOf(playerStruct);
					if (index != -1) {
						waitPlayerList.splice(index, 1);
					}
					waitPlayerDic[playerId] = null;
					delete waitPlayerDic[playerId];
				}
			}
		}

		// ----------------  我是优美的分隔线 ---------------- //
		private var waitPlayerList : Vector.<PlayerStruct> = new Vector.<PlayerStruct>();
		private var waitPlayerDic : Dictionary = new Dictionary();
		private var waitPlayerTimeer : uint = 0;
		private var waitPlayerLimitNum : int = 0;
		private var waitPlayerInstalling : Boolean = false;

		private function startInstallWaitPlayers() : void {
			if (waitPlayerList.length > 0) {
				waitPlayerInstalling = true;
				installWaitPlayersLimit();
			} else {
				waitPlayerInstalling = false;
			}
		}

		private function installWaitPlayersLimit() : void {
			waitPlayerLimitNum = 0;
			var playerStruct:PlayerStruct;
			while (waitPlayerList.length > 0) {
				playerStruct = waitPlayerList.shift();
				installPlayerExe(playerStruct);
				waitPlayerDic[playerStruct.id] = null;
				delete waitPlayerDic[playerStruct.id];
				waitPlayerLimitNum++;
				if (waitPlayerLimitNum > 0) break;
			}
			waitPlayerTimeer = setTimeout(startInstallWaitPlayers, 40);
		}

		public function clearInstallWaitPlayer() : void {
			clearTimeout(waitPlayerTimeer);
			waitPlayerInstalling = false;
			while (waitPlayerList.length > 0) {
				waitPlayerList.shift();
			}
			
			var keyArr:Array = [];
			var key:*;
			for (key in waitPlayerDic)
			{
				keyArr.push(key);
			}
			
			while(keyArr.length > 0)
			{
				key = keyArr.shift();
				waitPlayerDic[key] = null;
				delete waitPlayerDic[key];
			}
		}

		// ----------------  我是优美的分隔线 ---------------- //
		/** 卸载所有的玩家 */
		public function unstallOtherPlayers() : void {
			PlayerWaitShow.instance.clearup();
			var self : Player = playerDic[WorldStartup.userId];
			delete playerDic[WorldStartup.userId];
			var player : Player;
			var key : String;
			var struct : PlayerStruct;
			for (key in playerDic) {
				tempKeyArr.push(key);
			}

			while (tempKeyArr.length > 0) {
				key = tempKeyArr.shift();
				player = playerDic[key];
				struct = playerData.getPlayer(player.id);
				if (struct) ModelOut.instance.execute(struct.id, struct.modelId);
				player.destory();
				delete playerDic[key];
			}

			installListener.clearAll();
			destoryListener.clearAll();
			if (self) {
				playerDic[WorldStartup.userId] = self;
			}
		}

		// ================
		// 玩家操作
		// ================
		/** 玩家走路 */
		public function playerWalk(playerId : int, toX : int, toY : int, hasFrom : Boolean, fromX : int, fromY : int) : void {
			var player : Player = playerDic[playerId];
			if (!player) return;
			player.walkFromTo(toX, toY, hasFrom, fromX, fromY);
		}

		/** 玩家传送 */
		public function playerTransport(playerId : int, toX : int, toY : int) : void {
			var player : Player = playerDic[playerId];
			// var distance:Number = MapMath.distance(player.x, player.y, toX, toY);
			// if(distance < 50) return;
			if (!player) return;
			player.transportTo(toX, toY);
		}

		/** 玩家坐下 */
		public function sitDown(playerId : int, modelId : int) : void {
			modelId;
			var player : Player = playerDic[playerId];
			if (!player) return;
			player.sitDown();
		}

		/** 玩家站起 */
		public function sitUp(playerId : int) : void {
			var player : Player = playerDic[playerId];
			if (!player) return;
			player.sitUp();
		}

		// ================
		// 模式进入退出
		// ================
		public function modelIn(playerId : int) : void {
			if (playerId == selfId) return;
			var player : Player = getPlayer(playerId);
			if (player) PlayerGridInstance.modelIn(player);
		}

		public function modelOut(playerId : int) : void {
			if (playerId == selfId) return;
			var player : Player = getPlayer(playerId);
			if (player) PlayerGridInstance.modelOut(player);
		}

		// ================
		// 玩家属性
		// ================
		/** 玩家换衣服 */
		public function changeCloth(playerId : int, clothId : int) : void {
			var player : Player = playerDic[playerId];
			if (!player) return;
			player.changeCloth(clothId);
		}

		/** 玩家换坐骑 */
		public function changeRide(playerId : int, rideId : int) : void {
			var player : Player = playerDic[playerId];
			if (!player) return;
			player.rideUp(rideId);
		}

		// ================
		// 显示隐藏其他玩家
		// ================
		private function showOtherPlayers() : void {
			_isHideOther = false;
			installOtherPlayers();
		}

		private function hideOtherPlayers() : void {
			_isHideOther = true;
			clearInstallWaitPlayer();
			var player : Player;

			var self : Player = playerDic[WorldStartup.userId];
			delete playerDic[WorldStartup.userId];

			for each (player in playerDic) {
				playerData.hidePlayer(player.id);
			}

			if (self) {
				playerDic[WorldStartup.userId] = self;
			}
			unstallOtherPlayers();
		}

		private var _isHideOther : Boolean = false;

		public function get isHideOther() : Boolean {
			return _isHideOther;
		}

		public function set isHideOther(value : Boolean) : void {
			if (value) {
				hideOtherPlayers();
			} else {
				showOtherPlayers();
			}
		}
	}
}
