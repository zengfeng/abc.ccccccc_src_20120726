package worlds
{
	import worlds.auxiliarys.MapMath;
	import worlds.players.RequestAvatarInfoChange;
	import worlds.players.RequestAvatarInfoInit;

	import game.manager.RSSManager;

	import flash.geom.Point;
	import flash.utils.getTimer;

	import game.net.core.Common;
	import game.net.data.CtoS.CSAvatarChange;
	import game.net.data.CtoS.CSAvatarInfo;
	import game.net.data.CtoS.CSLeaveCity;
	import game.net.data.CtoS.CSSwitchCity;
	import game.net.data.CtoS.CSTransport;
	import game.net.data.CtoS.CSUseGate;
	import game.net.data.CtoS.CSWalkTo;
	import game.net.data.StoC.PlayerPosition;
	import game.net.data.StoC.SCAvatarInfo;
	import game.net.data.StoC.SCAvatarInfo.PlayerAvatar;
	import game.net.data.StoC.SCAvatarInfoChange;
	import game.net.data.StoC.SCBarrier;
	import game.net.data.StoC.SCCityEnter;
	import game.net.data.StoC.SCCityLeave;
	import game.net.data.StoC.SCCityPlayers;
	import game.net.data.StoC.SCMultiAvatarInfoChange;
	import game.net.data.StoC.SCNPCReaction;
	import game.net.data.StoC.SCPlayerWalk;
	import game.net.data.StoC.SCTransport;

	import worlds.apis.BarrierOpened;
	import worlds.apis.GateOpened;
	import worlds.apis.MWorldInfo;
	import worlds.apis.MapUtil;
	import worlds.apis.ModelId;
	import worlds.mediators.MapMediator;
	import worlds.mediators.SelfMediator;
	import worlds.npcs.NpcData;
	import worlds.players.GlobalPlayers;
	import worlds.players.ModelOut;
	import worlds.players.PlayerData;
	import worlds.roles.structs.PlayerStruct;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-21
	 */
	public class WorldProto
	{
		/** 单例对像 */
		private static var _instance : WorldProto;

		/** 获取单例对像 */
		static public function get instance() : WorldProto
		{
			if (_instance == null)
			{
				_instance = new WorldProto(new Singleton());
			}
			return _instance;
		}

		public function WorldProto(singleton : Singleton)
		{
			singleton;
			globalPlayers = GlobalPlayers.instance;
			playerData = PlayerData.instance;
			npcData = NpcData.instance;
			requestAvatarInfoInit = RequestAvatarInfoInit.instance;
			requestAvatarInfoChange = RequestAvatarInfoChange.instance;
			MapMediator.csLeaveMap.register(cs_leaveMap);
			MapMediator.csChangeMap.register(cs_changeMap);
			MapMediator.csTransport.register(cs_transport);
			MapMediator.csLeaveMap.register(cs_leaveMap);
			MapMediator.csUseGateChangeMap.register(cs_useGateChangeMap);
			SelfMediator.csWalkTurn.add(cs_moveTo);
			sToC();
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var globalPlayers : GlobalPlayers;
		private var playerData : PlayerData;
		private var npcData : NpcData;
		private var requestAvatarInfoInit : RequestAvatarInfoInit;
		private var requestAvatarInfoChange : RequestAvatarInfoChange;

		/** 协议监听 */
		private function sToC() : void
		{
			// 0x20 玩家走路
			Common.game_server.addCallback(0x20, sc_playerWalk);
			// 0x21 玩家进入地图（非自己）
			Common.game_server.addCallback(0x21, sc_playerEnter);
			// 0x22 自己玩家进入新地图
			Common.game_server.addCallback(0x22, sc_changeMap);
			// 0x23 玩家离开
			Common.game_server.addCallback(0x23, sc_playerLeave);
			// 0x24 设置NPC是否显示
			Common.game_server.addCallback(0x24, sc_setNpcVisible);
			// 0x25  直接传送
			Common.game_server.addCallback(0x25, sc_transport);
			// 0x26  一组多个玩家Avatar信息
			Common.game_server.addCallback(0x26, sc_multipleAvatarChange);
			// 0x27 玩家avatar信息改变
			Common.game_server.addCallback(0x27, sc_playerAvatarInfoChange);
			// 0x28 玩家Avatar信息
			Common.game_server.addCallback(0x28, sc_playerAvatarInfo);
			// 0x2A  开放/关闭路障/传送点
			Common.game_server.addCallback(0x2A, sc_barrier);
		}

		// ======================
		// 接收
		// ======================
		/** 0x20 玩家走路 */
		public function sc_playerWalk(msg : SCPlayerWalk) : void
		{
			playerData.sc_playerWalk(msg);
		}

		/** 0x21 玩家进入地图（非自己） */
		public function sc_playerEnter(msg : SCCityEnter) : void
		{
			var positionInfo : PlayerPosition = msg.playerPos;
			var playerStruct : PlayerStruct;
			playerStruct = globalPlayers.getPlayer(positionInfo.playerId);
			if (playerStruct == null)
			{
				playerStruct = new PlayerStruct();
				playerStruct.id = positionInfo.playerId;
				globalPlayers.addPlayer(playerStruct);
			}
			playerStruct.x = positionInfo.xy & 0x3FFF;
			playerStruct.y = positionInfo.xy >> 14;
			if (positionInfo.hasToXy)
			{
				playerStruct.toX = positionInfo.toXy & 0x3FFF;
				playerStruct.toY = positionInfo.toXy >> 14;
			}

			if (positionInfo.hasWhen)
			{
				playerStruct.walking = true;
				playerStruct.walkTime = positionInfo.when;
				playerStruct.walktimeStart = getTimer() - playerStruct.walkTime;
				playerStruct.fromX = playerStruct.x;
				playerStruct.fromY = playerStruct.y;
			}
			else
			{
				playerStruct.walking = false;
				playerStruct.walkTime = 0;
			}
			playerStruct.newAvatarVer = positionInfo.avatarVer & 0x1F;
			playerStruct.modelId = positionInfo.avatarVer >> 5;
			playerStruct.speed = 4;

			if (!playerStruct.hasBaseInfo)
			{
				if (!playerStruct.isAvatarInitRequested)
				{
					requestAvatarInfoInit.add(playerStruct.id);
					requestAvatarInfoInit.startTime();
				}
			}
			else if (!playerStruct.isNewestAvatar)
			{
				if (!playerStruct.isNewestAvatarRequested)
				{
					requestAvatarInfoChange.add(playerStruct.id);
					requestAvatarInfoChange.startTime();
				}
			}

			playerData.addWaitInstall(playerStruct);
		}

		private var cache_changeMap_msg : SCCityPlayers;
		private var cache_changeMap_hasSelf : Boolean;

		/** 0x22 自己玩家进入新地图 */
		public function sc_changeMap(msg : SCCityPlayers, hasSelf : Boolean = true, fromServe : Boolean = true) : void
		{
//			msg.cityId = 5;
			if (fromServe)
			{
				if (MapUtil.isGroupBattleMap(msg.cityId))
				{
					return;
				}
			}

			if (WorldStartup.isInit)
			{
				sc_changeMapExe(msg, hasSelf);
			}
			else
			{
				cache_changeMap_msg = msg;
				cache_changeMap_hasSelf = hasSelf;
				WorldStartup.initFun = sc_changeMap_loginLoadCompleteCall;
			}
		}

		private function sc_changeMap_loginLoadCompleteCall() : void
		{
			sc_changeMapExe(cache_changeMap_msg, cache_changeMap_hasSelf);
			RSSManager.getInstance().loginLoadCompleteCall = null;
		}

		/** 0x22 自己玩家进入新地图 */
		private function sc_changeMapExe(msg : SCCityPlayers, hasSelf : Boolean = true) : void
		{
			SelfMediator.cWalkStop.call();
			MWorldInfo.changeMapTime = getTimer();
			playerData.leaveMap();
			MapMediator.pauseInstall.dispatch();
			playerData.clear();
			npcData.clear();
			GateOpened.clear();
			BarrierOpened.clear();
			requestAvatarInfoInit.clear();
			var i : int;
			var length : int = msg.openBarriers.length;
			for (i = 0; i < length; i++)
			{
				var barriersId : int = msg.openBarriers[i];
				if (barriersId > 100)
				{
					GateOpened.setState(barriersId - 100, true);
				}
				else
				{
					BarrierOpened.setState(barriersId, true);
				}
			}

			// 地图加入NPC
			while (msg.npcId.length > 0)
			{
				npcData.add(msg.npcId.shift());
			}

			if (hasSelf)
			{
				// 自己玩家
				var selfPlayerStruct : PlayerStruct = globalPlayers.self;
				ModelOut.instance.execute(selfPlayerStruct.id, selfPlayerStruct.modelId);
				selfPlayerStruct.x = msg.myX;
				selfPlayerStruct.y = msg.myY;
				selfPlayerStruct.modelId = msg.model;
				selfPlayerStruct.rideId = msg.cloth >> 14;
				selfPlayerStruct.clothId = msg.cloth - (selfPlayerStruct.rideId << 14);
				playerData.self = selfPlayerStruct;
			}

			// 玩家列表
			var playerStruct : PlayerStruct;
			for (i = 0; i < msg.players.length; i++)
			{
				var positionInfo : PlayerPosition = msg.players[i];
				playerStruct = globalPlayers.getPlayer(positionInfo.playerId);
				if (playerStruct == null)
				{
					playerStruct = new PlayerStruct();
					playerStruct.id = positionInfo.playerId;
					globalPlayers.addPlayer(playerStruct);
				}
				playerStruct.x = positionInfo.xy & 0x3FFF;
				playerStruct.y = positionInfo.xy >> 14;
				if (positionInfo.hasToXy)
				{
					playerStruct.toX = positionInfo.toXy & 0x3FFF;
					playerStruct.toY = positionInfo.toXy >> 14;
				}

				if (positionInfo.hasWhen)
				{
					playerStruct.walking = true;
					playerStruct.walkTime = positionInfo.when;
					playerStruct.walktimeStart = getTimer() - playerStruct.walkTime;
					playerStruct.fromX = playerStruct.x;
					playerStruct.fromY = playerStruct.y;
				}
				else
				{
					playerStruct.walking = false;
					playerStruct.walkTime = 0;
					playerStruct.walktimeStart = getTimer();
				}

				playerStruct.newAvatarVer = positionInfo.avatarVer & 0x1F;
				playerStruct.modelId = positionInfo.avatarVer >> 5;
				if (!playerStruct.hasBaseInfo)
				{
					// trace("playerStruct.hasBaseInfo " + playerStruct.id);
					if (!playerStruct.isAvatarInitRequested)
					{
						// trace("requestAvatarInfoInit.add " + playerStruct.id);
						requestAvatarInfoInit.add(playerStruct.id);
					}
				}
				else if (!playerStruct.isNewestAvatar)
				{
					// trace("playerStruct.isNewestAvatar " + playerStruct.id);
					if (!playerStruct.isNewestAvatarRequested)
					{
						// trace("playerStruct.isNewestAvatarRequested " + playerStruct.id);
						requestAvatarInfoChange.add(playerStruct.id);
					}
				}

				playerData.addWaitInstall(playerStruct);

				if (ModelId.isConvory(playerStruct.modelId) )
				{
					playerStruct.speed = playerStruct.modelId < 5 ? 0.8 : 15;
				}
				else
				{
					playerStruct.speed = 4;
				}
			}
			
			/*
			for (i = 1; i < 300; i++)
			{
				playerStruct = new PlayerStruct();
				playerStruct.id = i;
				playerStruct.name = "玩家_" + i;
				playerStruct.avatarVer = 1;
				playerStruct.newAvatarVer = 1;
				playerStruct.clothId = MapMath.randomInt(3, 0);
				playerStruct.heroId = MapMath.randomInt(6, 1);
				playerStruct.setPotential(selfPlayerStruct.potential);
				playerStruct.x = selfPlayerStruct.x + MapMath.randomPlusMinus(1500);
				playerStruct.y = selfPlayerStruct.y + MapMath.randomPlusMinus(1500);
				playerStruct.walking = true;
				playerStruct.walktimeStart = getTimer();
				playerStruct.fromX = playerStruct.x + MapMath.randomPlusMinus(600);
				playerStruct.fromY = playerStruct.y + MapMath.randomPlusMinus(500);
				playerStruct.toX = playerStruct.x + MapMath.randomPlusMinus(600);
				playerStruct.toY = playerStruct.y + MapMath.randomPlusMinus(600);
				globalPlayers.addPlayer(playerStruct);
				playerData.addWaitInstall(playerStruct);
			}
			 */
			MapMediator.sInstall.dispatch(msg.cityId, msg.myX, msg.myY);
		}

		/**0x23 玩家离开 */
		public function sc_playerLeave(msg : SCCityLeave) : void
		{
			requestAvatarInfoInit.remove(msg.playerId);
			requestAvatarInfoChange.remove(msg.playerId);
			playerData.playerLeave(msg.playerId);
		}

		/** 0x24 设置NPC是否显示 */
		public function sc_setNpcVisible(msg : SCNPCReaction) : void
		{
			if (msg.reactionId == 1)
			{
				npcData.add(msg.npcId);
			}
			else
			{
				npcData.remove(msg.npcId);
			}
		}

		/** 0x25 传送 */
		public function sc_transport(msg : SCTransport) : void
		{
			playerData.sc_playerTransport(msg);
		}

		/** 0x26  一组多个玩家Avatar信息 */
		public function sc_multipleAvatarChange(msg : SCMultiAvatarInfoChange) : void
		{
			playerData.sc_multipleAvatarInfoChange(msg);
		}

		/** 0x27 玩家avatar信息改变 */
		public function sc_playerAvatarInfoChange(msg : SCAvatarInfoChange) : void
		{
			// trace("sc_playerAvatarInfoChange  playerId=" + msg.id);
			playerData.sc_playerAvatarInfoChange(msg);
		}

		/** 0x28 玩家Avatar信息 */
		public function sc_playerAvatarInfo(msg : SCAvatarInfo) : void
		{
			// trace("initMsg length",msg.players.length);
			for (var i : int = 0; i < msg.players.length; i++)
			{
				var avatarInfo : PlayerAvatar = msg.players[i];
				playerData.sc_playerAvatarInfoInit(avatarInfo);
			}
		}

		/** 协议监听 --  0x2A  开放/关闭路障/传送点 */
		private function sc_barrier(msg : SCBarrier) : void
		{
			if (msg.barrierID > 100 )
			{
				GateOpened.setState(msg.barrierID - 100, msg.open);
			}
			else
			{
				BarrierOpened.setState(msg.barrierID, msg.open);
			}
		}

		// ======================
		// 发送
		// ======================
		/** 0x20 告诉其他玩家自己位置 */
		public function cs_moveTo(toX : int, toY : int, fromX : int = 0, fromY : int = 0) : void
		{
			var msg : CSWalkTo = new CSWalkTo();
			msg.toX = toX;
			msg.toY = toY;
			if (fromX != 0)
			{
				msg.fromX = fromX;
				msg.fromY = fromY;
			}
			Common.game_server.sendMessage(0x20, msg);
		}

		/** 0x22 使用传送点 */
		public function cs_useGateChangeMap(gateId : int) : void
		{
			MapMediator.sChangeMapStart.dispatch();
			SelfMediator.cWalkStop.call();
			var msg : CSUseGate = new CSUseGate();
			msg.gateId = gateId;
			Common.game_server.sendMessage(0x22, msg);
		}

		/** 0x23 离开地图 */
		public function cs_leaveMap() : void
		{
			MapMediator.sChangeMapStart.dispatch();
			SelfMediator.cWalkStop.call();
			var msg : CSLeaveCity = new CSLeaveCity();
			Common.game_server.sendMessage(0x23, msg);
		}

		/** 0x24 切换地图 */
		public function cs_changeMap(mapId : uint) : void
		{
			MapMediator.sChangeMapStart.dispatch();
			SelfMediator.cWalkStop.call();
			var msg : CSSwitchCity = new CSSwitchCity();
			msg.cityId = mapId;
			Common.game_server.sendMessage(0x24, msg);
		}

		/** 0x25 直接传送 */
		public function cs_transport(toX : int, toY : int, mapId : int = 0) : void
		{
			SelfMediator.cWalkStop.call();
			var msg : CSTransport = new CSTransport();
			msg.cityId = mapId <= 0 ? MapUtil.currentMapId : mapId;
			msg.toX = toX;
			msg.toY = toY;
			if (toX == 0 && toY == 0)
			{
				var point : Point = MapUtil.getGateStandPosition(mapId, mapId);
				msg.toX = point.x;
				msg.toY = point.y;
			}
			Common.game_server.sendMessage(0x25, msg);
		}

		/** 0x27 请求Avatar改变信息 */
		public function cs_avatarInfoChange(playerId : int, playerIdList : Array = null) : void
		{
			var msg : CSAvatarChange = new CSAvatarChange();
			if (playerId > 0) msg.playerId.push(playerId);
			if (playerIdList && playerIdList.length > 0)
			{
				while (playerIdList.length > 0)
				{
					playerId = playerIdList.shift();
					if (msg.playerId.indexOf(playerId) == -1)
					{
						msg.playerId.push(playerId);
					}
				}
			}
			if (msg.playerId.length <= 0) return;
			Common.game_server.sendMessage(0x27, msg);
		}

		/** 0x28 请求名字模型等信息 */
		public function cs_avatarInfo(playerId : int, playerIdList : Array = null) : void
		{
			var msg : CSAvatarInfo = new CSAvatarInfo();
			if (playerId > 0) msg.playerId.push(playerId);
			if (playerIdList && playerIdList.length > 0)
			{
				while (playerIdList.length > 0)
				{
					playerId = playerIdList.shift();
					if (msg.playerId.indexOf(playerId) == -1)
					{
						msg.playerId.push(playerId);
					}
				}
			}
			if (msg.playerId.length <= 0) return;
			Common.game_server.sendMessage(0x28, msg);
		}
	}
}
class Singleton
{
}