package game.module.battle.battleData
{
	import game.module.battle.BattleFighter;

	public class FighterStatus
	{
		public var bfgt:BattleFighter;
		public var action:uint;
		public var antiAction:uint;
		public var poisonAction:uint;
		public var poisonDamage:uint;
		public var maxAction:uint;
		public var atkMark:uint;
		
		public function FighterStatus( fighter:BattleFighter = null, maxa:uint = 0, antiA:uint = 0, pAction:uint = 0, pDamage:uint = 0, mark:uint = 0 )
		{
			bfgt = fighter;
			maxAction = maxa;
			antiAction = antiA;
			poisonAction = pAction;
			poisonDamage = pDamage;
			atkMark = mark;
			if (pAction > 0)
				action = pAction;
			else if(bfgt != null)
				action = bfgt.getSpeed();
			else 
				action = 0;
		}
		
		
		public function MinusAction(pAnum:int):void
		{
			if(antiAction <= pAnum)
				antiAction = 0;
			else
				antiAction -= pAnum;
		}
		
		public function resetAntiAction():void
		{
			if (bfgt != null)
			{
				antiAction = bfgt.getCoolDown();
			}
		}
	}
}