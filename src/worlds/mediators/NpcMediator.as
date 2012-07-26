package worlds.mediators
{
	import worlds.auxiliarys.mediators.Call;
	import worlds.auxiliarys.mediators.Callback;
	import worlds.auxiliarys.mediators.MSignal;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-24
	 */
	public class NpcMediator
	{
		/** 清理数据 */
		public static const clearData : MSignal = new MSignal();
		/** 添加 */
		public static const add : MSignal = new MSignal(uint);
		/** 移除 */
		public static const remove : MSignal = new MSignal(uint);
		/** 移除所有 */
		public static const uninstall : MSignal = new MSignal();
		/** 安装完成 */
		public static const installCompleted : MSignal = new MSignal(uint);
		/** 停止安装 */
		public static const stopInstall : MSignal = new MSignal();
		/** 开始安装 */
		public static const startInstall : MSignal = new MSignal();
		/** AI碰到 */
		public static const aiHit : MSignal = new MSignal(uint);
		/** 去下一个AI */
		public static const gotoNextAI:MSignal = new MSignal();
		/** 获取Npc args=[npcId] */
		public static const getNpc : Callback = new Callback();
		/** 添加数据 args=[npcId] */
		public static const addData:Call = new Call();
		/** 添加数据 args=[npcId] */
		public static const removeData:Call = new Call();
		/** 获取Npc列表 */
		public static const getNpcList:Callback = new Callback();
		
		// =================
		// 监听
		// =================
		/** 添加安装监听args=[playerId, callFun, callFunArgs] */
		public static const cAddInstallListener : Call = new Call();
		/** 移除安装监听args=[playerId, callFun] */
		public static const cRemoveInstallListener : Call = new Call();
		/** 添加卸载监听args=[playerId, callFun, callFunArgs] */
		public static const cAddDestoryistener : Call = new Call();
		/** 移除卸载监听 args=[playerId, callFun] */
		public static const cRemoveDestoryistener : Call = new Call();		
	}
}
