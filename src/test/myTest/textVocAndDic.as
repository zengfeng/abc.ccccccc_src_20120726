package test.myTest
{
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;

	import com.greensock.layout.AlignMode;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * @author Lv
	 */
	public class textVocAndDic extends Sprite {
		private var dic:Dictionary = new Dictionary();
		private var vec:Vector.<Object> = new Vector.<Object>();
		private var text:TextField = new TextField();
		public function textVocAndDic() {
			setText();
			for(var i:int = 0; i< 10;i ++){
				var obj:Object = new Object();
				obj.name = i;
				vec.push(obj);
				dic[i] =obj;
				//trace(vec[i].name);
			}
			
			var data:GButtonData = new GButtonData();
			data.x = 100;
			data.y = 50;
			data.labelData.text = "text";
			var btn:GButton = new GButton(data);
			addChild(btn);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, ondow);
			
			
		}
		private var txt:TextField;
		private function setText() : void {
			var data:GLabelData = new GLabelData();
			data.width = 150;
			data.text = "13231";
			data.textFormat.size = 14;
			data.textColor = 0x000000;
//			data.align = AlignMode.CENTER;
			var text:GLabel = new GLabel(data);
			this.addChild(text);
			
			txt = new TextField();
			txt.text = "121212";
			txt.y = 30;
			txt.width = 50;
			txt.border = true;
			txt.setTextFormat(new TextFormat("12",null,0x000000,1,null,null,null,null,AlignMode.CENTER));
			this.addChild(txt);
		}

		private function ondow(event : MouseEvent) : void {
			vec.sort(func);
			var str:String;
			for(var i:int = 0 ; i< vec.length ;i++){
				//trace(vec[i].name);
				str += String(vec[i].name);
			}
			txt.text =str;
		}
		private function func(a:Object,b:Object):Number{
			return -a.name + b.name;
		}
	}
}
