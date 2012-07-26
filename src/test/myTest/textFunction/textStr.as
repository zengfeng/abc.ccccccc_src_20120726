package test.myTest.textFunction {
	import gameui.data.GLabelData;
	import gameui.controls.GLabel;
	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	 [SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public class textStr extends Sprite {
		
		public function textStr() {
			var data:GLabelData = new GLabelData();
			var txt:GLabel = new GLabel(data)
		}
	}
}
