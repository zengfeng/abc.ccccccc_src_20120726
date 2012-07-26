package worlds.loads
{
	import log4a.Logger;
	import flash.events.Event;
	import game.net.core.Common;
	import net.ALoader;
	import net.RESManager;

	import worlds.auxiliarys.mediators.MSignal;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-12
	 */
	public class RssLoadbar
	{
		/** 单例对像 */
		private static var _instance : RssLoadbar;

		/** 获取单例对像 */
		static public function get instance() : RssLoadbar
		{
			if (_instance == null)
			{
				_instance = new RssLoadbar(new Singleton());
			}
			return _instance;
		}

		function RssLoadbar(singleton : Singleton) : void
		{
		}

		/** 资源加载管理器 */
		private var res : RESManager = RESManager.instance;
		private var list : Array;
		/** 消息--资源加载进度 args=[value, total] */
		public var sRssProgress : MSignal = new MSignal(int, int);
		/** 消息--资源加载完成 */
		public var sRssComplete : MSignal = new MSignal();

		public function start() : void
		{
			list = RssData.instance.loadbarData;
			var loader:ALoader;
			for each(loader in list)
			{
				Logger.info(loader.url);
				res.add(loader);
			}
			
			res.addEventListener(Event.COMPLETE, loadComplete);
//			Common.getInstance().loadPanel.startShow(false);
			res.startLoad();
		}
		
		private function loadComplete(event:Event):void
		{
			res.removeEventListener(Event.COMPLETE, loadComplete);
			Common.getInstance().loadPanel.hide();
			sRssComplete.dispatch();
		}

		public function clearup() : void
		{
		}
	}
}
class Singleton
{
}