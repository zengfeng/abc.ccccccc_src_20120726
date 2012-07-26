package game.core.item.equipment
{
	import com.utils.ItemUtils;
	import flash.events.EventDispatcher;
	import game.core.item.config.ItemConfig;
	import game.core.item.equipable.EquipableItem;
	import game.core.item.equipable.HeroSlot;
	import game.core.item.prop.ItemProp;
	import game.core.item.prop.ItemPropManager;
	import game.core.prop.PropManager;
	import game.manager.SignalBusManager;
	import game.module.enhance.EnhanceUtils;



	/**
	 * @author jian
	 */
	public class Equipment extends EquipableItem
	{
		// =====================
		// 属性
		// =====================
		// 强化等级
		private var _enhanceLevel : uint = 0;
		// 套装个数
		private var _suiteNums : int = 0;

		// =====================
		// Setter/Getter
		// =====================
		public function set enhanceLevel(value : uint) : void
		{
			_enhanceLevel = value;
		}

		public function get enhanceLevel() : uint
		{
			return _enhanceLevel;
		}

		public function get enhanceProp() : String
		{
			return ItemUtils.getEnhancePropKey(type);
		}

		public function get level() : uint
		{
			return super.useLevel;
		}

		public function get enhancePropName() : String
		{
			return PropManager.instance.getPropByKey(ItemUtils.getEnhancePropKey(type)).name;
		}

		public function get enhanceValue() : uint
		{
			if (enhanceLevel > 0)
				return ItemUtils.getEnhancePropValue(type, enhanceLevel);
			else
				return 0;
		}

		public function get enhanceColor() : uint
		{
			return EnhanceUtils.getColorIdByEnhanceLevel(enhanceLevel);
		}

		public function get heroId() : uint
		{
			if (_slot)
				return (_slot as HeroSlot).hero.id;
			return 0;
		}

		public function get qualityType() : uint
		{
			return (id - 10010) / 10 % 3;
		}

		public function get typeName() : String
		{
			return ItemUtils.getEquipmentTypeName(type);
		}

		public function get totalProp() : ItemProp
		{
			var total : ItemProp = _prop.clone();
			total[enhanceProp] += enhanceValue;

			return total;
		}

		public function get suiteId() : uint
		{
			return int(id / 10);
		}

		public function set suiteNums(value : int) : void
		{
			_suiteNums = value;
		}

		public function get suiteNums() : int
		{
			if (slot)
				return _suiteNums;
			else
				return 0;
		}

		public function get halfSuiteProp() : ItemProp
		{
			return ItemPropManager.instance.getProp(suiteId * 10 + 9);
		}

		public function get fullSuiteProp() : ItemProp
		{
			return ItemPropManager.instance.getProp(suiteId * 10 + 10);
		}

		// =====================
		// 方法
		// =====================
		public static function create(config : ItemConfig, binding : Boolean, prop : ItemProp) : Equipment
		{
			var eq : Equipment = new Equipment();
			eq.config = config;
			eq.prop = prop;
			eq.binding = binding;

			return eq;
		}
	}
}
