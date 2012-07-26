package game.module.battle.battleData
{
	public class BtOneAtk
	{
		//攻击者side
		public var atkerSide:int;
		
		//攻击者pos
		public var atkerPos:int;
		//被攻击者pos（首要目标）
		public var atkPos:int;
		
		//技能类型
		public var skillType:int;
		
		//伤害类型(暴击，破击，暴破.....)
		public var effectType:int;  
	
		public function BtOneAtk()
		{
		}
		
		public function clone():BtOneAtk
		{
			var bto:BtOneAtk = new BtOneAtk();
			bto.atkerSide = this.atkerSide;
			bto.atkerPos = this.atkerPos;
			bto.atkPos = this.atkPos;
			bto.skillType = this.skillType;
			bto.effectType = this.effectType;
			return bto;
		}
	}
}