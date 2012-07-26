package game.core.item.config
{
	import flash.utils.Dictionary;
	import game.core.item.Item;
	import log4a.Logger;



	/**
	 * @author qiujian
	 */
	public class ItemConfigManager
	{
		// =====================
		// 单例
		// =====================
		private static var __instance : ItemConfigManager;

		public static function get instance() : ItemConfigManager
		{
			if (!__instance) __instance = new ItemConfigManager();

			return __instance;
		}

		public function ItemConfigManager()
		{
			if (__instance) throw (Error("单例错误！"));
		}

		// =====================
		// 定义
		// =====================
		private static const TYPE_EXPAND_LEVEL : uint = 59;
		private static const EXPAND_LEVEL_MAX : uint = 200;

		// =====================
		// 属性
		// =====================
		private var _itemConfigDict : Dictionary = new Dictionary();
		
		// =====================
		// 方法
		// =====================
		
		public function newItem(id : uint) : Item
		{
			var config : ItemConfig = _itemConfigDict[id];

			if (!config)
			{
				Logger.error("物品配置不存在" + id);
				return null;
			}

			var item : Item = new Item();

			return item;
		}

		public function addConfig(config : ItemConfig) : void
		{
			if (_itemConfigDict[config.id])
			{
				Logger.warn("重复添加物品配置" + config.id);
			}

			if (config.type == TYPE_EXPAND_LEVEL)
			{
				expandLevel(config);
				return;
			}

			_itemConfigDict[config.id] = config;
		}

		public function getConfig(id : uint) : ItemConfig
		{
			var config : ItemConfig = _itemConfigDict[id];

			if (!config)
			{
				Logger.warn("物品配置不存在" + id);
			}

			return config;
		}

		// 重复此物品到200级，物品等级依次累加
		private function expandLevel(config : ItemConfig) : void
		{
			if (config.level <= 0)
				throw (Error("类型" + TYPE_EXPAND_LEVEL + "物品的等级必须大于零！"));
				
			var stepLevel:uint = config.level;
			var configExpand : ItemConfig = config.clone();
			
			while(configExpand.level <= EXPAND_LEVEL_MAX)
			{
				_itemConfigDict[configExpand.id] = configExpand;
				configExpand = configExpand.clone();
				configExpand.level += stepLevel;
				configExpand.id++;
			}
		}

		public function get configDict() : Dictionary /* ItemConfig by id */
		{
			return _itemConfigDict;
		}
		
		public function getConfigNameById(id:uint):String
		{
			return _itemConfigDict[id].name;
		}
	}
}
