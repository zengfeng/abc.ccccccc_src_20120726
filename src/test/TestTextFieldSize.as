package test
{


	import project.Game;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * @author jian
	 */
	public class TestTextFieldSize extends Game
	{
		public function TestTextFieldSize()
		{
			super();
			
			addTextField();
			addTextField2();
		}
		
		private function addTextField():void
		{
			var tf:TextField = new TextField();
			tf.y = 50;
			tf.x = 50;
			var textformat:TextFormat = new TextFormat();
			textformat.size = 12;
			textformat.leading = 4;
			textformat.font = "华文黑体";
			tf.defaultTextFormat = textformat;

			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.text = "1";
//			tf.scrollRect = new Rectangle(0, 0, tf.textWidth, tf.textHeight);
			addChild(tf);
			
			graphics.lineStyle(1);
//			graphics.drawRect(tf.x, tf.y, tf.width, tf.height);		
//			graphics.drawRect(tf.x + 2, tf.y + 2, tf.textWidth, tf.textHeight);
			
			tf.text = "中文\r中文\r中文\r中文\r中文";
			tf.autoSize = TextFieldAutoSize.LEFT;
//			graphics.drawRect(tf.x, tf.y, tf.width, tf.height);		
//			graphics.drawRect(tf.x + 2, tf.y + 2, tf.textWidth, tf.textHeight);
//			var bubble:RemindBubble = new RemindBubble();
//			bubble.text = "1";
//			addChild(bubble);

			
		}
		
				private function addTextField2():void
		{
			var tf:TextField = new TextField();
			tf.y = 50;
			tf.x = 120;
			var textformat:TextFormat = new TextFormat();
			textformat.size = 12;
			textformat.leading = 4;
			textformat.font = "宋体";
			tf.defaultTextFormat = textformat;

			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.text = "1";
//			tf.scrollRect = new Rectangle(0, 0, tf.textWidth, tf.textHeight);
			addChild(tf);
			
			graphics.lineStyle(1);
//			graphics.drawRect(tf.x, tf.y, tf.width, tf.height);		
//			graphics.drawRect(tf.x + 2, tf.y + 2, tf.textWidth, tf.textHeight);
			
			tf.text = "中文\r中文\r中文\r中文\r中文";
			tf.autoSize = TextFieldAutoSize.LEFT;
//			graphics.drawRect(tf.x, tf.y, tf.width, tf.height);		
//			graphics.drawRect(tf.x + 2, tf.y + 2, tf.textWidth, tf.textHeight);
//			var bubble:RemindBubble = new RemindBubble();
//			bubble.text = "1";
//			addChild(bubble);

			
		}
	}
}
