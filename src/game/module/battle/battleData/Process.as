/*---------------------------------------------------------------------------------------------------------------------------------------------------/

Process - Class Title - NEROKING.COM

/---------------------------------------------------------------------------------------------------------------------------------------------------*/

package game.module.battle.battleData{
	import flash.display.DisplayObject;

	public final class Process{
		
		public static var data:Vector.<Process> = new Vector.<Process>();
		public static var selfList:Vector.<FighterInfo>;
		public static var enemyList:Vector.<FighterInfo>;
		
		// --- Vars ------------------------------------------------------------------------------------------------------------------------------- //
		
		// 这次攻击是否为反击
		public var Counter:Boolean;
		
		// 阵营 0是自己 1是对方
		public var Side:int;
		
		// 攻击者索引
		public var AttackPlayer:int;
		
		// 是否使用技能
		public var Skill:Boolean;
		
		// 聚气是否达到技能使用上限
		public var AtkSkillReadyed:Boolean;
		
		// 攻击聚气值
		public var AtkPower:int;
		
		// 攻击目标
		public var AtkTarget:int;
		
		// 被攻击者索引组
		public var DefendPlayer:Array = [];
		
		// 血量改变 正值为加血 负值为减血
		public var Harm:Array = [];
		
		// 减血后的值
		public var afterAtk:Array = [];
		
		// 被攻击效果 0击中 1暴击 2破击 3暴破 4闪避
		public var Effect:Array = [];
		
		// 被攻击组聚气是否达到技能使用上限
		public var DefSkillReadyed:Array = [];
		
		// 被攻击者聚气值
		public var DefPower:Array = [];
		
		// --- Public Functions ------------------------------------------------------------------------------------------------------------------- //
		
		// 构造函数
		public function Process(){

		}
		
		// --- Private Functions ------------------------------------------------------------------------------------------------------------------ //
		
	}
}