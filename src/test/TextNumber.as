package test
{
	import flash.display.Sprite;

	/**
	 * @author jian
	 */
	public class TextNumber extends Sprite
	{
		public function TextNumber()
		{
			var n:Number = 0;
			for (var i:int = 0; i < 11; i++)
			{
				//trace(n);
				n += 0.1;
			}
		}
	}
}
