package test.myTest.buttonEvent {
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import gameui.data.GButtonData;
	import gameui.controls.GButton;
	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	public class btnDisEvetn extends Sprite {
		private var sp:Sprite;
		public function btnDisEvetn() {
			sp = new Sprite();
			sp.graphics.beginFill(0x555555);
			sp.graphics.drawRect(0, 0, 200, 150);
			sp.graphics.endFill();
			this.addChild(sp);
			addButn();
		}
		private var btn:GButton;
		private function addButn() : void {
			var data:GButtonData = new GButtonData();
			data.labelData.text = "btn";
			data.x = 50;
			data.y = 100;
			btn = new GButton(data);
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onclick);
			
		}
		private var text:TextField;
		private function onclick(event : MouseEvent) : void {
			event.stopPropagation();
			text = new TextField();
			text.text = "5555";
			this.addChild(text);
		}
	}
}
