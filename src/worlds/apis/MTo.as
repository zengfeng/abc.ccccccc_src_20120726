package worlds.apis
{
	import worlds.apis.validators.Validator;
	import worlds.mediators.ToMediator;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	 */
	public class MTo
	{
		public static function clear() : void
		{
			ToMediator.clear.call();
		}

		/** 去某个点(只限当前地图,如果跨地图请用MTo.map) */
		public static function toPoint(depth : int, x : int, y : int, directionX : int = 0, directionY : int = 0, callFun : Function = null, callFunArgs : Array = null, responseRadius : int = 150) : void
		{
			if (depth > 0)
			{
				-- depth ;
				var result : Boolean = MValidator.walk.doValidation(toPoint, [depth, x, y, directionX, directionY, callFun, callFunArgs, responseRadius]);
				if (result == false)
				{
					return;
				}
			}
			ToMediator.toPoint.call(x, y, directionX, directionY, callFun, callFunArgs, responseRadius);
		}

		public static function toNpc(depth : int, npcId : int, mapId : uint = 0, callFun : Function = null, callFunArgs : Array = null, flashStep : Boolean = false, pointIndex : int = -1) : void
		{
			if (depth > 0)
			{
				-- depth ;
				var result : Boolean = MValidator.walk.doValidation(toNpc, [depth, npcId, mapId, callFun, callFunArgs, flashStep, pointIndex]);
				if (result)
				{
					if (MapUtil.isCurrentMapId(mapId) == false)
					{
						result = MValidator.changeMap.doValidation(toNpc, [depth, npcId, mapId, callFun, callFunArgs, flashStep, pointIndex]);
					}
				}

				if (result == false)
				{
					return;
				}
			}
			ToMediator.toNpc.call(npcId, mapId, callFun, callFunArgs, flashStep, pointIndex);
		}

		public static function toDuplNpc(toDuplMapId : int = 0, flashStep : Boolean = false) : void
		{
			if (MapUtil.isCurrentMapId(toDuplMapId) == false)
			{
				var result : Boolean = MValidator.changeMap.doValidation(toDuplNpc, [toDuplMapId, flashStep]);
				if (result == false)
				{
					return;
				}
			}
			ToMediator.toDuplNpc.call(toDuplMapId, flashStep);
		}

		public static function toGate(toMapId : uint, mapId : uint = 0, stand : Boolean = false, callFun : Function = null, callFunArgs : Array = null, flashStep : Boolean = false, responseRadius : int = 50) : void
		{
			ToMediator.toGate.call(toMapId, mapId, stand, callFun, callFunArgs, responseRadius, flashStep);
		}

		public static function toExitGate() : void
		{
			ToMediator.toExitGate.call();
		}

		public static function toMap(depth : int, x : int, y : int, mapId : uint = 0, callFun : Function = null, callFunArgs : Array = null, flashStep : Boolean = false, responseRadius : int = 30) : void
		{
			if (depth > 0)
			{
				-- depth ;
				var result : Boolean = MValidator.walk.doValidation(toMap, [depth, x, y, mapId, callFun, callFunArgs, responseRadius, flashStep]);
				if (result)
				{
					if (MapUtil.isCurrentMapId(mapId) == false)
					{
						result = MValidator.changeMap.doValidation(toMap, [depth, x, y, mapId, callFun, callFunArgs, responseRadius, flashStep]);
					}
				}

				if (result == false)
				{
					return;
				}
			}
			ToMediator.toMap.call(x, y, mapId, callFun, callFunArgs, responseRadius, flashStep);
		}

		public static function transportTo(depth : int, x : int, y : int, mapId : int = 0, callFun : Function = null, callFunArgs : Array = null) : void
		{
			if (depth)
			{
				-- depth ;
				var result : Boolean = MValidator.transport.doValidation(transportTo, [depth, x, y, mapId, callFun, callFunArgs]);
				if (result)
				{
					if (MapUtil.isCurrentMapId(mapId) == false)
					{
						result = MValidator.changeMap.doValidation(transportTo, [depth, x, y, mapId, callFun, callFunArgs]);
					}
				}

				if (result == false)
				{
					return;
				}
			}
			ToMediator.transportTo.call(x, y, mapId, callFun, callFunArgs);
		}
		
		public static const validWalk:Validator = MValidator.walk ;
		public static const validMapTo:Validator = MValidator.changeMap ;
		public static const validTrans:Validator = MValidator.transport ;
		public static const validChangeAct:Validator = MValidator.joinOtherActivity ;
	}
}
