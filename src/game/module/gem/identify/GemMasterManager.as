package game.module.gem.identify
{
	/**
	 * @author jian
	 */
	public class GemMasterManager
	{
		// =====================
		// @单例
		// =====================
		private static var __instance:GemMasterManager;
		
		public static function get instance():GemMasterManager
		{
			if (!__instance) __instance = new GemMasterManager();
			
			return __instance;
		}
		
		public function GemMasterManager()
		{
			if (__instance) throw (Error("单例错误"));
		}
		
		// =====================
		// @属性
		// =====================	
		public var masters:Array = [] /* of VoGemMaster */;
		
		// =====================
		// @方法
		// =====================
	}
}
