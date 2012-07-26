package worlds.apis
{
	import worlds.maps.UIMediator;
	import flash.display.DisplayObject;
	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-27
	*/
	public class MUI
	{
		public static function add(displayObject:DisplayObject):void
		{
			UIMediator.cAdd.call(displayObject);
		}
		
		public static function remove(displayObject:DisplayObject):void
		{
			UIMediator.cRemove.call(displayObject);
		}
	}
}
