package game.module.mapGroupBattle.auxiliarys
{
	import flash.geom.Point;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-16 ����2:25:02
	 * 椭圆
	 * 椭圆公式        
	 * ball.x = centerX + Math.cos(angle) * radiusX;
	 * ball.y = centerY + Math.sin(angle) * radiusY;
	 * angle += drawSpeed;
	 */
	public class Ellipse
	{
		public var centerX : int = 0;
		public var centerY : int = 0;
		public var radiusX : int = 100;
		public var radiusY : int = 50;
		public var angle : Number = 0;
		public var drawSpeed : Number = 0.1;

		function Ellipse(radiusX : int = 100, radiusY : int = 50, centerX : int = 0, centerY : int = 0) : void
		{
			this.radiusX = radiusX;
			this.radiusY = radiusY;
			this.centerX = centerX;
			this.centerY = centerY;
		}

		/** 随机获得面积内的点 */
		public function getRandomAreaPoint() : Point
		{
			var point : Point = new Point();
			var angle : Number = Math.random() * 2 * Math.PI;
			var radiusX : Number = Math.random() * this.radiusX;
			var radiusY : Number = Math.random() * this.radiusY;
			point.x = centerX + Math.cos(angle) * radiusX;
			point.y = centerY + Math.sin(angle) * radiusY;
			return point;
		}

		/** 判断这个点是否在面积区域内 */
		public function isInArea(x : int, y : int) : Boolean
		{
			var dx : Number = x - centerX;
			var dy : Number = y - centerY;
			var angle : Number = Math.atan2(dy, dx);
			var radiusX : Number = dx / Math.cos(angle);
			var radiusY : Number = dy / Math.cos(angle);
			if (radiusX <= this.radiusX && radiusY <= this.radiusY)
			{
				return true;
			}
			return false;
		}
	}
}
