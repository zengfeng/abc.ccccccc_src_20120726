package test
{
	import flash.display.Sprite;
	import flash.text.TextField;

	import test.Bubble;

	/**
	 * @author jian
	 */
	public class TestTextFieldImgTag extends Sprite
	{
		
		private var tf : TextField;

		public function TestTextFieldImgTag()
		{
			var bubble:Bubble = new Bubble();
			
			tf = new TextField();
			tf.htmlText = "测试<img id='bubb' src='test.Bubble' width='10' height='10' />你好！！";
			tf.x = 50;
			tf.y = 50;
			addChild(tf);
		}
	}
	
}
