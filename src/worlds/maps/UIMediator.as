package worlds.maps
{
	import worlds.auxiliarys.mediators.Call;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-27
	*/
	public class UIMediator
	{
		/** 添加到UILayer，args=[DisplayObject] */
		public static const cAdd : Call = new Call();
		/** 移除到UILayer，args=[DisplayObject] */
		public static const cRemove : Call = new Call();
		/** 清空 */
		public static const cClearup : Call = new Call();
	}
}
