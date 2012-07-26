package game.module.mapWorld
{
	import worlds.maps.configs.MapId;
	import worlds.apis.MapUtil;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-26 ����9:09:01
	 */
	public class WorldMapUtil
	{
		/** 获取世界地图ID */
		public static function getWorldMapId(mapId : int = 0) : int
		{
			if (mapId == 0) mapId = MapUtil.currentMapId;
			if (MapUtil.isDuplMap(mapId))
			{
				mapId = MapUtil.getParentMapId(mapId);
			}
			var worldMapStruct : WorldMapStruct = WorldMapConfig.worldMap[mapId];
			if (worldMapStruct == null)
			{
				worldMapStruct = WorldMapConfig.copyMap[mapId];
				if (worldMapStruct)
				{
					mapId = worldMapStruct.parentMap;
				}
				else
				{
					mapId = MapId.CAPITAL;
				}
			}
			return mapId;
		}
	}
}
