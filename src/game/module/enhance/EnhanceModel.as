package game.module.enhance
{
	import flash.events.EventDispatcher;
	import game.core.item.ItemManager;
	import game.core.item.equipment.Equipment;
	import game.core.item.sutra.Sutra;
	import game.core.user.UserData;
	import game.definition.ID;
	import log4a.Logger;



	/**
	 * @author verycd
	 */
	public class EnhanceModel extends EventDispatcher
	{
		// =====================
		// 属性
		// =====================
		// 待强化装备
		private var _item : Equipment;
		// 当前强化等级
		private var _currentLevel : uint;
		// 手动强化等级
		private var _targetLevel : uint;
		// 自动强化目标等级
		private var _autoTargetLevel : uint;
		// 允许最大强化等级
		private var _maxLevel : uint;
		// 强化消耗
		private var _costSilver : uint;
		private var _costStone : uint;
		private var _costStoneID : uint;
		// 强化规则
		private static var _ruleManager : EnhanceRuleManager;

		// =====================
		// Getter/Setter
		// =====================
		public function set item(value : Equipment) : void
		{
			_item = value;

			if (value)
				updateItem();
			else
				clearItem();
		}

		public function get item() : Equipment
		{
			return _item;
		}

		public function get targetLevel() : uint
		{
			return _targetLevel;
		}

		public function get maxLevel() : uint
		{
			return _maxLevel;
		}

		public function get hitLimit() : Boolean
		{
			return _item && _currentLevel == _maxLevel;
		}

		public function get autoTargetLevel() : uint
		{
			return _autoTargetLevel;
		}

		public function get isEquiped() : Boolean
		{
			return (_item is Sutra) || _item.isEquipped ;
		}

		public function get costSilver() : uint
		{
			return _costSilver;
		}

		public function get costStone() : uint
		{
			return _costStone;
		}

		public function get costStoneID() : uint
		{
			return _costStoneID;
		}

		// =====================
		// 方法
		// =====================
		// 构造函数
		public function EnhanceModel()
		{
			_ruleManager = EnhanceRuleManager.getInstance();

			initModel();
		}

		private function initModel() : void
		{
			_item = null;
			clearItem();
		}

		private function updateItem() : void
		{
			_currentLevel = _item.enhanceLevel;
			_maxLevel = calMaxLevel();
			_targetLevel = calManualTargetLevel();
			_autoTargetLevel = calAutoTargetLevel();
			calculateCost();
		}

		private function clearItem() : void
		{
			_autoTargetLevel = 0;
			_targetLevel = 0;
			_currentLevel = 0;
			_maxLevel = 0;
			clearCost();
		}

		// 计算最大等级
		private function calMaxLevel() : uint
		{
			var maxLevel : uint = _currentLevel;
			var rule : EnhanceRule = _ruleManager.getRule(maxLevel + 1);

			while (rule)
			{
				if (UserData.instance.vipLevel < rule.minVIPLevel) break;
				if (item is Sutra)
				{
					if (Sutra(item).step < rule.minSutraLevel)
						break;
				}
				else if (item.level < rule.minItemLevel)
					break;
				maxLevel++;
				rule = _ruleManager.getRule(maxLevel + 1);
			}

			return maxLevel;
		}

		private function calManualTargetLevel() : uint
		{
			return Math.min(_maxLevel, _currentLevel + 1);
		}

		private function calAutoTargetLevel() : uint
		{
			var rule : EnhanceRule = _ruleManager.getRule(_currentLevel + 1);

			return Math.min(rule ? rule.autoTargetLevel : 0, _maxLevel);
		}

		private function calculateCost() : void
		{
			if (_item.enhanceLevel <= _targetLevel)
			{
				var rule : EnhanceRule = _ruleManager.getRule(_targetLevel);

				_costSilver = rule.costSilver;
				_costStoneID = rule.costStoneId;
				_costStone = rule.costStoneNum;
			}
		}

		private function clearCost() : void
		{
			_costSilver = 0;
			_costStone = 0;
			_costStoneID = 0;
		}

		public static function enhanceFilterFunc(item : Equipment, index : int, vector : Vector.<Equipment>) : Boolean
		{
			return item.enhanceLevel < _ruleManager.getMaxEnhanceLevel(item);
		}

		public static function enhanceSortFunc(a : Equipment, b : Equipment) : int
		{
			if (a is Sutra) return -1;
			if (b is Sutra) return 1;

			if (a.heroId > b.heroId) return 1;
			if (a.heroId < b.heroId) return -1;

			if (a.id > b.id) return 1;
			if (a.id < b.id) return -1;

			if (a.enhanceLevel > b.enhanceLevel) return -1;
			if (a.enhanceLevel < b.enhanceLevel) return 1;

			return 1;
		}

		public function meetCost() : Boolean
		{
			return hasEnoughSilver() && hasEnoughStone();
		}

		public function hasEnoughSilver() : Boolean
		{
			return UserData.instance.silver >= _costSilver;
		}

		public function hasEnoughStone() : Boolean
		{
			var ret:Boolean; 
			try
			{
				ret =  ItemManager.instance.getPileItem(_costStoneID).nums >= _costStone; 
			}
			catch (e : Error)
			{
				Logger.error("异常 costStoneId"+ _costStoneID);
				throw (e);
			}
			
			return ret;
		}
	}
}
