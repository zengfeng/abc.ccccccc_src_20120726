package worlds.loads
{
	import log4a.Logger;
	import worlds.auxiliarys.loads.LoadManager;
	import worlds.maps.preloads.MapPreload;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-11
	 */
	public class LoadControl
	{
		/** 单例对像 */
		private static var _instance : LoadControl;

		/** 获取单例对像 */
		static public function get instance() : LoadControl
		{
			if (_instance == null)
			{
				_instance = new LoadControl(new Singleton());
			}
			return _instance;
		}

		function LoadControl(singleton : Singleton) : void
		{
			singleton;
			loadingPanel = LoadingPanel.instance;
			loadManager = LoadManager.instance;
			mapPreload = MapPreload.instance;
			rssData = RssData.instance;
			rssLoadbar = RssLoadbar.instance;
			rssLoadpre = RssLoadpre.instance;
			LoadMediator.sPause.add(loadManager.pause);
			LoadMediator.sGo.add(loadManager.go);
		}

		private var loadingPanel : LoadingPanel;
		private var loadManager : LoadManager;
		private var mapPreload : MapPreload;
		private var rssData : RssData;
		private var rssLoadbar : RssLoadbar;
		private var rssLoadpre : RssLoadpre;
		private var mapNum : Number;
		private var totalNum : Number;
		private var hasRssbar : Boolean;

		public function clearup() : void
		{
			RssMap.instance.clearup();
			rssLoadbar.clearup();
			rssLoadpre.clearup();
			rssData.clearup();
			LoadMediator.sClearup.dispatch();
		}

		public function ready() : void
		{
			rssData.generateBattle();
			rssData.mergeSelfHeroAvatar();
			rssData.mergeMapLoadFilesConfig();
			LoadMediator.sReady.dispatch();
		}

		public function start() : void
		{
			Logger.info("mapLoad start"  );
			mapPreload.initLoad();
			hasRssbar = rssData.loadbarData.length > 0;
			mapNum = loadManager.totalNum;
			totalNum = mapNum;
			Logger.info("mapLoad mapNum="+ mapNum);
			loadingPanel.show();
			mapPreload.signalComplete.add(mapLoadComplete);
			mapPreload.signalProgress.add(mapLoadProgress);
			mapPreload.startLoad();
			LoadMediator.sStart.dispatch();
		}

		private function mapLoadProgress(value : Number, total : Number) : void
		{
			total;
			Logger.info("mapLoad mapLoadProgress  hasRssbar="  + hasRssbar+" total=" + total + "     value=" + value);
			loadingPanel.setLoadProgress(value, totalNum);
		}

		private function mapLoadComplete() : void
		{
			Logger.info("mapLoad mapLoadComplete  hasRssbar="  + hasRssbar+" totalNum=" + totalNum);
			loadingPanel.setLoadProgress(totalNum, totalNum);
			loadingPanel.setLoadCompelete();
			LoadMediator.sMapLoadComplete.dispatch();
			if (!hasRssbar)
			{
				complete();
			}
			else
			{
				startRssLoadbar();
			}
		}
		
		private function startRssLoadbar():void
		{
			Logger.info("mapLoad startRssLoadbar");
			loadingPanel.setLoadPanelProgress(0);
			rssLoadbar.sRssComplete.add(rssLoadbarComplete);
			rssLoadbar.start();
		}
		
		private function rssLoadbarComplete() : void
		{
			Logger.info("mapLoad rssLoadbarComplete");
			complete();
		}

		public function complete() : void
		{
			Logger.info("mapLoad complete");
			loadingPanel.hide();
			LoadMediator.sAllComplete.dispatch();
			rssLoadpre.start();
		}
	}
}
class Singleton
{
}