package test.myTest.buttonEvent {
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	/**
	 * @author Lv
	 */
	 [SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public class main extends Sprite {
		private var txt:TextField;
		private var btn:btnDisEvetn;
		public function main():void{
			txt = new TextField();
			this.addChild(txt);
			btn = new btnDisEvetn();
			btn.x = 200;
			btn.y = 150;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onclick);
			
			
		}

		private function onclick(event : MouseEvent) : void {
			txt.text = "失败--";
		}
	}
}
