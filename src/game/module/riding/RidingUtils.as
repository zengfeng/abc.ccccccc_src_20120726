package game.module.riding
{
	import flash.utils.Dictionary;
	/**
	 * @author 1
	 */
	public class RidingUtils
	{	
		public static var _mountDic:Dictionary;
			
		public static function praseMountCSV(mountArray:Array):void
		{
			
			_mountDic=new Dictionary();
			for each (var arr:Array in mountArray) 
			{
				var vo:RidingVO=new RidingVO();
				vo.prase(arr);
				_mountDic[vo.mountID]=vo;
			}
		}
	}
}
