package worlds.loads
{
	import game.manager.SignalBusManager;
	import game.net.core.Common;

	import com.commUI.CommonLoading;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-12
	 */
	public class LoadingPanel
	{
		function LoadingPanel(singleton : Singleton)
		{
			singleton;
			SignalBusManager.battleReady.add(onBattlerReady);
			SignalBusManager.battleOver.add(onBattleOver);
		}

		/** 单例对像 */
		private static var _instance : LoadingPanel;

		/** 获取单例对像 */
		static public function get instance() : LoadingPanel
		{
			if (_instance == null)
			{
				_instance = new LoadingPanel(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 加载UI */
		private var _loaderPanel : CommonLoading;

		private function get loaderPanel() : CommonLoading
		{
			if (_loaderPanel == null)
			{
				_loaderPanel = Common.getInstance().loadPanel;
			}
			return _loaderPanel;
		}

		private var battleing : Boolean = false;
		private var loading : Boolean = false;
		private var loadValue : Number = 0;
		private var loadTotal : Number = 100;

		public function onBattlerReady() : void
		{
			battleing = true;
		}

		public function onBattleOver() : void
		{
			battleing = false;
			if (loading)
			{
				loaderPanel.open();
				loaderPanel.isLoadMapProgress = true;
				loaderPanel.isSetupMapProgress = false;
				loaderPanel.loadMapProgress((loadValue / loadTotal) * 100);
			}
		}

		public function show() : void
		{
			loading = true;
			if (battleing) return;
			loaderPanel.open();
			loaderPanel.isLoadMapProgress = true;
			loaderPanel.isSetupMapProgress = false;
			loaderPanel.loadMapProgress(0);
		}

		public function hide() : void
		{
			if (battleing) return;
			loaderPanel.hide();
			loaderPanel.isLoadMapProgress = false;
			loaderPanel.isSetupMapProgress = false;
			loading = false;
		}

		public function setLoadProgress(value : Number, total : Number) : void
		{
			loadValue = value;
			loadTotal = total;
			if (battleing) return;
			loaderPanel.loadMapProgress((loadValue / loadTotal) * 100);
		}

		public function setLoadCompelete() : void
		{
			loadValue = loadTotal;
			loading = false;
			if (battleing) return;
			loaderPanel.loadMapProgress(100);
			loaderPanel.isLoadMapProgress = false;
			loaderPanel.isSetupMapProgress = false;
		}
		
		public function setLoadPanelProgress(value:Number, text:String = ""):void
		{
			loaderPanel.updateProgress(text, value);
		}
		
	}
}
class Singleton
{
}