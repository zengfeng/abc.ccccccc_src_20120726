
package game.module.compete
{
	import game.net.data.StoC.SCAthleticsChallenge;
	import game.net.data.StoC.SCAthleticsHistory.AthleticsRecord;
	import game.net.data.StoC.SCAthleticsQuery.AthleticsPlayer;

	public final class VoCompete
	{
		
		public static var voPlayer:Vector.<AthleticsPlayer> = new Vector.<AthleticsPlayer>();
		
		public static var record:Vector.<AthleticsRecord> = new Vector.<AthleticsRecord>();
		
		public static var voNewBattle:SCAthleticsChallenge = new SCAthleticsChallenge();
		
		public var id : int=1;
		
		public static var isUserListInit:int=0;

		/**我的排名**/
		public static var myRank:int=121212;
		
		/** 今日剩余挑战次数 **/
		public static var todayCountLeft : int = 1;

//		/** 今日已挑战次数 **/
//		public static var todayCount : int = 1;
//
//		/**  今日挑战总次数 */
//		public static var todaycountMax : int = 1;

		
		/**  距离下次挑战时间 */                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
//		public static var nextTime :int=0;
		
//		public static var getTimeGap :int=0;		
		  // 连胜数
         public static var winStreak:int = 0;
         // 今日已获得声望
         public static var honorGot : int= 0;
          // 今日可获得声望上限
         public static var honorTotal: int = 0;
          // 今日已获得银币
         public static var silverGot: int = 0;
          // 今日可获得银币上限
         public static var silverTotal: int = 0;
          // 历史最高排名
         public static var bestRank: int = 0;
		 // 奖励领取时间
         public static var bonusTime: int = 0; 
		 //战报ID
		 public static var battleID:int =0;
		 
		 
		  //获得的修为
         public static var todayxiuwei : String= "";
		 
		 
		//获得的修为
         public static var totleBattle : int= 0;
	}
}
