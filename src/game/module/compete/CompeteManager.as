package game.module.compete
{
	import game.manager.VersionManager;
	import net.LibData;
	import net.RESManager;
	/**
	 * @author zheng
	 */
	public class CompeteManager
	{

		// =========================================================
		// @单例	
		// =========================================================
		private static var __instance : CompeteManager;

		public static function get instance() : CompeteManager
		{
			if (!__instance)
				__instance = new CompeteManager();

			return __instance;
		}

		public function CompeteManager()
		{
			if (__instance)
				throw (Error("单例错误"));
		}

		// ========================================================
		// @属性
		// ========================================================
		private var _view : CompeteView;
		private var _loaded : Boolean = false;
		private var _recover : Object;

		// ========================================================
		// @方法
		// ========================================================
		/*
		 * 进入
		 */
		public function enterAbyss() : void
		{
			if (_loaded)
			{
				initView();
			}
			else
			{
				startLoader();
			}
		}

		/*
		 * 还原
		 */
		public function recoverAbyss(bossId : uint, souls : Vector.<uint>) : void
		{
			_recover = {"bossId":bossId, "souls":souls};
			enterAbyss();
		}

		private function initView() : void
		{
			if (!_view)
			{
				_view = new CompeteView();
			}

			if (_view.parent)
			{
				_view.parent.removeChild(_view);
			}

			_view.show();
			
		}

		/*
		 * 加载资源
		 */
		private function startLoader() : void
		{
			var res : RESManager = RESManager.instance;
			res.load(new LibData(VersionManager.instance.getUrl("assets/soul/abyss.jpg"), "abyssmap"), loadResComplete);
		}

		private function loadResComplete() : void
		{
			//trace("====================> 星宿台资源加载完成");
			_loaded = true;
			initView();
		}
	}
}
