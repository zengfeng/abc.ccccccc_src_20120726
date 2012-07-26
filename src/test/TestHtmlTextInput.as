package test
{
	import flash.display.Sprite;
	import project.Game;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * @author jian
	 */
	public class TestHtmlTextInput extends Game
	{
		private var tf:TextField;
		private var tf2:TextField;
		
		public function TestHtmlTextInput()
		{
			super();
			
			addTextInput();
		}
		
		private function addTextInput():void
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xFF0000);
			sp.graphics.drawCircle(5, 5, 5);
			
			tf = new TextField();
			tf.type = TextFieldType.INPUT;
			tf.width = 400;
			tf.height = 400;
			tf.htmlText = "<font color='#FF0000'><a href='event:0001'>你好</a></font>正常文字";
			tf.htmlText += "<img width='20' height='20' src='"+sp.name+"'/>";
			tf.htmlText += "傻瓜";
			addChild(tf);
			tf.addEventListener(Event.CHANGE, inputChangeHandler);
			
			tf2 = new TextField();
			tf2.text = tf.htmlText;
			tf2.y = 200;
			tf2.width = 800;
			addChild(tf2);
		}
		
		private function inputChangeHandler(event:Event):void
		{
			tf2.text = tf.htmlText;
		}
	}
}
