package game.module.chat
{
	import game.core.menu.MenuManager;
	import com.commUI.alert.Alert;

	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-13
	 */
	public class LinkConfig
	{
		/** 单例对像 */
		private static var _instance : LinkConfig;

		/** 获取单例对像 */
		static public function get instance() : LinkConfig
		{
			if (_instance == null)
			{
				_instance = new LinkConfig();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var dic : Dictionary = new Dictionary();

		function LinkConfig() : void
		{
			dic[1] = MenuManager.getInstance().openMenuView;
		}

		public function run(linkId : int, args : Array = null) : void
		{
			var fun : Function = dic[linkId];
			if (fun != null)
			{
				fun.apply(null, args);
			}
		}
	}
}
