package game.module.pack.merge
{
	import flash.utils.Dictionary;

	import game.net.core.Common;
	import game.net.data.CtoS.CSMaterialMerge;

	/**
	 * @author jian
	 */
	public class MergeManager
	{
		// =====================
		// 单例
		// =====================
		private static var __instance : MergeManager;

		public static function get instance() : MergeManager
		{
			if (!__instance)
				__instance = new MergeManager();
			return __instance;
		}

		public function MergeManager() : void
		{
			if (__instance)
				throw(new Error("单例错误！"));

			__instance = this;

			initiate();
		}

		// =====================
		// 属性
		// =====================
		private var _configDict : Dictionary;
		private var _configList : Array;

		// =====================
		// 方法
		// =====================
		private function initiate() : void
		{
			_configDict = new Dictionary();
			_configList = [];
		}

		public function addConfig(config : MergeConfig) : void
		{
			_configList.push(config);
			_configDict[config.sourceId] = config;
		}

		public function getConfig(sourceId : int) : MergeConfig
		{
			return _configDict[sourceId];
		}

		public function get configList() : Array
		{
			return _configList;
		}
		
		public function checkMergeable(id:int):Boolean
		{
			return (_configDict[id] != undefined);
		}

		public function sendMaterialMergeMessage(itemId : int, mergeType : int) : void
		{
			var msg : CSMaterialMerge = new CSMaterialMerge();
			msg.itemId = itemId | mergeType << 16;
			Common.game_server.sendMessage(0x2B0, msg);
		}
	}
}
