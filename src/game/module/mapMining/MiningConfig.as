package game.module.mapMining
{
	import flash.utils.Dictionary;

	/**
	 * @author jian
	 */
	public class MiningConfig
	{
		// 每日免费次数
		private var _freeTimes : int;
		// 元宝采矿花费的数目
		private var _goldMiningCost : int;
		// 采矿位置列表
		private var _seats : Array /* of MiningSeat */;
		// 晶石NPC特效相对位置
		private var _flameOffset : Dictionary;

		public function get freeTimes() : int
		{
			return _freeTimes;
		}

		public function get goldMiningCost() : int
		{
			return _goldMiningCost;
		}

		public function get seats() : Array
		{
			return _seats;
		}

		public function MiningConfig(freeTimes : int, goldMiningCost : int, seats : Array)
		{
			_freeTimes = freeTimes;
			_goldMiningCost = goldMiningCost;
			_seats = seats;
		}
	}
}
