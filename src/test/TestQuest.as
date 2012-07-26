package test
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import project.Game;

	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	/**
	 * @author yangyiqiang
	 */
	public class TestQuest extends Game
	{
		private var square : Shape = new Shape();
		
		private var bitMapData:BitmapData;
		private var bitMap:Bitmap;

		override protected function initGame() : void
		{
			square.graphics.lineStyle(20, 0xFFCC00);
			var gradientMatrix : Matrix = new Matrix();
			gradientMatrix.createGradientBox(15, 15, Math.PI, 10, 10);
			square.graphics.beginGradientFill(GradientType.RADIAL, [0xffff00, 0x0000ff], [100, 100], [0, 0xFF], gradientMatrix, SpreadMethod.REFLECT, InterpolationMethod.RGB, 0.9);
			square.graphics.drawRect(0, 0, 100, 100);
			var grid : Rectangle = new Rectangle(20, 20, 60, 60);
			square.scale9Grid = grid ;
//			addChild(square);
			bitMapData=new BitmapData(square.width, square.height);
			bitMapData.draw(square);
			bitMap=new Bitmap(bitMapData);
			bitMap.cacheAsBitmap=true;
			bitMap.scale9Grid=grid;
			addChild(bitMap);
			var tim : Timer = new Timer(100);
			tim.start();
			tim.addEventListener(TimerEvent.TIMER, scale);
		}
		private var scaleFactor : Number = 1.01;
		function scale(event : TimerEvent) : void
		{
			bitMap.scaleX *= scaleFactor;
			bitMap.scaleY *= scaleFactor;

			if (bitMap.scaleX > 2.0)
			{
				scaleFactor = 0.99;
			}
			if (bitMap.scaleX < 1.0)
			{
				scaleFactor = 1.01;
			}
		}

		public function TestQuest()
		{
			super();
		}
	}
}
