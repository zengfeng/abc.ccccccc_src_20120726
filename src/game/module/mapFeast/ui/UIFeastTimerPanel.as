package game.module.mapFeast.ui {
	import flash.display.DisplayObjectContainer;
	import com.utils.FilterUtils;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import framerate.SecondsTimer;
	import game.definition.UI;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import gameui.skin.SkinStyle;
	import net.AssetData;





	/**
	 * @author 1
	 */
	public class UIFeastTimerPanel extends TextField {
		
		
		private var _timeLeft:uint ;
		
		private var _timing:Boolean = false ;
		private var _parent:DisplayObjectContainer ;
		private var _shown:Boolean = false ;
		public function UIFeastTimerPanel() {
			super();
			width = 174 ;
			height = 20 ;
			addTimerFormat();
			updateTimePanel(0);
		}
		
		public function addTimerFormat():void
		{
			selectable = false ;
			filters = [FilterUtils.defaultTextEdgeFilter];
			var format:TextFormat = new TextFormat ;
			format.size = 14 ;
			format.align = "center";
			format.color = 0xFFFFFF ;
			defaultTextFormat = format ;
		}
		
		public function onSecondTimer():void
		{
			if( _timeLeft != 0 )
			{
				updateTimePanel( -- _timeLeft ) ;
			}
			else 
			{
				SecondsTimer.removeFunction(onSecondTimer);
				_timing = false ;
			}
		}
		
		public function updateTimePanel( tim:uint ):void
		{
			var min:uint = Math.floor(tim/60) ;
			var sec:uint = tim%60 ;
			text = ( min < 10 ? "仙会结束时间  0": "仙会结束时间 " ) + min + ( sec < 10 ? ":0" : ":" ) + sec ; 
		}
		
		public function set timeLeft( time:uint ):void
		{
			_timeLeft = time ;
			if( time == 0 && _timing )
			{
				_timing = false ;
				SecondsTimer.removeFunction(onSecondTimer);
			}
			else if( time != 0 && !_timing )
			{
				_timing = true ;
				SecondsTimer.addFunction(onSecondTimer);
			}
			else if( time != 0 )
			{
				updateTimePanel(time);
			}
		}
		
		public function get timeLeft():uint
		{
			return _timeLeft ;
		}

		public function hide() : void {
			if( _parent == null || !_shown )
				return ;
			_parent.removeChild(this);
			_shown = false ;
		}

		public function show() : void {
			if( _parent == null || _shown )
				return ;
			_parent.addChild(this);
			_shown = true ;
		}
		
		public function setParent( obj:DisplayObjectContainer ):void{
			_parent = obj ;
		}
		
	}
}
