package test
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jian
	 */
	public class TestBitmapScroll extends Sprite
	{
		public var myBitmapDataObject : BitmapData;

		public function TestBitmapScroll()
		{
			myBitmapDataObject = new BitmapData(1000, 1000, false, 0x00FF0000);
			var seed : Number = Math.floor(Math.random() * 100);
			var channels : uint = BitmapDataChannel.GREEN | BitmapDataChannel.BLUE;
			myBitmapDataObject.perlinNoise(100, 80, 6, seed, false, true, channels, false, null);
			var myBitmap : Bitmap = new Bitmap(myBitmapDataObject);
			myBitmap.x = -750;
			myBitmap.y = -750;
			addChild(myBitmap);
			addEventListener(Event.ENTER_FRAME, scrollBitmap);
		}

		public function scrollBitmap(event : Event) : void
		{
			myBitmapDataObject.scroll(1, 1);
		}
	}
}
