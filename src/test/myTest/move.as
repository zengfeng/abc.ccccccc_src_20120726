package test.myTest {
	import flash.events.MouseEvent;
	import gameui.data.GButtonData;
	import gameui.controls.GButton;
	import flash.display.Sprite;

	/**
	 * @author 1
	 */
	public class move extends Sprite {
		private var btn:GButton;
		private var list:listmove;
		public function move() {
			var data:GButtonData = new GButtonData();
			data.x = 100;
			data.y = 5;
			data.labelData.text = "删除测试";
			btn = new GButton(data);
			this.addChild(btn);
			list = new listmove();
			list.y = 20;
			this.addChild(list);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, ondwon);
		}

		private function ondwon(event : MouseEvent) : void {
			this.removeChild(list);
		}
	}
}
