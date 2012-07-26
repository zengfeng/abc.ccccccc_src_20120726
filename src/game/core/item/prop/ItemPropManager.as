package game.core.item.prop
{
	import flash.utils.Dictionary;

	/**
	 * @author verycd
	 */
	public class ItemPropManager
	{
		// =====================
		// @单例
		// =====================
		private static var __instance : ItemPropManager;

		public static function get instance() : ItemPropManager
		{
			if (!__instance) __instance = new ItemPropManager();
			return __instance;
		}

		public function ItemPropManager()
		{
			if (__instance) throw (Error("单例错误！"));
		}

		// =====================
		// @属性
		// =====================
		private var _props : Dictionary = new Dictionary();
		private static var _nullProp:ItemProp = new ItemProp();
		
		// =====================
		// @方法
		// =====================		
		public function addProp(prop : ItemProp) : void
		{
			_props[prop.id] = prop;
		}

		public function getProp(id : uint) : ItemProp
		{
			if (!_props[id])
			{
				//trace("未定义的二级属性"+id);
				
				return _nullProp;
			}
			return _props[id];
		}
	}
}
