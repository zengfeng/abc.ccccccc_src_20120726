package game.module.mapFeast.ui {
	import com.utils.FilterUtils;
	import framerate.SecondsTimer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author 1
	 */
	public class UIFeastIconTimer extends TextField {
		
		private var _timeLeft:uint = 0 ;
		private var _timeString:String = "" ;
		
		public function UIFeastIconTimer() {
			super();
			width = 40 ;
			height = 18 ;
			initTimeFont() ;
		}
		
		public function initTimeFont():void{
			var cdFormat:TextFormat = new TextFormat() ;
			cdFormat = new TextFormat();
			cdFormat.align = "center";
			cdFormat.size = 14 ;
			cdFormat.color = 0xFFFFFF ;
			this.defaultTextFormat = cdFormat ;
			this.filters = [FilterUtils.defaultTextEdgeFilter];
			this.selectable = false ;
		}
		
		public function set timeLeft( t : uint ):void{
			//finish timing 
			if( t == 0 && _timeLeft != 0 ){
				SecondsTimer.removeFunction(onSecondTimer);
			}
			else if( t != 0 && _timeLeft == 0 ){
				SecondsTimer.addFunction(onSecondTimer);
			}
			if( _timeLeft != t )
			{
				_timeLeft = t ;
				updateTimeDisplay();
				var evt:Event = new Event(FeastEvent.FEAST_SECOND);
				dispatchEvent(evt);
			}
		}
		
		public function get timeLeft():uint
		{
			return _timeLeft ;
		}
		
		public function updateTimeDisplay():void
		{
			var min:int = _timeLeft/60 ;
			var sec:int = _timeLeft%60 ;
			_timeString = (min > 9 ? "" : "0")+min.toString() + (sec>9? ":" : ":0") + sec.toString() ;
			text = _timeString ;
		}

		private function onSecondTimer() : void {
			-- timeLeft ;
		}
		
		public function get timeString():String
		{
			return _timeString ;
		}
	}
}
