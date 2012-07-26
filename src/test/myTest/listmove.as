package test.myTest {
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import gameui.data.GButtonData;
	import gameui.controls.GButton;
	import flash.display.Sprite;

	/**
	 * @author 1
	 */
	public class listmove extends Sprite {
		private var btn:GButton;
		private var btn2:GButton;
		private var btn3:GButton;
		private var btn4:GButton;
		private var btn5:GButton;
		private var btn6:GButton;
		public function listmove() {
			var data:GButtonData = new GButtonData();
			data.x = 20;
			data.y = 100;
			data.labelData.text = "测试1";
			btn = new GButton(data);
			this.addChild(btn);
			data.clone();
			data.y = 55;
			data.x = 50;
			data.labelData.text = "点击";
			var textBtn:GButton = new GButton(data);
			textBtn.buttonMode = true;
			this.addChild(textBtn);
			textBtn.addEventListener(MouseEvent.MOUSE_DOWN, ondwon);
			
			data.clone();
			data.x = 20;
			data.y = 125;
			data.labelData.text = "测试2";
			btn2 = new GButton(data);
			this.addChild(btn2);
			
			data.clone();
			data.x = 20;
			data.y = 150;
			data.labelData.text = "测试3";
			btn3 = new GButton(data);
			this.addChild(btn3);
			
			data.clone();
			data.x = 20;
			data.y = 175;
			data.labelData.text = "测试4";
			btn4 = new GButton(data);
			this.addChild(btn4);
			
			data.clone();
			data.x = 20;
			data.y = 200;
			data.labelData.text = "测试5";
			btn5 = new GButton(data);
			this.addChild(btn5);
			
			data.clone();
			data.x = 20;
			data.y = 225;
			data.labelData.text = "测试6";
			btn6 = new GButton(data);
			this.addChild(btn6);
		}
		private var index:int = 0;
		private function ondwon(event : MouseEvent) : void {
			setMove(index);
		}
		private function setMove(index : int) : void {
			TweenLite.to(btn,0.9,{x:this.btn.x +30, alpha:1, overwrite:0,onComplete:ShowHarmComplete_func});
			TweenLite.to(btn2,0.8,{x:this.btn2.x +30, alpha:1, overwrite:0});
			TweenLite.to(btn3,0.8,{x:this.btn3.x +30, alpha:1, overwrite:0});
			TweenLite.to(btn4,0.8,{x:this.btn4.x +30, alpha:1, overwrite:0});
			TweenLite.to(btn5,0.8,{x:this.btn5.x +30, alpha:1, overwrite:0});
			TweenLite.to(btn6,0.8,{x:this.btn6.x +30, alpha:1, overwrite:0});
		}
		
		private function ShowHarmComplete_func():void{
			if(btn.x > 400){
				btn.x = 20;
				btn2.x = 20;
				btn3.x = 20;
				btn4.x = 20;
				btn5.x = 20;
				btn6.x = 20;
				setMove(index);
			}
//			setMove(index);
		}
		public function hid():void{
			
		}
	}
}
