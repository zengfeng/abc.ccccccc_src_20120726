package game.module.mapMining.pool
{
	import flash.utils.Dictionary;

	/**
	 * @author jian
	 */
	public class MiningPool
	{
		// 座位
		private var _seatDict : Dictionary;

		public function MiningPool(seats : Array/* of MiningSeats */)
		{
			// 初始化座位查找表
			_seatDict = new Dictionary();

			for each (var seat:MiningSeat in seats)
			{
				_seatDict[seat.seatId] = seat;
			}
		}

		// 取座位
		public function takeSeat() : MiningSeat
		{
			var minSeat : MiningSeat;
			for each (var seat:MiningSeat in _seatDict)
			{
				if (!minSeat || minSeat.playerNums > seat.playerNums)
					minSeat = seat;
			}

			if (minSeat)
				minSeat.playerNums++;
			else
				throw(Error("矿场没有空位！"));

			return minSeat;
		}
		
		// 坐下
		public function sitDown(seatId:int):void
		{
			var seat:MiningSeat = _seatDict[seatId];
			
			if (seat)
				seat.playerNums++;
		}

		// 还座位
		public function returnSeat(seatId : int) : void
		{
			var theSeat : MiningSeat = _seatDict[seatId];

			if (theSeat)
			{
				theSeat.playerNums--;
			}
		}
		
		// 清除
		public function clear():void
		{
			for each (var seat:MiningSeat in _seatDict)
			{
				seat.playerNums = 0;
			}
		}
	}
}
