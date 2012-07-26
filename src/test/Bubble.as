package test
{
	import flash.display.Shape;

	/**
	 * @author jian
	 */
	public class Bubble extends Shape
	{
		public function Bubble()
		{
			graphics.beginFill(Math.random() * 0xFFFFFF);
			graphics.drawCircle(10, 10, 10);
			graphics.endFill();
		}
	}
}
