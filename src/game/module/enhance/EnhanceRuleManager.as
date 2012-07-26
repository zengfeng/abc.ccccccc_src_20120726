package game.module.enhance
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import game.core.item.Item;
	import game.core.item.equipment.Equipment;
	import game.core.user.UserData;



	/**
	 * @author verycd
	 */
	// 装备强化操作
	public final class EnhanceRuleManager extends EventDispatcher
	{
		// 单列对象
		private static var __instance : EnhanceRuleManager;
		// 强化规则，每条对应一个强化等级
		private var _rules : Array = new Array();

		// 构造函数
		public function EnhanceRuleManager(target : IEventDispatcher = null)
		{
			super(target);
		}

		// 获取单列对象
		public static function getInstance() : EnhanceRuleManager
		{
			if (__instance == null)
			{
				__instance = new EnhanceRuleManager();
			}
			return __instance;
		}

		// 获得强化规则
		public function getRule(enhanceLevel : uint) : EnhanceRule
		{
//			var rule:EnhanceRule = _rules[enhanceLevel];
			
//			if (!rule)
//				throw(Error("不存在的强化规则,等级"+enhanceLevel));
			return _rules[enhanceLevel];
		}

		// 添加强化规则
		public function addRule(rule : EnhanceRule) : void
		{
			_rules[rule.enhanceLevel] = rule;
		}
		
		// 获得强化上限等级
		public function getMaxEnhanceLevel (item:Equipment):uint
		{
			var maxLevel:uint = item.enhanceLevel;
			var rule : EnhanceRule = _rules[maxLevel + 1];

			while (rule)
			{
				if (item.level < rule.minItemLevel || UserData.instance.vipLevel < rule.minVIPLevel) break;
				maxLevel++;
				rule = _rules[maxLevel + 1];
			}
			return maxLevel;
		}
		
	}
}
