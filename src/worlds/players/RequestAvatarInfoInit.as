package worlds.players
{
	import worlds.roles.structs.PlayerStruct;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import game.net.core.Common;
	import game.net.data.CtoS.CSAvatarInfo;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-19
	 */
	public class RequestAvatarInfoInit
	{
		/** 单例对像 */
		private static var _instance : RequestAvatarInfoInit;

		/** 获取单例对像 */
		static public function get instance() : RequestAvatarInfoInit
		{
			if (_instance == null)
			{
				_instance = new RequestAvatarInfoInit(new Singleton());
			}
			return _instance;
		}

		function RequestAvatarInfoInit(singleton : Singleton) : void
		{
			singleton;
		}

		private var globalPlayers : GlobalPlayers = GlobalPlayers.instance;
		private var list : Vector.<uint> = new Vector.<uint>();
		private var ONCE_NUM : int = 90;

		public function add(playerId : int) : void
		{
			list.push(playerId);
		}

		public function remove(playerId : int) : void
		{
			var index : int = list.indexOf(playerId);
			if (index != -1)
			{
				list.splice(index, 1);
			}
		}

		public function clear() : void
		{
			stopTime();
			while (list.length > 0)
			{
				list.shift();
			}
		}

		public function request() : void
		{
			stopTime();
			var msg : CSAvatarInfo = new CSAvatarInfo();
			var playerList : Vector.<uint>= msg.playerId;
			var listLength : int = list.length;
			var playerId : int;
			var playerStruct : PlayerStruct;
			if (listLength <= ONCE_NUM)
			{
				while (list.length > 0)
				{
					playerId = list.shift();
					if (playerList.indexOf(playerId) == -1)
					{
						playerStruct = globalPlayers.getPlayer(playerId);
						if (playerStruct)
						{
							playerStruct.isAvatarInitRequested = true;
							playerStruct.requestedAvatarVer = playerStruct.newAvatarVer;
							playerList.push(playerId);
//							trace("initRequest",playerId);
						}
					}
				}
			}
			else
			{
				var num : int = 0;
				while (num < ONCE_NUM)
				{
					num++;
					playerId = list.shift();
					if (playerList.indexOf(playerId) == -1)
					{
						playerStruct = globalPlayers.getPlayer(playerId);
						if (playerStruct)
						{
							playerStruct.isAvatarInitRequested = true;
							playerStruct.requestedAvatarVer = playerStruct.newAvatarVer;
							playerList.push(playerId);
//							trace("initRequest",playerId);
						}
					}
				}
			}

			if (playerList.length == 0) return;
//			trace("initRequest length",playerList.length);
			Common.game_server.sendMessage(0x28, msg);
			startTime();
		}

		private var timer : uint = 0;
		private var isStartTime : Boolean = false;

		public function startTime() : void
		{
			if (list.length > 0)
			{
				if (isStartTime) return;
				timer = setTimeout(request, 100);
				isStartTime = true;
			}
		}

		public function stopTime() : void
		{
			clearTimeout(timer);
			isStartTime = false;
		}
	}
}
class Singleton
{
}