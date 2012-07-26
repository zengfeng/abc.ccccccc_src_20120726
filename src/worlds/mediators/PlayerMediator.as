package worlds.mediators
{
	import worlds.auxiliarys.mediators.Call;
	import worlds.auxiliarys.mediators.Callback;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.roles.structs.PlayerStruct;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-23
	 */
	public class PlayerMediator
	{
		public static const getStruct : Callback = new Callback();
		public static const getPlayer : Callback = new Callback();
		// =================
		// 进入&离开
		// =================
		/** 自己玩家等待安装 */
		public static const selfWaitInstall : MSignal = new MSignal(PlayerStruct);
		/** 自己玩家安装完成 */
		public static const selfInstalled : MSignal = new MSignal(PlayerStruct);
		/** 玩家获得最新信息等待安装  */
		public static const playerWaitInstalled : MSignal = new MSignal(PlayerStruct);
		/** 玩家安装完成  */
		public static const playerInstalled : MSignal = new MSignal(int);
		/** 玩家离开 args=[playerId]  */
		public static const playerLeave : MSignal = new MSignal(int);
		/** 玩家卸载 */
		public static const playerDestory : MSignal = new MSignal(int);
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
		// =================
		// 基本属性改变
		// =================
		/** 玩家走路 args = [playerId:int, toX:int, toY:int, hasFrom:Boolean, fromX:int, fromY:int] */
		public static const walkTo : MSignal = new MSignal(int, int, int, Boolean, int, int);
		/** 玩家传送 args = [playerId:int, toX:int, toY:int]*/
		public static const transportTo : MSignal = new MSignal(int, int, int);
		/** 玩家换衣服 args =[playerId, clothId] */
		public static const changeCloth : MSignal = new MSignal(int, int);
		/** 玩家换衣服 args =[playerId, rideId] */
		public static const changeRide : MSignal = new MSignal(int, int);
		// =================
		// 模式
		// =================
		/** 打座进入 args=[playerId] */
		public static const sitDown : MSignal = new MSignal(uint);
		/** 打座退出 args=[playerId] */
		public static const sitUp : MSignal = new MSignal(uint);
		// -----------------------------
		/** 龟仙拜佛进入 args=[playerId, quality] */
		public static const MODEL_CONVOY_IN : MSignal = new MSignal(uint, uint);
		/** 龟仙拜佛退出 args=[playerId] */
		public static const MODEL_CONVOY_OUT : MSignal = new MSignal(uint);
		/** 龟仙拜佛速度改变 args=[playerId, speedModel] */
		public static const MODEL_CONVOY_CHANGE : MSignal = new MSignal(uint, uint);
		// -----------------------------
		/** 钓鱼进入 args=[playerId, modelId] */
		public static const MODEL_FISHING_IN : MSignal = new MSignal(uint, uint);
		/** 钓鱼退出 args=[playerId] */
		public static const MODEL_FISHING_OUT : MSignal = new MSignal(uint);
		// -----------------------------
		/** 采矿进入 args=[playerId, modelId]  */
		public static const MODEL_MINGING_IN : MSignal = new MSignal(uint, uint);
		/** 采矿退出 args=[playerId]  */
		public static const MODEL_MINGING_OUT : MSignal = new MSignal(uint);
		// -----------------------------
		/** 派对进入 args=[playerId, status] */
		public static const MODEL_FEAST_IN : MSignal = new MSignal(uint, uint);
		/** 派对退出 args=[playerId] */
		public static const MODEL_FEAST_OUT : MSignal = new MSignal(uint);
		/** 派对状态改变 args=[playerId, modelId] */
		public static const MODEL_FEAST_CHANGE: MSignal = new MSignal(uint, uint);
		
		public static const MODEL_IN:MSignal = new MSignal(uint);
		public static const MODEL_OUT:MSignal = new MSignal(uint);
		
	}
}
