package game.module.mapGroupBattle
{
	/**
	 * @author ZengFeng (zengfeng75[at]163.com) 2012-7-21
	 */
	public class GBPlayerControl
	{
		/** 单例对像 */
		private static var _instance : GBPlayerControl;

		/** 获取单例对像 */
		public static function get instance() : GBPlayerControl
		{
			if (_instance == null)
			{
				_instance = new GBPlayerControl(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		function GBPlayerControl(singleton : Singleton) : void
		{
			singleton;
		}
	}
}
class Singleton
{
}