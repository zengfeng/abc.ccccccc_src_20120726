package game.module.mapFeast.ui {
	import game.manager.ViewManager;
	import game.module.mapFeast.FeastConfig;

	import gameui.containers.GPanel;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import gameui.manager.GToolTipManager;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.FilterUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;





	/**
	 * @author 1
	 */
	public class UIFeastStart extends GPanel{
		
		private var _ableText:Sprite ;
		
		private var _disableText:Sprite ;
		
		private var _beginTimer:UIFeastIconTimer ;
				
		private var _preTime:uint = 0 ;
		
		private var _fakeDisable:Boolean = false ;
		
		private var _startBtn:UIFeastStartButton ;
		
		private var _disPanel:GPanel ;
		
		private var _mouseOver:Boolean ;
		
		public function UIFeastStart(data : GPanelData) {
			data.width = 82 ;
			data.height = 82 ;
			data.bgAsset = new AssetData(SkinStyle.emptySkin);
//			data.parent = ViewManager.instance.uiContainer ;
			super(data);
			initButton() ;
		}
		
		public function initButton():void
		{
			var data:GButtonData = new GButtonData();
			_startBtn = new UIFeastStartButton(data);
			_startBtn.x = -4 ;
			_startBtn.y = -4 ;
			_ableText = UIManager.getUI(new AssetData(FeastConfig.FEAST_START_TEXT , "mf"));
			_ableText.x = -3 ;
			_ableText.y = 71 ;
			addChild(_startBtn);
			_startBtn.addChild(_ableText);
			var pdata:GPanelData = new GPanelData() ;
			pdata.width = width ;
			pdata.height = height ;
			pdata.bgAsset = new AssetData( FeastConfig.FEAST_START_DOWN, "mf" ); 
			_disPanel = new GPanel(pdata);
			_disPanel.filters = [FilterUtils.disableFilter()];
			_disableText = UIManager.getUI(new AssetData(FeastConfig.FEAST_START_TEXT, "mf"));
			_disableText.x = -7 ;
			_disableText.y = 67 ;
			_disPanel.addChild(_disableText);
			_beginTimer = new UIFeastIconTimer();
			_beginTimer.x = 21 ;
			_beginTimer.y = 85 ;
			_beginTimer.addEventListener( FeastEvent.FEAST_SECOND, onTimerChange );
			_disPanel.addChild(_beginTimer);
			_disPanel.toolTip = ToolTipManager.instance.getToolTip(ToolTip);
			_disPanel.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_disPanel.addEventListener(MouseEvent.MOUSE_OUT, onMouseLeave);
		}
		
		private function onMouseLeave(evt:Event):void{
			_mouseOver = false ;
		}
		
		private function onMouseOver(evt:Event):void{
			_mouseOver = true ;
			_disPanel.toolTip.source = FeastConfig.FEAST_START_TOOLTIP.replace("__TIME__" , _beginTimer.timeString) ;
		}

		public function onTimerChange(evt:Event):void
		{
			if( _beginTimer.timeLeft == 0 )
			{
				fakeDisable = false ;
				_preTime = _beginTimer.timeLeft ;
				return ;
			}

			if( _preTime == 0 )
			{
				fakeDisable = true ;
			}
			
			if( _mouseOver ){
				_preTime = _beginTimer.timeLeft ;
				_disPanel.toolTip.source = FeastConfig.FEAST_START_TOOLTIP.replace("__TIME__" , _beginTimer.timeString);
			}
		}
		
		public function set fakeDisable( disable:Boolean ):void
		{
			if( _fakeDisable && !disable )
			{
				// show
				_fakeDisable = false ;
				GToolTipManager.destroyToolTip(_disPanel);
				if( contains(_disPanel) )
					removeChild(_disPanel);
				addChild(_startBtn);
				_startBtn.effectOn();
				
			}
			else if( !_fakeDisable && disable )
			{
				_fakeDisable = true ;
				GToolTipManager.registerToolTip(_disPanel);
				if( contains(_startBtn) )
					removeChild(_startBtn);					
				addChild(_disPanel);
				_startBtn.effectOff();
			}
		}
		
		public function set cooldown( t:uint ):void
		{
			_beginTimer.timeLeft = t ;
		}
		
		public function get cooldown():uint
		{
			return _beginTimer.timeLeft ;
		}
		
		override public function show():void{
			super.show();
			if( !_fakeDisable )
				_startBtn.effectOn();
		}
		
		override public function hide():void{
			super.hide();
			_startBtn.effectOff();
		}
	}
}
