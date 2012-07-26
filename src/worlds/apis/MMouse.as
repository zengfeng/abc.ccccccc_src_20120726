package worlds.apis
{
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.mediators.MapMediator;
	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	*/
	public class MMouse
	{
		/** 鼠标点击广播 args=[x,y] */
		public static const sMouseWalk : MSignal = MapMediator.sMouseWalk;
		public static var enableShowPlayerInfo:Boolean = true;
		/** 是否能点击走路 */
		public static function get enableWalk():Boolean
		{
			return  MapMediator.cbMouseEnabled.call();
		}
		
		public static function set enableWalk(value : Boolean) : void
		{
			MapMediator.cMouseEnabled.call(value);
		}
		
		/** 模拟鼠标点击 */
		public static function clickEvent():void
		{
			MapMediator.cMouseClick.call();
		}
	}
}
