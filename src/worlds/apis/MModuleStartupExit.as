package worlds.apis
{
	import flash.utils.Dictionary;
	import game.module.mapConvoy.ConvoyControl;
	import worlds.maps.configs.MapId;
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-29
	*/
	public class MModuleStartupExit
	{
			/** 单例对像 */
		private static var _instance : MModuleStartupExit;

		/** 获取单例对像 */
		private static  function get instance() : MModuleStartupExit
		{
			if (_instance == null)
			{
				_instance = new MModuleStartupExit(new Singleton());
			}
			return _instance;
		}
		
		function MModuleStartupExit(Singleton:Singleton):void
		{
		}
		
		private var preMapId:int = -1;
		private var currMapId:int = -1;
		private var addDic:Dictionary = new Dictionary();
		private var removeDic:Dictionary = new Dictionary();
		
		
		private function changeMap():void
		{
			currMapId = MapUtil.currentMapId;
			if(MapUtil.isCapitalMap(preMapId))
			{
				ConvoyControl.instance.removeModelListener();
			}
			
			if(MapUtil.isCapitalMap(currMapId))
			{
				ConvoyControl.instance.addModelListener();
			}
			preMapId = currMapId;
		}
		
		public static function changeMap():void
		{
			instance.changeMap();
		}
	}
}
class Singleton{}
