package game.module.battle.battleData
{
	public class skillType
	{
		public static const PHYSICALTYPE:int = 0;      //物理攻击
		public static const NORMALSKILLTYPE:int = 0;   //普通法术攻击
		public static const POISONTYPE:int = 1;        //中毒
		public static const STUNTYPE:int = 2;          //眩晕
		public static const SLOWTYPE:int = 3;          //减速
		public static const SPEEDTYPE:int = 4;         //加速
		public static const ADDCRIT:int = 5;           //加暴击
		public static const ADDPIERCE:int = 6;         //加破击
		public static const ADDHP:int = 7;             //加血
		public static const SUKHP:int = 8;             //吸血
		public static const RESISTANCE:int = 9;        //格挡
		public static const ADDGAUGE:int = 10;         //加聚气
		public static const DEEPHURT:int = 11;         //伤害加深
		public static const ADDCOUNTER:int = 12;       //反击概率
		public static const ADDATTACK:int = 13;        //加攻击
		public static const REDUCEHITRATE:int = 14;    //降低命中率
		public static const MULTIPLE:int = 15;         //多次攻击
		public static const ADDDODGE:int = 16;         //提高闪避
		public static const ADDDEFEND:int = 17;        //加防御
		public static const REDUCESPELLDMG:int = 18;   //降低下次受到的法术伤害
		public static const REBECRITPROB:int = 19;     //降低受到的暴击概率
		public static const REBEPIERCEPROB:int = 20;   //降低受到的破击的概率
		public static const ADDMYSELFATTACK:int = 21;  //给自己加攻击力
		public static const REDUCEATTACK:int = 22;     //降低目标的攻击力
		public static const IMMUNITY:int = 23;         //净化
	//	public static const POISONWORDS:int = 5001;      //中毒文字效果
		
		public static const GAUGEFULL:int = 100000;      //聚气满了
		
		public function skillType()
		{
		}
		
		public static function getTypeOfSkillType(skilltype:int):uint   //0 叠在avatar身下，1，叠在身上， 2 头顶上 3 文字()
		{
//			switch(skilltype)
//			{
//				case POISONTYPE:
//					return 1;
//				case GAUGEFULL:
//					return 0;
//				case STUNTYPE:
//					return 2;
//				default:
//					return 3;
//			}
			return 0;
		}
	}
}