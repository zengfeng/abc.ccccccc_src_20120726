package game.module.enhance
{
	/**
	 * @author verycd
	 */
	public class EnhanceRule
	{
		// 强化等级 
		public var enhanceLevel: uint;
		// 物品等级下限 
		public var minItemLevel: uint;
		// 武器等级下限
		public var minSutraLevel: uint;
		// VIP等级下限
		public var minVIPLevel: uint;
		// 消耗仙石ID
		public var costStoneId: uint;
		// 消耗银币数 
		public var costSilver: uint;
		// 消耗保护符个数
//		public var costScroll: uint;
		// 提升攻击力 
		public var incrAttack: Number;
		// 提升生命力 
		public var incrHealth: Number;
		// 提升防御力
		public var incrDefence: Number;
		// 提升仙攻
		public var incrSpell: Number;
		// 失败概率
		public var failProbability: uint;
		// 失败倒退等级
		public var failDowngradeLevel: uint;
		// 自动强化目标等级
		public var autoTargetLevel: uint;
		// 消耗仙石个数
		public var costStoneNum:int;
		
		// 解析配置文件
		public function parse (arr: Array):void
		{
			if(!arr || arr.length<13) return;
			enhanceLevel = arr[0];
			minItemLevel = arr[1];
			minSutraLevel = arr[2];
			minVIPLevel = arr[3];
			costStoneId = arr[4];
			costSilver = arr[5];
			incrAttack = arr[6];
			incrSpell = arr[7];
			incrHealth = arr[8];
			incrDefence = arr[9];
			autoTargetLevel = arr[10];
			failProbability = arr[11];
			failDowngradeLevel = arr[12];
			costStoneNum = arr[13];
				
			// TODO: 以后移动到策划表里
//			costScroll = (enhanceLevel > 4)?1:0;
		}
	}
}
