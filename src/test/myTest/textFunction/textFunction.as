package test.myTest.textFunction {
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.controls.GLabel;
	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	 [SWF(backgroundColor="#FFFFFF", frameRate="30", width="640", height="480")]
	public class textFunction extends Sprite {
		private var text:GLabel;
		private var cursor:Sprite = new Sprite();
		public function textFunction() {
  			cursor.graphics.beginFill(0x000000); 
			cursor.graphics.drawCircle(0,0,20); 
 			cursor.graphics.endFill(); 
 			
 			stage.addEventListener(MouseEvent.MOUSE_MOVE,redrawCursor); 
 			Mouse.hide(); 
			
			var data:GLabelData = new GLabelData();
			data.width = 400;
			data.x = 50;
			data.y = 50;
			text = new GLabel(data);
			this.addChild(text);
			setString();
			var databtn:GButtonData = new GButtonData();
			databtn.x = 50;
			databtn.y = 150;
			databtn.labelData.text = "select";
			var btn:GButton = new GButton(databtn);
			this.addChild(btn);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, ondown);
			
			
			addChild(cursor); 
		}

		private function redrawCursor(event : MouseEvent) : void {
			 cursor.x = event.stageX; 
 			cursor.y = event.stageY; 
		}

		private function ondown(event : MouseEvent) : void {
			str = "changeVaule";
			setString();
		}

		private function setString() : void {
//			text.text = textFun("我是String型");
			text.text = textFun(changeText);
//			text.text = textFun(700);
		}
		private function textFun(fun:* = null):String{
			var str:String;
			if(fun is Function)
				str = fun() + "    +Function（成功）";
			if(fun is String)
				str = fun + "    +String（成功）";
			if(fun is int)
				str = fun + "   +int（成功）";
			return str;
		}
		private var str:String = "传值啦";
		private function changeText():String{
			return str +" 我是 Function 哦";
		}
	}
}
