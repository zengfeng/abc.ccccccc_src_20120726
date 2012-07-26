package game.module.battle
{
	public class ForRand
	{
		public function ForRand()
		{
		}
		
		public static function gRand(x:int):int
		{
			var hi:int;
			var lo:int;
			if (x == 0)
				x = 123459876;
			hi = x / 127773;
			lo = x % 127773;
			x = 16807 * lo - 2836 * hi;
			if (x < 0)
				x += 0x7FFFFFFF;
			return x;
		}
		public static function getRand(modulo:uint = 10000):uint
		{
			_randNmber = gRand(_randNmber);
			return _randNmber%modulo;
		}
		
		public static function setRandSeed(seed:uint):void 
		{
			_randNmber = seed;
		}
		
		public static function getRandNumber():uint 
		{
			return _randNmber;
		}
		private static  var _randNmber:uint;
	}
}