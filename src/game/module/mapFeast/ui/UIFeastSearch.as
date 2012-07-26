package game.module.mapFeast.ui {
	import game.manager.ViewManager;
	import game.module.mapFeast.FeastConfig;

	import gameui.containers.GPanel;
	import gameui.data.GPanelData;

	import net.AssetData;
	import net.RESManager;

	import flash.display.MovieClip;




	/**
	 * @author 1
	 */
	public class UIFeastSearch extends GPanel 
	{
		private var _searchText : MovieClip ;

		public function UIFeastSearch(data : GPanelData)
		{
			data.bgAsset = new AssetData(FeastConfig.FEAST_SEARCH, "mf");
			data.width = 90 ;
			data.height = 85.85 ;
//			data.parent = ViewManager.instance.uiContainer ;
			super(data);
			addSearchText() ;
		}

		private function addSearchText() : void
		{
			_searchText = RESManager.getMC(new AssetData(FeastConfig.FEAST_SEARCH_TEXT, "mf"));
			if (!_searchText) return;
			_searchText.x = 7 ;
			_searchText.y = 67 ;
			addChild(_searchText);
		}

		override public function show() : void
		{
			super.show();
			if (!_searchText) return;
				_searchText.gotoAndPlay(0);
		}

		override public function hide() : void
		{
			super.hide();
			if (!_searchText) return;
				_searchText.stop();
		}
	}
}
