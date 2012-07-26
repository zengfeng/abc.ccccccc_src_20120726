package worlds.apis
{
	import worlds.modules.Story;
	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-26
	*/
	public class MStory
	{
		public static var storying:Boolean = false;
		public static function enter():void
		{
			storying = true;
			Story.instance.enter();
		}
		
		public static function exit():void
		{
			storying = false;
			Story.instance.exit();
		}
	}
}
