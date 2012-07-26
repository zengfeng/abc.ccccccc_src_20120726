package worlds.test
{
	import worlds.auxiliarys.PointShape;
	import worlds.maps.layers.RoleLayer;
	import flash.display.Sprite;
	import worlds.auxiliarys.MapPoint;
	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-25
	*/
	public class TestShowPathPoint
	{
		
		/** 单例对像 */
		private static var _instance : TestShowPathPoint;

		/** 获取单例对像 */
		public static  function get instance() : TestShowPathPoint
		{
			if (_instance == null)
			{
				_instance = new TestShowPathPoint(new Singleton());
			}
			return _instance;
		}
		private var layer:Sprite;
		function TestShowPathPoint(Singleton:Singleton):void
		{
			layer = RoleLayer.instance;
		}
		
		public var shapeList:Vector.<PointShape> = new Vector.<PointShape>();
		public function clear():void
		{
			var shape:PointShape;
			for(var i:int = 0; i < shapeList.length; i++)
			{
				shape = shapeList[i];
				if(shape.parent)	shape.parent.removeChild(shape);
			}
		}
		public function getShape(i:int):PointShape
		{
			if(i < shapeList.length)
			{
				return shapeList[i];
			}
			var shape:PointShape = new PointShape();
			shapeList.push(shape);
			return shape;
		}
		public function show(path:Vector.<MapPoint>):void
		{
			clear();
			var point:MapPoint;
			var shape:PointShape;
			for(var i:int = 0; i < path.length; i ++)
			{
				point = path[i];
				shape = getShape(i);
				shape.x = point.x;
				shape.y = point.y;
				layer.addChild(shape);
			}
		}
		
		
	}
}
class Singleton{}