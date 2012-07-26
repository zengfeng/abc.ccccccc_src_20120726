package game.core.item.soul
{
	import flash.utils.Dictionary;
	/**
	 * @author jian
	 */
	public class SoulConfigManager
	{
		// =====================
		// 单例
		// =====================
		private static var __instance : SoulConfigManager;

		public static function get instance() : SoulConfigManager
		{
			if (!__instance) __instance = new SoulConfigManager();

			return __instance;
		}

		public function SoulConfigManager()
		{
			if (__instance) throw (Error("单例错误！"));
		}
		
		// =====================
		// 属性
		// =====================
		
		private var _configDict:Dictionary = new Dictionary(); /* of SoulExpConfg */
		
		// =====================
		// 方法
		// =====================
		public function addConfig(conf:SoulConfig):void
		{
			_configDict[conf.id] = conf;
		}
		
		public function getConfig(id:uint):SoulConfig
		{
			return _configDict[id];
		}
	}
}
