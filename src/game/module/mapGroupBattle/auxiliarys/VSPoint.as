package game.module.mapGroupBattle.auxiliarys
{
	import game.module.mapGroupBattle.GBConfig;
	import flash.geom.Point;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-3
	 */
	public class VSPoint
	{
		public var points : Points;

		function VSPoint(x : int = 10, y : int = 10, lineLength : int = 500) : void
		{
			points = new Points(x, y, lineLength);
		}

		public function reset() : void
		{
			initCountA = 0;
			initCountB = 0;
			points.reset();
		}

		private var initCountA : int = 0;
		private var initCountB : int = 0;

		public function getInitPoint(groupAB : int) : Point
		{
			var point : Point;
			if (groupAB == GBConfig.GROUP_ID_A)
			{
				point = points.getPointByIndex(initCountA);
				initCountA++;
			}
			else
			{
				point = points.getPointByIndex(initCountB);
				initCountB++;
			}
			return point;
		}

		public function getPoint() : Point
		{
			return points.getPoint();
		}
	}
}
