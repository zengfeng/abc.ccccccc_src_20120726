package test
{
	import worlds.auxiliarys.Path;
	import com.utils.Vector2D;

	import flash.display.Sprite;
	import flash.utils.ByteArray;
	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-19
	*/
	public class TestPath extends Sprite
	{
		private var path:Path;
		function TestPath():void
		{
			var byteArray:ByteArray;
			path = new Path();
			path.reset(byteArray);
			path.signalWriteComplete.add(signalWriteComplete);
		}
		
		public function find(mapFromX : int, mapFromY : int, mapToX : int, mapToY : int, pushList : Vector.<Vector2D> = null):void
		{
			
		}
		
		public function signalWriteComplete():void
		{
			path.setBarrier(255, true);
		}
	}
}
