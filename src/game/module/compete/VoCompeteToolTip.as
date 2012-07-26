package game.module.compete
{
	/**
	 * @author 1
	 */
	public final class VoCompeteToolTip
	{
		/** 玩家名 **/
		public var name : String;
		/**  玩家等级 */
		public var level : String;
		/** 玩家排名 */
		public var rank : String;
		// 今日获得银币
		public var silver : String;
		// 今日已获得修为
		public var honor : String;
		// 装备获得
		public var equipment:String;
	    // 名字颜色
		public var color:int;
		
	    //是否玩家
		public var isuser:Boolean=false;
		
		//总战斗值
		public var battlePoints:int=0;
	}
}
