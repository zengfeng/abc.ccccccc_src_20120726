package game.module.mapMining
{
	import utils.DictionaryUtil;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * @author jian
	 */
	public class MiningUtils
	{
		public static var BATCH_TIMES : int = 12;
		public static var MAP_ID : int = 44;
		public static var GOLD_COST : int = 40;
		public static var VIP_LEVEL : int = 1;
		public static var BATCH_LEVEL : int = 6;
		public static var donkeyId : int = 3008;
		
		private static var _stones : Dictionary = new Dictionary();

		public static function addStone(stoneId : int, flameX : Number, flameY : Number) : void
		{
			_stones[stoneId] = new Point(flameX, flameY);
		}

		public static function getFlameOffset(stoneId : int) : Point
		{
			return _stones[stoneId];
		}

		public static function isStoneNpc(npcId : int) : Boolean
		{
			return _stones[npcId] != null;
		}

		public static function getStones() : Array
		{
			return DictionaryUtil.getKeys(_stones);
		}
	}
}


