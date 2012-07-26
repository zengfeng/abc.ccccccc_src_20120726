package worlds.loads
{
	import worlds.maps.configs.structs.GateStruct;
	import worlds.auxiliarys.MapStage;
	import worlds.maps.configs.LandConfig;

	import com.utils.UrlUtils;

	import worlds.apis.MapUtil;
	import worlds.maps.configs.structs.MapStruct;

	import net.RESManager;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-13
	 */
	public class RssMap
	{
		/** 单例对像 */
		private static var _instance : RssMap;

		/** 获取单例对像 */
		static public function get instance() : RssMap
		{
			if (_instance == null)
			{
				_instance = new RssMap(new Singleton());
			}
			return _instance;
		}

		function RssMap(singleton : Singleton) : void
		{
		}

		/** 资源加载管理器 */
		private var res : RESManager = RESManager.instance;
		private var mapId : int;
		private var mapStruct : MapStruct;
		private var list : Array = [];

		public function getMap(mapId : int) : Array
		{
			var mapStruct : MapStruct = MapUtil.getMapStruct(mapId);
			if (mapStruct == null)
			{
				return list;
			}
			this.mapStruct = mapStruct;
			this.mapId = mapId;
//			var path : String = UrlUtils.getMapPathData(mapId);
//			list.push(path);
			if (mapStruct.hasMask)
			{
				var mask : String = UrlUtils.getMapMask(mapId);
				list.push(mask);
			}

			if (mapId <= 20)
			{
				var thumbnail : String = UrlUtils.getMapThumbnail(mapId);
				list.push(thumbnail);
				getScreen();
				getScreenSide();
			}
			else
			{
				getFull();
			}
			return list;
		}

		private function getFull() : void
		{
			var mapWidth : int = mapStruct.mapWidth;
			var mapHeight : int = mapStruct.mapHeight;
			const PIECE_WIDTH : int = LandConfig.PIECE_WIDTH;
			const PIECE_HEIGHT : int = LandConfig.PIECE_HEIGHT;
			var itemCountX : int = mapWidth / PIECE_WIDTH;
			var itemCountY : int = mapHeight / PIECE_HEIGHT;
			var x : int;
			var y : int;
			var url : String;
			for (y = 0; y < itemCountY; y++)
			{
				for (x = 0; x < itemCountX; x++)
				{
					url = UrlUtils.getMapPiece2(mapId, x, y);
					list.push(url);
				}
			}
		}

		private function getScreen() : void
		{
			var mapX : int = 0;
			var mapY : int = 0;
			var gateStruct : GateStruct = mapStruct.freeGate;
			if (gateStruct)
			{
				mapX = gateStruct.x;
				mapY = gateStruct.y;
			}
			var mapWidth : int = mapStruct.mapWidth;
			var mapHeight : int = mapStruct.mapHeight;
			var stageWidth : int = MapStage.stageWidth;
			var stageHeight : int = MapStage.stageHeight;
			const PIECE_WIDTH : int = LandConfig.PIECE_WIDTH;
			const PIECE_HEIGHT : int = LandConfig.PIECE_HEIGHT;
			var  isItemStageIntX : Boolean = stageWidth % PIECE_WIDTH == 0;
			var  isItemStageIntY : Boolean = stageHeight % PIECE_HEIGHT == 0;
			var  itemStageCountX : int = Math.ceil(stageWidth / PIECE_WIDTH);
			var  itemStageCountY : int = Math.ceil(stageHeight / PIECE_HEIGHT);
			var itemCountX : int = mapWidth / PIECE_WIDTH;
			var itemCountY : int = mapHeight / PIECE_HEIGHT;

			var startItemX : int = mapX / PIECE_WIDTH;
			var startItemY : int = mapY / PIECE_HEIGHT;
			var endItemX : int = startItemX + itemStageCountX;
			var endItemY : int = startItemY + itemStageCountY;

			var isStartItemIntX : Boolean = mapX % PIECE_WIDTH == 0;
			var  isStartItemIntY : Boolean = mapY % PIECE_HEIGHT == 0;
			if (!isStartItemIntX && !isItemStageIntX)
			{
				endItemX += 1;
			}

			if (!isStartItemIntY && !isItemStageIntY)
			{
				endItemY += 1;
			}
			if (endItemX >= itemCountX) endItemX = itemCountX - 1;
			if (endItemY >= itemCountY) endItemY = itemCountY - 1;

			var x : int;
			var y : int;
			var url : String;
			for (y = startItemY; y <= endItemY; y++)
			{
				for (x = startItemX; x <= endItemX; x++)
				{
					url = UrlUtils.getMapPiece2(mapId, x, y);
					list.push(url);
				}
			}
		}

		private function getScreenSide() : void
		{
			var mapWidth : int = mapStruct.mapWidth;
			var mapHeight : int = mapStruct.mapHeight;
			const PIECE_WIDTH : int = LandConfig.PIECE_WIDTH;
			const PIECE_HEIGHT : int = LandConfig.PIECE_HEIGHT;
			var itemCountX : int = mapWidth / PIECE_WIDTH;
			var itemCountY : int = mapHeight / PIECE_HEIGHT;
			var x : int;
			var y : int;
			var url : String;
			for (y = 0; y < itemCountY; y++)
			{
				for (x = 0; x < itemCountX; x++)
				{
					url = UrlUtils.getMapPiece2(mapId, x, y);
					if (list.indexOf(url) == -1) list.push(url);
				}
			}
		}

		public function clearup() : void
		{
			if (list)
			{
				while (list.length > 0)
				{
					res.removePreLoad(list.shift());
				}
			}
		}
	}
}
class Singleton
{
}