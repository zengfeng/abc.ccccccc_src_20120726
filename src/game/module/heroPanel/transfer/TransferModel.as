package game.module.heroPanel.transfer
{
	import game.core.item.equipment.Equipment;
	import game.core.item.prop.ItemPropManager;
	import game.definition.ID;

	/**
	 * @author verycd
	 */
	public class TransferModel
	{
		// =====================
		// 定义
		// =====================
		public static const MODE_INVALID : uint = 0;
		public static const MODE_TRANSFER : uint = 1;
		public static const MODE_EQUIP : uint = 2;
		// =====================
		// 属性
		// =====================
		private var _source : Equipment;
		private var _target : Equipment;
		private var _costID : uint;
		private var _costNums : uint;

		// =====================
		// Setter/Getter
		// =====================
		public function setSourceTarget(source : Equipment, target : Equipment) : void
		{
			_source = source;
			_target = target;
			calculateCost();
		}

		public function get source() : Equipment
		{
			return _source;
		}

		public function get target() : Equipment
		{
			return _target;
		}

		public function get sourceCurrentLevel() : uint
		{
			return _source.enhanceLevel;
		}

		public function get targetCurrentLevel() : uint
		{
			return _target.enhanceLevel;
		}

		public function get sourceCurrentValue() : uint
		{
			return _source.enhanceValue;
		}

		public function get targetCurrentValue() : uint
		{
			return _target.enhanceLevel;
		}

		public function get sourceName() : String
		{
			return (_source) ? _source.name : "可转移的装备";
		}

		public function get targetName() : String
		{
			return (_target) ? _target.name : "接受转移的装备";
		}

		public function get costID() : uint
		{
			return _costID;
		}

		public function get costNums() : uint
		{
			return _costNums;
		}

		public function get mode() : uint
		{
			if (_source && _target)
			{
				if (_source.enhanceLevel > _target.enhanceLevel)
					return MODE_TRANSFER;
				else
					return MODE_EQUIP;
			}
			else
			{
				return MODE_INVALID;
			}
		}

		// =====================
		// 方法
		// =====================
		private function calculateCost() : void
		{
			if (mode != TransferModel.MODE_TRANSFER)
			{
				_costID = 0;
				_costNums = 0;
			}
			else if (_source)
			{
				var level : uint = _source.enhanceLevel;
				if (level == 1)
				{
					_costID = ID.SILVER;
					_costNums = 500;
				}
				else if (level == 2)
				{
					_costID = ID.SILVER;
					_costNums = 1000;
				}
				else if (level == 3)
				{
					_costID = ID.SILVER;
					_costNums = 2000;
				}
				else if (level == 4)
				{
					_costID = ID.SILVER;
					_costNums = 3000;
				}
				else if (level == 5)
				{
					_costID = ID.SILVER;
					_costNums = 4000;
				}
				else if (level == 6)
				{
					_costID = ID.SILVER;
					_costNums = 5000;
				}
				else if (level == 7)
				{
					_costID = ID.TRANSFER_STONE;
					_costNums = 1;
				}
				else if (level == 8)
				{
					_costID = ID.TRANSFER_STONE;
					_costNums = 1;
				}
				else if (level == 9)
				{
					_costID = ID.TRANSFER_STONE;
					_costNums = 2;
				}
				else if (level == 10)
				{
					_costID = ID.TRANSFER_STONE;
					_costNums = 2;
				}
				else if (level == 11)
				{
					_costID = ID.TRANSFER_STONE;
					_costNums = 3;
				}
				else if (level == 12)
				{
					_costID = ID.TRANSFER_STONE;
					_costNums = 3;
				}
				else if (level == 13)
				{
					_costID = ID.TRANSFER_STONE;
					_costNums = 4;
				}
				else if (level == 14)
				{
					_costID = ID.TRANSFER_STONE;
					_costNums = 4;
				}
				else
				{
					trace("替换花费计算错误！");
				}
			}
			else
			{
				_costID = 0;
				_costNums = 0;
			}
		}
	}
}
