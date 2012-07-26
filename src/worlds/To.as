package worlds {
	import worlds.apis.MSelfPlayer;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.auxiliarys.MapMath;
	import worlds.auxiliarys.MapPoint;
	import worlds.auxiliarys.mediators.DelayCall;
	import worlds.maps.configs.structs.GateStruct;
	import worlds.mediators.MapMediator;
	import worlds.mediators.NpcMediator;
	import worlds.mediators.SelfMediator;
	import worlds.mediators.ToMediator;
	import worlds.roles.structs.NpcStruct;

	import com.commUI.alert.Alert;

	import flash.geom.Point;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-7
	 */
	public class To
	{
		/** 单例对像 */
		private static var _instance : To;

		/** 获取单例对像 */
		public static  function get instance() : To
		{
			if (_instance == null)
			{
				_instance = new To(new Singleton());
			}
			return _instance;
		}

		function To(singleton : Singleton) : void
		{
			singleton;
			ToMediator.clear.register(clear);
			ToMediator.toPoint.register(toPoint);
			ToMediator.toNpc.register(toNpc);
			ToMediator.toGate.register(toGate);
			ToMediator.toMap.register(toMap);
			ToMediator.toDuplNpc.register(toDupMap);
			ToMediator.transportTo.register(transportTo);
			ToMediator.toExitGate.register(toExitGate);

		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var employ : Boolean;
		private var direction : Boolean;
		private var directionX : int;
		private var directionY : int;
		private var toX : int;
		private var toY : int;
		private var toMapId : int;
		private var radius : int;
		private var flashStep : Boolean;
		private var callFun : Function;
		private var callFunArgs : Array;
		private var checkArriveNum : int = 0;
		private var checkArriveStrict : Boolean = false;

		/** 清理 */
		private function clear() : void
		{
			direction = false;
			employ = false;
			directionX = NaN;
			directionY = NaN;
			toX = NaN;
			toY = NaN;
			toMapId = NaN;
			radius = NaN;
			flashStep = false;
			callFun = null;
			callFunArgs = null;
			checkArriveNum = 0;

			MSelfPlayer.autoWalk = false;
			MapMediator.sMouseWalk.remove(mouseWalkTo);
			MapMediator.sInstallComplete.remove(checkArrive);
			SelfMediator.sWalkEnd.remove(checkArrive);
			SelfMediator.sTransport.remove(checkArrive);
			MapMediator.sInstallComplete.remove(delayCallToNpcHandler);
			MapMediator.sInstallComplete.remove(delayCallToMapHandler);
			MapMediator.sInstallComplete.remove(delayCallToDupMapHandler);
		}

		/** 到达 */
		private function arrive() : void
		{
			MapMediator.sMouseWalk.remove(mouseWalkTo);
			MapMediator.sInstallComplete.remove(checkArrive);
			SelfMediator.sWalkEnd.remove(checkArrive);
			SelfMediator.sTransport.remove(checkArrive);
			if (direction)
			{
				if (directionX)
				{
					SelfMediator.cStandDirection.call(directionX, directionY);
				}
			}

			SelfMediator.cWalkStop.call();
			if (callFun != null) callFun.apply(null, callFunArgs);
			clear();
		}

		/** 验证是否到达 */
		private function checkArrive() : void
		{
			if (employ == false) return;
			checkArriveNum++;
			if (checkArriveNum > 10)
			{
				if (checkArriveStrict)
				{
					clear();
					throw new Error("您设置的位置可能是不可到达的地方");
				}
				else
				{
					arrive();
				}
				return;
			}

			if (MapUtil.isCurrentMapId(toMapId))
			{
				var mapPoint : MapPoint = SelfMediator.cbPosition.call();
				var distance : Number = MapMath.distance(mapPoint.x, mapPoint.y, toX, toY);
				trace("distance :" + distance);
				if (distance <= radius)
				{
					arrive();
					return;
				}
				else if (flashStep)
				{
					addSignals();
					sendTransportTo();
				}
				else
				{
					addSignals();
					walkTo();
				}
			}
			else if (flashStep)
			{
				addSignals();
				sendTransportTo();
			}
			else
			{
				addSignals();
				worldMapTo();
			}
		}

		private function addSignals() : void
		{
			MapMediator.sMouseWalk.add(mouseWalkTo);
			MapMediator.sInstallComplete.add(checkArrive);
		}

		private function mouseWalkTo(toX : int, toY : int) : void
		{
			toX;
			toY;
			clear();
		}

		private function walkTo() : void
		{
			SelfMediator.sWalkEnd.add(checkArrive);
			SelfMediator.cWalkPathTo.call(toX, toY);
			MSelfPlayer.autoWalk = true;
		}

		private function sendTransportTo() : void
		{
			SelfMediator.sTransport.add(checkArrive);
			MapMediator.csTransport.call(toX, toY, toMapId);
		}

		private function worldMapTo() : void
		{
			MWorld.worldMapTo(toMapId);
		}

		// ==========================
		// 开放操作
		// ==========================
		/** 去地图某个点 */
		private function toPoint(x : int, y : int, directionX : int = 0, directionY : int = 0, callFun : Function = null, callFunArgs : Array = null, responseRadius : int = 150) : void
		{
			clear();
			employ = true;
			if (directionX == 0)
			{
				directionX = x;
				directionY = y;
			}
			this.directionX = directionX;
			this.directionY = directionY;
			toX = x;
			toY = y;
			toMapId = 0;
			radius = responseRadius;
			this.flashStep = false;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			var mapPoint : MapPoint = SelfMediator.cbPosition.call();
			var distance : Number = MapMath.distance(mapPoint.x, mapPoint.y, directionX, directionY);
			if (distance < responseRadius)
			{
				arrive();
				return;
			}
			checkArrive();
		}

		// ================
		// 去某个NPC
		// ================
		private var delayCallToNpc : DelayCall = new DelayCall();

		private function delayCallToNpcHandler() : void
		{
			MapMediator.sInstallComplete.remove(delayCallToNpcHandler);
			delayCallToNpc.call();
		}

		private function toNpc(npcId : int, mapId : uint = 0, callFun : Function = null, callFunArgs : Array = null, flashStep : Boolean = false, pointIndex : int = -1) : void
		{
			clear();
			if (MapUtil.isDuplMap() && MapUtil.isDuplMap(mapId) == false)
			{
				var currentMapId : int ;
				var parentMapId : int ;
				currentMapId = MapUtil.currentMapId;
				parentMapId = MapUtil.getParentMapId(currentMapId);
				if (parentMapId == mapId)
				{
					delayCallToNpc.register(toNpc, [npcId, mapId, callFun, callFunArgs, flashStep, pointIndex]);
					MapMediator.sInstallComplete.add(delayCallToNpcHandler);
					MWorld.csLeaveMap();
				}
				else
				{
					if (MapUtil.isDuplMap(mapId) == false)
					{
						delayCallToNpc.register(toNpc, [npcId, mapId, callFun, callFunArgs, flashStep, pointIndex]);
						MapMediator.sInstallComplete.add(delayCallToNpcHandler);
						MWorld.worldMapTo(mapId);
					}
					else
					{
						Alert.show("去副本NPC不准用 toNpc ,请用toDuplNpc");
					}
				}
				return;
			}

			var npcStruct : NpcStruct = MapUtil.getNpcStruct(npcId, mapId);
			if (npcStruct == null)
			{
				throw new Error("toNpc: npc=" + npcId + "  mapId=" + mapId + " 不存在");
				return;
			}

			employ = true;
			direction = true;
			var point : Point = MapUtil.getNpcStandPosition(npcId, mapId, pointIndex);
			toX = point.x;
			toY = point.y;
			toX += MapMath.randomPlusMinus(40);
			toY += MapMath.randomPlusMinus(40);
			var directionPoint : Point = MapUtil.getNpcPosition(npcId, mapId);
			directionX = directionPoint.x;
			directionY = directionPoint.y;
			toMapId = mapId;
			radius = npcStruct.standRadius;
			this.flashStep = flashStep;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			if (MapUtil.isDuplMap() == false && MapUtil.isCurrentMapId(mapId))
			{
				var mapPoint : MapPoint = SelfMediator.cbPosition.call();
				var distance : Number = MapMath.distance(mapPoint.x, mapPoint.y, directionX, directionY);
				if (distance < npcStruct.originRadius)
				{
					arrive();
					return;
				}
			}

			checkArrive();
		}

		// ================
		// 去某个传送门
		// ================
		private function toGate(toMapId : uint, mapId : uint = 0, stand : Boolean = false, callFun : Function = null, callFunArgs : Array = null, responseRadius : int = 50, flashStep : Boolean = false) : void
		{
			if (MWorld.isChangeMaping) return;
			clear();
			var point : Point;
			if (stand)
			{
				point = MapUtil.getGateStandPosition(toMapId, mapId);
				point.x += MapMath.randomPlusMinus(100);
				point.y += MapMath.randomPlusMinus(100);
			}
			else
			{
				point = MapUtil.getGateCenter(toMapId, mapId);
			}
			// var directionPoint : Point = MapUtil.getGateCenter(toMapId, mapId);
			employ = true;
			direction = false;
			// directionX = directionPoint.x;
			// directionY = directionPoint.y;
			toX = point.x;
			toY = point.y;
			this.toMapId = mapId;
			radius = responseRadius;
			this.flashStep = flashStep;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			checkArrive();
		}

		private function toExitGate() : void
		{
			var currentMapId : int = MapUtil.currentMapId;
			var parentMapId : int;
			if (MapUtil.isDuplMap(currentMapId))
			{
				parentMapId = MapUtil.getParentMapId(currentMapId);
				toGate(parentMapId, 0, false, MWorld.csLeaveMap);
			}
		}

		// ================
		// 去某个地图
		// ================
		private var delayCallToMap : DelayCall = new DelayCall();

		private function delayCallToMapHandler() : void
		{
			MapMediator.sInstallComplete.remove(delayCallToMapHandler);
			delayCallToMap.call();
		}

		private function toMap(x : int, y : int, mapId : uint = 0, callFun : Function = null, callFunArgs : Array = null, responseRadius : int = 30, flashStep : Boolean = false) : void
		{
			clear();
			if (MapUtil.isDuplMap() && MapUtil.isDuplMap(mapId) == false)
			{
				var currentMapId : int ;
				var parentMapId : int ;
				currentMapId = MapUtil.currentMapId;
				parentMapId = MapUtil.getParentMapId(currentMapId);
				if (parentMapId == mapId)
				{
					delayCallToMap.register(toMap, [x, y, mapId, callFun, callFunArgs, responseRadius, flashStep]);
					MapMediator.sInstallComplete.add(delayCallToMapHandler);
					MWorld.csLeaveMap();
				}
				else
				{
					if (MapUtil.isDuplMap(mapId) == false)
					{
						delayCallToMap.register(toMap, [x, y, mapId, callFun, callFunArgs, responseRadius, flashStep]);
						MapMediator.sInstallComplete.add(delayCallToMapHandler);
						MWorld.worldMapTo(mapId);
					}
					else
					{
						Alert.show("去副本NPC不准用 toNpc ,请用toDuplNpc");
					}
				}
				return;
			}

			employ = true;
			directionX = x;
			directionY = y;
			toX = x;
			toY = y;
			toMapId = mapId;
			radius = responseRadius;
			this.flashStep = flashStep;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			checkArrive();
		}

		// ================
		// 去某个副本地图
		// ================
		private var delayCallToDupMap : DelayCall = new DelayCall();

		private function delayCallToDupMapHandler() : void
		{
			MapMediator.sInstallComplete.remove(delayCallToDupMapHandler);
			delayCallToDupMap.call();
		}

		private function arriveGate(toDuplMapId : int) : void
		{
			var gateStruct : GateStruct = MapUtil.getGateStruct(toDuplMapId);
			if (gateStruct)
			{
				// delayCallToDupMap.register(toDupMap, [toDuplMapId]);
				// MapMediator.sInstallComplete.add(delayCallToDupMapHandler);
				MWorld.csUseGateChangeMap(gateStruct.id);
			}
		}

		private function toDupMap(toDuplMapId : int = 0, flashStep : Boolean = false) : void
		{
			clear();
			if (toDuplMapId == 0) toDuplMapId = MapUtil.currentMapId;
			if (MapUtil.isCurrentMapId(toDuplMapId))
			{
				NpcMediator.gotoNextAI.dispatch();
				return;
			}

			var parentMapId : int = MapUtil.getParentMapId(toDuplMapId);
			var currentMapId : int = MapUtil.currentMapId;
			if (MapUtil.isDuplMap(currentMapId) == false)
			{
				toGate(toDuplMapId, parentMapId, false, arriveGate, [toDuplMapId], 50, flashStep);
				return;
			}
			else
			{
				if (parentMapId == MapUtil.getParentMapId(currentMapId))
				{
					delayCallToDupMap.register(toDupMap, [toDuplMapId, flashStep]);
					MapMediator.sInstallComplete.add(delayCallToDupMapHandler);
					MWorld.csLeaveMap();
				}
				else
				{
					delayCallToDupMap.register(toDupMap, [toDuplMapId, flashStep]);
					MapMediator.sInstallComplete.add(delayCallToDupMapHandler);
					MWorld.worldMapTo(parentMapId);
				}
			}
		}

		/** 传送 */
		private function transportTo(x : int, y : int, mapId : int = 0, callFun : Function = null, callFunArgs : Array = null) : void
		{
			clear();
			employ = true;
			directionX = x;
			directionY = y;
			toX = x;
			toY = y;
			toMapId = mapId;
			radius = 30;
			this.flashStep = true;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			checkArrive();
		}
	}
}
class Singleton
{
}