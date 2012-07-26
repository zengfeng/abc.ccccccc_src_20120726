package worlds.maps.configs
{
	import flash.utils.Dictionary;
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-13
	 */
	public class MapLoadFilesConfigData
	{/** 单例对像 */
		private static var _instance : MapLoadFilesConfigData;

		/** 获取单例对像 */
		static public function get instance() : MapLoadFilesConfigData
		{
			if (_instance == null)
			{
				_instance = new MapLoadFilesConfigData(new Singleton());
			}
			return _instance;
		}

		public function MapLoadFilesConfigData(singleton : Singleton)
		{
		}
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var dic:Dictionary = new Dictionary();
		
		public function getFiles(mapId:int):Array
		{
			return dic[mapId];
		}
	}
}
class Singleton{}