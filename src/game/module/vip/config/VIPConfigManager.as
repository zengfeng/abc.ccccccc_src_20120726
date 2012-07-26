package game.module.vip.config
{
	import flash.utils.Dictionary;

	import game.module.vip.view.VIPView;

	/**
	 * @author ME
	 */
	public class VIPConfigManager
	{
		// =====================
		// 单例
		// =====================
		private static var __instance : VIPConfigManager;

		public static function get instance() : VIPConfigManager
		{
			if (!__instance)
				__instance = new VIPConfigManager();

			return __instance;
		}

		public function VIPConfigManager()
		{
			if (__instance)
				throw(Error("单例错误"));
		}

		// =====================
		// 属性
		// =====================
		private var _vipView : VIPView;
		private var _configDict : Dictionary = new Dictionary();
		private var _maxLevel : int = 0;
		private var _itemDict : Dictionary = new Dictionary() ;

		// =====================
		// Getter/Setter
		// =====================
		public function get vipView() : VIPView
		{
			if (!_vipView)
				_vipView = new VIPView();

			return _vipView;
		}

		// =====================
		// 方法
		// =====================
		public function parseVIPXml(xml : XML) : void
		{
			var vipItem : VIPItem;

			// 解析items
			for each (var item:XML in xml["item"])
			{
				vipItem = new VIPItem();

				vipItem.id = item.@id;
				vipItem.name = item.@name;
				vipItem.text = item.@text;

				_itemDict[vipItem.id] = vipItem;
			}

			for each (var configXML:XML in xml["vipconfig"])
			{
				var opens : Array = configXML.@open.split(",");
				var openNumbers : Array = configXML.@openNumber.split(",");
				var level : int = configXML.@level;

				var config : VIPConfig = new VIPConfig();
				config.items = [];
				config.openNumbers = [];
				config.treasurePackages = [];

				config.level = configXML.@level;
				config.gold = configXML.@gold;
				config.friend = configXML.@friend;

				config.treasurePackages = configXML.@treasurePackage.split(",");

				for (var i : int = 0; i < opens.length; i++)
				{
					config.openNumbers.push(openNumbers[i]);
					config.items.push(_itemDict[opens[i]]);
				}

				_configDict[level] = config;

				if (level > _maxLevel)
					_maxLevel = level;
			}
		}

		public function getConfigItems(vipLevel : int) : VIPConfig
		{
			return _configDict[vipLevel];
		}

		public function getMaxVipLevel() : int
		{
			return _maxLevel;
		}
	}
}
