package test {
	import worlds.auxiliarys.loads.core.LoaderEvent;
	import worlds.auxiliarys.loads.expands.PathLoader;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-11
	*/
	public class TestMyPathLoader extends Sprite
	{
		public function TestMyPathLoader()
		{
			PathLoader.instance.mapId = 201;
			PathLoader.instance.addEventListener(LoaderEvent.COMPLETE, ontComplete);
			PathLoader.instance.generateLoader().load();
		}

		private function ontComplete(event : LoaderEvent) : void
		{
			var ba : ByteArray = PathLoader.instance.getData();

			var width : int = ba.readInt() ;
			var height : int = ba.readInt() ;
			trace(width, height);
			var tileData : Vector.<uint> = new Vector.<uint> ;
			while ( ba.position < ba.length )
			{
				var b : int = ba.readByte() ;
				b = b >= 0 ? b : ((-1 ^ b) ^ 0xFF) ;

				var rep : int = ba.readByte() ;
				rep = rep >= 0 ? rep : ((-1 ^ rep) ^ 0xFF) ;

				for ( var i : int = 0 ; i < rep ; ++i )
				{
					tileData.push(b);
				}
			}
			
			var byteArray:ByteArray = new ByteArray();
			var length:int = tileData.length;
			for(i = 0; i < length; i++)
			{
				byteArray.writeInt(tileData[i]);
			}

			var bitmapData : BitmapData = new BitmapData(width, height, true, 0xFFFF0000);
			var pathX : int;
			var pathY : int;
			var color : int;
			var oldY : int;
			var arr : Array = [];
			for (i = 0; i < tileData.length; i++)
			{
				pathY = int(i / (width));
				pathX = i - pathY * width;
				color = tileData[i];
				if (arr.indexOf(color) == -1)
				{
					arr.push(color);
				}
				switch(color)
				{
					case 0:
						color = 0xFF000000;
						break;
					case 255:
						color = 0xFFFFFFFF; 
						break;
					case 1:
						color = 0xFFFF0000;
						break;
					case 2:
						color = 0xFFFFFF00;
						break;
					case 3:
						color = 0xFF00FF00;
						break;
				}
				bitmapData.setPixel32(pathX, pathY, color);
				if (oldY != pathY)
				{
					oldY = pathY;
				}
			}
			trace("WH", width, height);

			while (arr.length > 0)
			{
				trace(arr.shift());
			}
			var bitmap : Bitmap = new Bitmap();
			bitmap.bitmapData = bitmapData;
			addChild(bitmap);
		}
	}
}
