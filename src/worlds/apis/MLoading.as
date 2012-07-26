package worlds.apis
{
	import net.ALoader;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.loads.LoadMediator;
	import worlds.loads.RssData;
	import worlds.loads.RssMap;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-11
	 */
	public class MLoading
	{
		public static var sClearup:MSignal = LoadMediator.sClearup;
		public static var sStart:MSignal = LoadMediator.sStart;
		/** 通知各位准备需要添加资源进加载条模块 */
		public static var sReady : MSignal = LoadMediator.sReady;
		public static var sAllComplete:MSignal = LoadMediator.sAllComplete;

		/** 添加一个url */
		public static function append(loader:ALoader) : void
		{
			RssData.instance.append(loader);
		}
		
		/** 获取地图资源文件列表 */
		public static function getMap(mapId:int):Array
		{
			return RssMap.instance.getMap(mapId);
		}
		
		/** 暂停 */
		public static function pause():void
		{
			LoadMediator.sPause.dispatch();
		}
		
		/** 继续 */
		public static function go():void
		{
			LoadMediator.sGo.dispatch();
		}
	}
}
