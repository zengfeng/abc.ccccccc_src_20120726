package game.net.core {
	import com.signalbus.Signal;

	/**
	 * @author jian
	 */
	public class GASignals 
	{
		// ---------------------------------------------------------------
		// 游戏分析模块 Game Analysis
		// ---------------------------------------------------------------
		// 继续上次角色
		public static var gaLoginContinueRole : Signal = new Signal();
		// 创建新角色（开始加载）
		public static var gaLoginCreateRole : Signal = new Signal();
		// 进入创建新角色页面（加载结束）
		public static var gaCreateRoleEnterPage : Signal = new Signal();
		// 角色创建完成
		public static var gaCreateRoleComplete : Signal = new Signal(int/* jobId */);
		// 预加载资源开始
		public static var gaPreLoadAssetStart : Signal = new Signal(String/* AssetName */);
		// 预加载资源完成
		public static var gaPreLoadAssetComplete : Signal = new Signal(String/* AssetName */);
		// 预加载全部开始
		public static var gaPreLoadAssetAllStart : Signal = new Signal();
		// 预加载全部完成
		public static var gaPreLoadAssetAllComplete : Signal = new Signal();
		// 升级
		public static var gaRoleLevelUp : Signal = new Signal(int /* JobId */, int/* 级别 */);
	}
}
