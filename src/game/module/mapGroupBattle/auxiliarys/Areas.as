package game.module.mapGroupBattle.auxiliarys
{
	import game.module.mapGroupBattle.GBConfig;

	import flash.geom.Point;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-2
	 */
	public class Areas
	{
		public static var centerX:int = 1938;
		public static var centerY:int = 780;
		private static var aArea : Ellipse = new Ellipse(222, 120, 1110, 1200);
		private static var bArea : Ellipse = new Ellipse(222, 120, 2760, 1200);
		private static var vsArea : Ellipse = new Ellipse(472, 250, 1938, 780);
		private static var vsPoint : VSPoint = new VSPoint(vsArea.centerX, vsArea.centerY - vsArea.radiusY + 20, vsArea.radiusY * 2 - 40);
		private static var vsInnerRadiuX : int = 300;

		public static function  reset() : void
		{
			vsPoint.reset();
		}

		public static function getRandom(statusId : int, groupAB : int) : Point
		{
			var point : Point;
			switch(statusId)
			{
				case Status.DIE:
					point = getRandomBirth(groupAB);
					break;
				case Status.VS:
					point = vsPoint.getInitPoint(groupAB);
					break;
				case Status.WAIT:
				case Status.REST:
				case Status.MOVE:
				default:
					point = getRandomRestPoint(groupAB);
					break;
			}
			return point;
		}

		// ==================
		// 出生区块
		// ==================
		public static function isBirth(x : int, y : int, groupAB : int) : Boolean
		{
			if (groupAB == GBConfig.GROUP_ID_A)
			{
				return aArea.isInArea(x, y);
			}
			else
			{
				return bArea.isInArea(x, y);
			}
		}

		public static function getRandomBirth(groupAB : int) : Point
		{
			if (groupAB == GBConfig.GROUP_ID_A)
			{
				return aArea.getRandomAreaPoint();
			}
			else
			{
				return bArea.getRandomAreaPoint();
			}
		}

		// ==================
		// 休息&等待区块
		// ==================
		public static function isRest(x : int, y : int) : Boolean
		{
			var isIn : Boolean = vsArea.isInArea(x, y);
			if (isIn == false)
			{
				return false;
			}

			isIn = x <= 1836 || x >= 2019;
			return isIn;
		}

		public static function getRandomRestPoint(groupAB : int) : Point
		{
			var minAngle : Number;
			var maxAngle : Number;
			var centerX : int = vsArea.centerX;
			var radiusX : int = vsArea.radiusX;
			var radiusY : Number = Math.random() * vsArea.radiusY;
			if (groupAB == GBConfig.GROUP_ID_A)
			{
				minAngle = 0.5 * Math.PI;
				maxAngle = 1.5 * Math.PI;
				centerX -= vsInnerRadiuX;
			}
			else
			{
				minAngle = -0.5 * Math.PI;
				maxAngle = 0.5 * Math.PI;
				centerX += vsInnerRadiuX;
			}
			radiusX -= vsInnerRadiuX;
			radiusX = Math.random() * radiusX;
			var angle : Number;
			angle = minAngle + Math.random() * (maxAngle - minAngle);
			var point : Point = new Point();
			point.x = centerX + Math.cos(angle) * radiusX;
			point.y = vsArea.centerY + Math.sin(angle) * radiusY;
			return point;
		}

		// ==================
		// PK区块
		// ==================
		public static function isVS(x : int, y : int) : Boolean
		{
			var isIn : Boolean = vsArea.isInArea(x, y);
			if (isIn == false)
			{
				return false;
			}
			return x > 1836 && x < 2019;
		}

		public static function getVSPoint() : Point
		{
			return vsPoint.getPoint();
		}
	}
}
