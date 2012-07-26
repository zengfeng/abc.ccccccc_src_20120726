/**
 *沙盘
 *Battle Field Grid indexes:
defender: 9 8 7 6 5
          4 3 2 1 0
attacker: 0 1 2 3 4
          5 6 7 8 9 
 */
package game.module.battle
{

	public class BattleField
	{
		public function BattleField()
		{
			var i : int;
			for (i = 0; i < 2; ++i)
			{
				_objs[i] = [];
			}

			for (i = 0; i < 2; ++i)
			{
				for (var j : int = 0; j < 25; ++j)
				{
					_objs[i].push(null);
				}
			}
		}

		public function clear() : void
		{
		}

		public function reset() : void
		{
		}

		public function setObject(side:int, idx:int, obj:BattleFighter):void
		{
			if(idx >= 25) return;
			_objs[side][idx] = obj;
		}

		public function setFormation(idx : int, side : int) : void          // 设置阵型
		{
		}

		public function getObjectXY(side : int, x : int, y : int) : BattleFighter
		{
			return _objs[side][x + y * 5];
		}

		public function getPossibleTarget(side : int, idx : int) : int              // 获取攻击目标
		{
			var select_table : Array = [[0, 1, 2, 3, 4], [1, 0, 2, 3, 4], [2, 1, 3, 0, 4], [3, 2, 4, 1, 0], [4, 3, 2, 1, 0]];

			var targetidx : int = 4 - (idx % 5);
			var tside : int = 1 - side;
			var tbl : Array = select_table[targetidx];
			for (var i : int = 0; i < 5; i++)
			{
				for (var j : int = 0; j < 5; j++)
				{
					var tidx : int = tbl[j] + i * 5;
					if (_objs[tside][tidx] != null && _objs[tside][tidx].getHP() > 0 )
					{
						return tidx;
					}
				}
			}
			return -1;
		}

		public function getAliveCount(side : int) : int
		{
			var aliveC : uint = 0;
			for (var i : int = 0; i < 25; ++i)
			{
				var obj : BattleFighter = _objs[side][i];
				if (obj != null && obj.getHP() > 0)
				{
					++aliveC;
				}
			}
			return aliveC;
		}

		public function getObjHp(side : int) : uint
		{
			var allHp : uint = 0;
			for (var i : int = 0; i < 25; ++i)
			{
				var bft : BattleFighter = _objs[side][i];
				if (bft != null)
				{
					allHp += bft.getHP();
				}
			}
			return allHp;
		}

		protected function anyObjectInRow(side : int, row : int) : Boolean
		{
			var start : int = row * 5;
			var end : int = start + 5;
			for (var i : int = start; i < end; ++i)
			{
				if (_objs[side][i] != null && _objs[side][i].getHP() > 0)
				{
					return true;
				}
			}

			return false;
		}

		public function updateStatusA(side : int) : void
		{
			for (var i : int = 0; i < 2; ++i)
			{
				for (var j : int = 0; j < 25; ++j)
				{
					var bfighter : BattleFighter = _objs[side][j];
					if (bfighter)
					{
						bfighter.updateAllAttr();
						// 设置为初始状态
					}
				}
			}
		}

		public function updateStatusB(side : int, pos : int) : void
		{
			if (_objs[side][pos])
			{
				var bfighter : BattleFighter = _objs[side][pos];
				bfighter.updateAllAttr();
			}
		}

		protected var _objs : Array = [];
	}
}