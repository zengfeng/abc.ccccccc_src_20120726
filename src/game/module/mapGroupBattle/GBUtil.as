package game.module.mapGroupBattle
{
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-2
	 */
	public class GBUtil
	{
		/** 获取级别 */
		public static function getLevel(groupId : int) : int
		{
			return groupId == 0 || groupId == 1 ? GBConfig.LEVEL_1 : GBConfig.LEVEL_2;
		}

		/** 获取groupAB */
		public static function getGroupAB(groupId : int) : int
		{
			return groupId == 0 || groupId == 2 ? GBConfig.GROUP_ID_A : GBConfig.GROUP_ID_B;
		}

		public static function getColorStr(groupAB : int) : String
		{
			return groupAB ==GBConfig.GROUP_ID_A  ? GBConfig.GROUP_COLOR_STR_A : GBConfig.GROUP_COLOR_STR_B;
		}
	}
}
