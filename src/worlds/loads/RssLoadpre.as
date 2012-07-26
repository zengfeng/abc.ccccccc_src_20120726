package worlds.loads
{
	import net.ALoader;
	import net.RESManager;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-12
	 */
	public class RssLoadpre
	{
		/** 单例对像 */
		private static var _instance : RssLoadpre;

		/** 获取单例对像 */
		static public function get instance() : RssLoadpre
		{
			if (_instance == null)
			{
				_instance = new RssLoadpre(new Singleton());
			}
			return _instance;
		}

		function RssLoadpre(singleton : Singleton) : void
		{
		}

		/** 资源加载管理器 */
		private var res : RESManager = RESManager.instance;
		private var list : Array;

		public function start() : void
		{
			list = RssData.instance.loadpreData;
			var i : int ;
			var length : int = list.length;
			for (i = 0; i < length; i++ )
			{
				res.preLoadSWF(list[i]);
			}
		}

		public function clearup() : void
		{
			if (list)
			{
				var loader:ALoader;
				while (list.length > 0)
				{
					loader = list.shift();
					res.removePreLoad(loader.key);
				}
			}
		}
	}
}
class Singleton
{
}