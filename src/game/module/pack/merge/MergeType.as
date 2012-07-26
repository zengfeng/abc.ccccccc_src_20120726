package game.module.pack.merge
{
	/**
	 * @author jian
	 */
	public class MergeType
	{
		// 服务器决定合成规则：先合成绑定，然后非绑定，然后绑定加非绑定
		public static const MERGE_AUTO:int = 0;
		// 非绑定
		public static const MERGE_UNBIND:int = 1;
		// 绑定
		public static const MERGE_BIND:int = 2;
		// 服务器合成所有
		public static const MERGE_ALL:int = 3;
	}
}
