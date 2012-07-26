package game.module.mapGroupBattle
{
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-2
	 */
	public class FirstInfo
	{
		public static var has : Boolean = false;
		public static var groupId : int;
		public static var playerId : int;
		public static var playerName : String;
		public static var maxKillCount : int;
		public static var colorStr : String;

		public static function update() : void
		{
			colorStr = GBUtil.getColorStr(GBUtil.getGroupAB(groupId));
			if (callFun != null)
			{
				callFun(playerName, colorStr, maxKillCount);
			}
		}

		private  static var callFun : Function;

		public static function setCall(fun : Function) : void
		{
			callFun = fun;
			if (has)
			{
				colorStr = GBUtil.getColorStr(GBUtil.getGroupAB(groupId));
				callFun(playerName, colorStr, maxKillCount);
			}
			else
			{
				callFun("", "#0xFF0000", 0);
			}
		}
	}
}
