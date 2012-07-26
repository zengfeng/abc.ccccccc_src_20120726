package game.module.mapGroupBattle.auxiliarys
{
	import flash.geom.Point;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-3
	 */
	public class Points
	{
		public var x : int;
		public var y : int;
		public var lineLength : int;
		public var count : int;
		public var list : Vector.<Point> = new Vector.<Point>();
		private var part : Array = [16, 0, 32, 8, 24, 4, 18, 12, 20, 2, 30, 14, 18, 6, 26, 10, 22, 1, 15, 31, 5, 21, 13, 27, 3, 17, 11, 23, 29, 9, 19, 25, 7];

		function Points(x : int = 10, y : int = 10, lineLength : int = 500) : void
		{
			this.x = x;
			this.y = y;
			this.lineLength = lineLength;
			generatePoints();
		}

		public function reset() : void
		{
			index = -1;
		}

		private function generatePoints() : void
		{
			this.count = 33;
			var gap : int = lineLength / count;
			var point : Point;
			for (var i : int = 0; i < count; i++)
			{
				point = new Point(x, y + part[i] * gap);
				list.push(point);
			}
		}

		private var index : int = -1;

		public function getPoint() : Point
		{
			index++;
			if (index >= count ) index = 0;
			return list[index];
		}

		public function getPointByIndex(index : int) : Point
		{
			index = index % count;
			this.index = Math.max(this.index, index);
			if (this.index >= 32) this.index = 0;
			return list[index];
		}
	}
}