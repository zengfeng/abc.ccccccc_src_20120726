package game.core.prop
{
	import flash.utils.Dictionary;

	/**
	 * @author jian
	 */
	public class PropManager
	{
		// =====================
		// Singleton
		// =====================
		private static var __instance : PropManager;

		public static function get instance() : PropManager
		{
			if (!__instance)
				__instance = new PropManager();
			return __instance;
		}

		public function PropManager()
		{
			if (__instance)
				throw(Error("单例错误!"));

			initiate();
		}

		// =====================
		// 定义
		// =====================
		public static const ITEM_PROP_KEYS : Array = ["strength", "quick", "physique", "hp", "hp_add", "hp_per", "act", "act_add", "act_per", "def", "speed", "speed_per", "hit", "dodge", "crit", "pierce", "counter", "critmul", "piercedef", "countermul", "harm", "predef", "magic_act", "magic_per", "magic_pierce", "gauge_initial", "gauge_speed", "strengthToAttack", "agilityToSpeed", "physiqueToHealth"];
		public static const HERO_PROP_KEYS : Array = ["strength", "quick", "physique"/** 三个基础属性 */, "hp", "act", "magic_act", "def", "speed", "gauge_initial", "hit", "dodge", "crit", "pierce", "counter"/** 11个二级属性 */, "hp_add", "act_add", "hp_per", "act_per", "speed_per", "magic_per"/** 二级属性附加*/, "predef", "magic_pierce", "critmul", "piercedef", "countermul", "harm", "gauge_initial"/** 特殊属性 */];
		public static const EQUI_MASTER_PROP_KEYS : Array = ["strength", "hp", "def", "quick"];
		public static const SUTRA_MASTER_PROP_KEYS : Array = [];
		
		// =====================
		// Attribute
		// =====================
		private var _propByID : Dictionary;
		private var _propByKey : Dictionary;
		private var _nullProp : Prop;

		// =====================
		// Method
		// =====================
		private function initiate() : void
		{
			_propByID = new Dictionary();
			_propByKey = new Dictionary();
			_nullProp = new Prop();
			_nullProp.id = 0xFFFFFFFF;
			_nullProp.name = "未知属性";
			_nullProp.key = "nullProp";
		}

		public function setProp(prop : Prop) : void
		{
			_propByID[prop.id] = prop;
			_propByKey[prop.key] = prop;
		}

		public function getPropByKey(key : String) : Prop
		{
			if (_propByKey[key] == undefined)
			{
				trace("不存在的属性" + key);
				return null;
			}

			return _propByKey[key];
		}

		public function getPropByID(id : uint) : Prop
		{
			return _propByID[id];
		}
	}
}
