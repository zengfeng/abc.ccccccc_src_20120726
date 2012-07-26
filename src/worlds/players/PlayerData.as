package worlds.players
{
	import game.net.data.StoC.SCAvatarInfo.PlayerAvatar;
	import game.net.data.StoC.SCAvatarInfoChange;
	import game.net.data.StoC.SCMultiAvatarInfoChange;
	import game.net.data.StoC.SCMultiAvatarInfoChange.AvatarInfoChange;
	import game.net.data.StoC.SCPlayerWalk;
	import game.net.data.StoC.SCTransport;

	import worlds.WorldStartup;
	import worlds.mediators.PlayerMediator;
	import worlds.mediators.SelfMediator;
	import worlds.roles.structs.PlayerStruct;

	import com.utils.PotentialColorUtils;

	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-23
	 */
	public class PlayerData
	{
		/** 单例对像 */
		private static var _instance : PlayerData;

		/** 获取单例对像 */
		static public function get instance() : PlayerData
		{
			if (_instance == null)
			{
				_instance = new PlayerData(new Singleton());
			}
			return _instance;
		}

		function PlayerData(singleton : Singleton) : void
		{
			singleton;
			selfId = WorldStartup.userId;
			PlayerMediator.selfInstalled.add(setSelfInstalled);
			PlayerMediator.playerInstalled.add(setPlayerInstalled);
			PlayerMediator.getStruct.register(getPlayer);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var selfId : int;
		private var _self : PlayerStruct;
		private var _selfInstalled : Boolean;
		public var dic : Dictionary = new Dictionary();
		public var waitInstallDic : Dictionary = new Dictionary();
		public var waitInstallInfoNewestList : Vector.<PlayerStruct> = new Vector.<PlayerStruct>();
		private var modelIn : ModelIn = ModelIn.instance;
		private var modelChange : ModelChange = ModelChange.instance;
		private var keyArr : Array = [];
		private var globalPlayers : GlobalPlayers = GlobalPlayers.instance;

		public function clear() : void
		{
			_self = null;
			_selfInstalled = false;
			var key : String;
			// 全部
			for (key  in dic)
			{
				keyArr.push(key);
			}

			while (keyArr.length > 0)
			{
				key = keyArr.pop();
				dic[key] = null;
				delete dic[key];
			}
			// 等待安装
			for (key  in waitInstallDic)
			{
				keyArr.push(key);
			}

			while (keyArr.length > 0)
			{
				key = keyArr.pop();
				waitInstallDic[key] = null;
				delete waitInstallDic[key];
			}
			// 等待安装信息最新的
			while (waitInstallInfoNewestList.length > 0)
			{
				waitInstallInfoNewestList.pop();
			}
		}

		// =====================
		// 自己玩家
		// =====================
		public function get hasSelf() : Boolean
		{
			return _self != null;
		}

		public function get selfInfoNewest() : Boolean
		{
			return _self.isNewestAvatar;
		}

		public function get selfInstalled() : Boolean
		{
			return _selfInstalled;
		}

		public function setSelfInstalled() : void
		{
			_selfInstalled = true;
			modelIn.execute(selfId, self.modelId);
		}

		public function get self() : PlayerStruct
		{
			return _self;
		}

		public function set self(playerStruct : PlayerStruct) : void
		{
			_self = playerStruct;
			selfId = playerStruct.id;
			dispatchSelfWaitInstall();
		}

		public function dispatchSelfWaitInstall() : void
		{
			if (selfInfoNewest && selfInstalled == false)
			{
				PlayerMediator.selfWaitInstall.dispatch();
			}
		}

		// ========================
		// 其他玩家
		// ========================
		public function getPlayer(playerId : int) : PlayerStruct
		{
			if (playerId == selfId) return self;
			return dic[playerId];
		}

		private function isInstalled(playerId : int) : Boolean
		{
			if (playerId == selfId) return _selfInstalled;
			return dic[playerId] && !waitInstallDic[playerId];
		}

		public function addWaitInstall(playerStruct : PlayerStruct) : void
		{
			if (playerStruct == null || playerStruct.id == selfId) return;
			dic[playerStruct.id] = playerStruct;
			waitInstallDic[playerStruct.id] = playerStruct;
			setWaitInstallPlayerNewest(playerStruct);
		}

		public function setPlayerInstalled(playerId : int) : void
		{
			var playerStruct : PlayerStruct = getPlayer(playerId);
			if (playerStruct == null || playerStruct.id == selfId) return;
			delete waitInstallDic[playerStruct.id];
			var index : int = waitInstallInfoNewestList.indexOf(playerStruct);
			if (index != -1)
			{
				waitInstallInfoNewestList.splice(index, 1);
			}
			modelIn.execute(playerId, playerStruct.modelId);
		}

		private function setWaitInstallPlayerNewest(playerStruct : PlayerStruct) : void
		{
//			trace("setWaitInstallPlayerNewest  isNewestAvatar=" + playerStruct.isNewestAvatar + " isInstalled=" + isInstalled(playerStruct.id) + " waitInstallInfoNewestList.length=" + waitInstallInfoNewestList.length);
			if (playerStruct.isNewestAvatar == false) return;
			if (isInstalled(playerStruct.id)) return;
			var index : int = waitInstallInfoNewestList.indexOf(playerStruct);
			if (index == -1)
			{
				waitInstallInfoNewestList.push(playerStruct);
			}
			PlayerMediator.playerWaitInstalled.dispatch(playerStruct);
		}

		public function playerLeave(playerId : int) : void
		{
			var playerStruct : PlayerStruct = getPlayer(playerId);
			if (playerStruct == null || playerStruct.id == selfId) return;
			if (isInstalled(playerId))
			{
				PlayerMediator.playerLeave.dispatch(playerId);
				delete dic[playerId];
				return;
			}
			delete dic[playerId];
			delete waitInstallDic[playerId];
			var index : int = waitInstallInfoNewestList.indexOf(playerStruct);
			if (index != -1)
			{
				waitInstallInfoNewestList.splice(index, 1);
			}
		}

		public function sc_playerAvatarInfoInit(msg : PlayerAvatar) : void
		{
			var playerStruct : PlayerStruct = globalPlayers.getPlayer(msg.id);
			if (!playerStruct) return;
			playerStruct.name = msg.name;
			playerStruct.potential = msg.job >> 4;
			playerStruct.heroId = msg.job & 0xF;
			playerStruct.level = msg.level;
			playerStruct.rideId = msg.cloth >> 14;
			playerStruct.clothId = msg.cloth - (playerStruct.rideId << 14);
			playerStruct.avatarVer = msg.avatarVer;
			playerStruct.newAvatarVer = msg.avatarVer;
			playerStruct.color = PotentialColorUtils.getColor(playerStruct.potential);
			playerStruct.colorStr = PotentialColorUtils.getColorOfStr(playerStruct.potential);

			playerStruct = getPlayer(msg.id);
			if (!playerStruct) return;
			if (playerStruct.id != selfId)
			{
				setWaitInstallPlayerNewest(playerStruct);
			}
			else
			{
				dispatchSelfWaitInstall();
			}
		}

		public function sc_playerAvatarInfoChange(msg : SCAvatarInfoChange) : void
		{
			var playerStruct : PlayerStruct = getPlayer(msg.id);
			if (playerStruct == null)
			{
				playerStruct = globalPlayers.getPlayer(msg.id);
				if(playerStruct == null) return;
				if (msg.hasLevel) playerStruct.level = msg.level;
				if (msg.hasCloth)
				{
					playerStruct.rideId = msg.cloth >> 14;
					playerStruct.clothId = msg.cloth - (playerStruct.rideId << 14);
				}
				playerStruct.newAvatarVer = msg.avatarVer & 0x1F;
				playerStruct.modelId = msg.avatarVer >> 5;
				return;
			}
			var preRideId : int = playerStruct.rideId;
			var preClothId : int = playerStruct.clothId;
			var preModelId : int = playerStruct.modelId;
			if (msg.hasLevel) playerStruct.level = msg.level;
			if (msg.hasCloth)
			{
				playerStruct.rideId = msg.cloth >> 14;
				playerStruct.clothId = msg.cloth - (playerStruct.rideId << 14);
			}
			playerStruct.modelId = msg.avatarVer >> 5;
			playerStruct.newAvatarVer =msg.avatarVer & 0x1F;
			if(playerStruct.hasBaseInfo) playerStruct.avatarVer = playerStruct.newAvatarVer;
			if (playerStruct.modelId > 1 && playerStruct.modelId <= 8 )
			{
				playerStruct.speed = playerStruct.modelId < 5 ? 0.8 : 15;
			}
			else
			{
				playerStruct.speed = 4;
			}

			if (isInstalled(playerStruct.id))
			{
				var playerId : int = playerStruct.id;
				if (preClothId != playerStruct.clothId)
				{
					PlayerMediator.changeCloth.dispatch(playerId, playerStruct.clothId);
					if (playerStruct.id == selfId) SelfMediator.sChangeCloth.dispatch(playerStruct.clothId);
				}

				if (preRideId != playerStruct.rideId)
				{
					PlayerMediator.changeRide.dispatch(playerId, playerStruct.rideId);
					if (playerStruct.id == selfId) SelfMediator.sChangeRide.dispatch(playerStruct.rideId);
				}
				modelChange.execute(playerId, playerStruct.modelId, preModelId);
			}
		}

		public function sc_multipleAvatarInfoChange(msg : SCMultiAvatarInfoChange) : void
		{
			// <<<<<<< HEAD
			for each ( var inf:AvatarInfoChange in msg.changes )
			{
				var playerStruct : PlayerStruct = getPlayer(inf.id);
				if (playerStruct == null) return;

				var preRideId : int = playerStruct.rideId;
				var preClothId : int = playerStruct.clothId;
				var preModelId : int = playerStruct.modelId;
				if (inf.hasLevel) playerStruct.level = inf.level;
				if (inf.hasCloth)
				{
					playerStruct.rideId = inf.cloth >> 14;
					playerStruct.clothId = inf.cloth - (playerStruct.rideId << 14);
				}
				
				playerStruct.newAvatarVer = inf.avatarVer & 0x1F;
				if(playerStruct.hasBaseInfo) playerStruct.avatarVer = playerStruct.newAvatarVer ;
				playerStruct.modelId = inf.avatarVer >> 5;

				if (isInstalled(playerStruct.id))
				{
					var playerId : int = playerStruct.id;
					if (preClothId != playerStruct.clothId)
					{
						PlayerMediator.changeCloth.dispatch(playerId, playerStruct.clothId);
						if (playerStruct.id == selfId) SelfMediator.sChangeCloth.dispatch(playerStruct.clothId);
					}

					if (preRideId != playerStruct.rideId)
					{
						PlayerMediator.changeRide.dispatch(playerId, playerStruct.rideId);
						if (playerStruct.id == selfId) SelfMediator.sChangeRide.dispatch(playerStruct.rideId);
					}
					modelChange.execute(playerId, playerStruct.modelId, preModelId);
				}
				// =======
				// var playerStruct : PlayerStruct;
				// for each (var avatarInfo:AvatarInfoChange in msg.changes)
				// {
				// playerStruct = getPlayer(avatarInfo.id);
				// if (playerStruct == null) continue;
				//
				// playerStruct.newAvatarVer = avatarInfo.avatarVer & 0x1F;
				// playerStruct.modelId = avatarInfo.avatarVer >> 5;
				// >>>>>>> b7ab0dcef4bb9c7d673427a865bdca5a3c8e62be
			}
		}

		public function sc_playerWalk(msg : SCPlayerWalk) : void
		{
			var playerStruct : PlayerStruct = getPlayer(msg.playerId);
			if (playerStruct == null) return;
			var isInstall : Boolean = isInstalled(playerStruct.id);
			if (isInstall)
			{
				playerStruct.walking = true;
				playerStruct.walkTime = 0;
				playerStruct.walktimeStart = getTimer();
				playerStruct.toX = msg.xy & 0x3FFF;
				playerStruct.toY = msg.xy >> 14;
				if (msg.hasFromXY)
				{
					playerStruct.fromX = msg.fromXY & 0x3FFF;
					playerStruct.fromY = msg.fromXY >> 14;
				}
				PlayerMediator.walkTo.dispatch(playerStruct.id, playerStruct.toX, playerStruct.toY, msg.hasFromXY, playerStruct.fromX, playerStruct.fromY);
			}
			else
			{
				playerStruct.walking = true;
				playerStruct.walkTime = 0;
				playerStruct.walktimeStart = getTimer();
				if (!msg.hasFromXY)
				{
					if (playerStruct.toX)
					{
						playerStruct.fromX = playerStruct.toX;
						playerStruct.fromY = playerStruct.toY;
					}
					else
					{
						playerStruct.fromX = playerStruct.x;
						playerStruct.fromY = playerStruct.y;
					}
				}
				playerStruct.toX = msg.xy & 0x3FFF;
				playerStruct.toY = msg.xy >> 14;
				if (msg.hasFromXY)
				{
					playerStruct.fromX = msg.fromXY & 0x3FFF;
					playerStruct.fromY = msg.fromXY >> 14;
				}
				playerStruct.x = playerStruct.fromX;
				playerStruct.y = playerStruct.fromY;
			}
		}

		public function sc_playerTransport(msg : SCTransport) : void
		{
			var playerStruct : PlayerStruct;
			playerStruct = getPlayer(msg.playerId);
			if (playerStruct == null) return;
			playerStruct.walking = false;
			playerStruct.walkTime = 0;
			playerStruct.x = msg.myXy & 0x3FFF;
			playerStruct.y = msg.myXy >> 14;

			if (isInstalled(playerStruct.id))
			{
				PlayerMediator.transportTo.dispatch(playerStruct.id, playerStruct.x, playerStruct.y);
			}
		}

		public function hidePlayer(playerId : int) : void
		{
			var playerStruct : PlayerStruct = getPlayer(playerId);
			if (playerStruct)
			{
				waitInstallDic[playerStruct.id] = playerStruct;
				if (waitInstallInfoNewestList.indexOf(playerStruct) == -1) waitInstallInfoNewestList.push(playerStruct);
			}
		}

		public function leaveMap() : void
		{
			var keyArr : Array = [];
			var key : *;
			// 全部
			for (key  in dic)
			{
				keyArr.push(key);
			}

			while (keyArr.length > 0)
			{
				playerLeave(keyArr.shift());
			}
		}
	}
}
class Singleton
{
}