package game.module.mapFeast.ui {
	import flash.display.Sprite;
	import game.module.mapFeast.FeastConfig;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import game.manager.ViewManager

	/**
	 * @author 1
	 */
	public class UIFeastMatch extends GPanel{
		
		private var _feastTimer:UIFeastIconTimer ;
		
		public function UIFeastMatch(data : GPanelData) {
			data.width = 85 ;
			data.height = 84 ;
			data.bgAsset = new AssetData(FeastConfig.FEAST_MATCH, "mf");
//			data.parent = ViewManager.instance.uiContainer ;
			super(data);
			addTimer() ;
		}
		
		public function addTimer():void{
			_feastTimer = new UIFeastIconTimer() ;
			_feastTimer.x = 48 ;
			_feastTimer.y = 72 ;
			addChild(_feastTimer);
			
			var txt:Sprite = UIManager.getUI(new AssetData(FeastConfig.FEAST_MATCH_TEXT, "mf"));
			txt.x = 3 ;
			txt.y = 67 ;
			addChild(txt);
		}

		public function set timeLeft( t:uint ):void
		{
			_feastTimer.timeLeft = t ;
		}
		
		public function get timeLeft():uint
		{
			return _feastTimer.timeLeft ;
		}	
	}
}
