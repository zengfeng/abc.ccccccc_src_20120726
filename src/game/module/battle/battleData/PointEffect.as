package game.module.battle.battleData
{
	import game.module.battle.Formation;

	public class PointEffect
	{
		public var m_formationID:uint;     //阵型id
		public var m_addExtra:Number;      //变化值
		public function PointEffect()
		{
			m_formationID = 0;
			m_addExtra = 0;
		}
		public function getEffectType():uint
		{
			var fID:uint = m_formationID / 100;
			if (11 == fID)
			{
				return Formation.FORMATION1;
			}
			else if (12 == fID)
			{
				return Formation.FORMATION2;
			}
			else if (13 == fID)
			{
				return Formation.FORMATION3;
			}
			else if(14 == fID)
			{
				return Formation.FORMATION4;
			}
			return 0;
		}
		
//		public function getPointPos():int
//		{
//			return m_formationID % 10000;
//		}
	}
}