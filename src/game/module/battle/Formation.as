package game.module.battle
{
	import flash.utils.Dictionary;
	import game.module.battle.battleData.Area;
	import game.module.battle.battleData.PointEffect;
	

	public class Formation
	{
		public static var FORMATION1:uint = 1;
		public static var FORMATION2:uint = 2;
		public static var FORMATION3:uint = 3;
		public static var FORMATION4:uint = 4;
		
//		public static const formationData:Array =
//			[
//				[13718,  0.8],                         
//				[120717, 0.99],
//				[140718, 0.99],
//				[110713, 20]
//			];
		public static const Formationlist:Dictionary = new Dictionary();
		public function Formation()
		{
		}
		//载入数据
		public static function LoadFormationBuffer(formationData:Array):void
		{
			var i:int;
			var npf:PointEffect;
			for(i = 0; i < formationData.length; i++)
			{
				npf = new PointEffect();
				npf.m_formationID = formationData[i][0];
				npf.m_addExtra =  formationData[i][1];
				Formationlist[npf.m_formationID] = npf;
			}
		}
	}
}