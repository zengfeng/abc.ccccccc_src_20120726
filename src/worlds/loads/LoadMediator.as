package worlds.loads
{
	import worlds.auxiliarys.mediators.MSignal;
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-11
	 */
	public class LoadMediator
	{
		public static var sClearup:MSignal = new MSignal();
		/** 通知各位准备需要添加资源进加载条模块 */
		public static var sReady:MSignal = new MSignal();
		public static var sStart:MSignal = new MSignal();
		public static var sMapLoadComplete:MSignal = new MSignal();
		public static var sAllComplete:MSignal = new MSignal();
		public static var sPause:MSignal = new MSignal();
		public static var sGo:MSignal = new MSignal();
	}
}
