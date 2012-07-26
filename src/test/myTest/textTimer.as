package test.myTest {
	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	public class textTimer extends Sprite {
		public function textTimer() {
			var thisDate:Date = new Date();
			
			var dateParsed:String = "Sat Nov 30 1974";

			var milliseconds:Number = Date.parse(dateParsed);
			//trace(milliseconds,"--------------"); // 155030400000
			
			//trace(thisDate.valueOf());
			//trace(thisDate.getTime());
		}
	}
}
