package game.core.hero {
	/**
	 * @author jian
	 */
	public class RecruitState 
	{
		// 已招募
		public static const RECRUITED:int = 0;
		// 离队中（可归队）
		public static const RETIRED:int = 1;
		// 可招募
		public static const RECUITABLE:int = 2;
		// 可铸炼
		public static const CASTABLE:int = 3;
	}
}
