package game.core.item.gem
{
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	import game.core.item.config.ItemConfig;
	import game.core.item.equipable.HeroSlot;
	import game.core.item.equipable.IEquipable;
	import game.core.item.equipable.IEquipableSlot;
	import game.core.item.pile.PileItem;
	import game.core.item.prop.ItemProp;
	import game.core.prop.Prop;
	import game.core.prop.PropManager;


	/**
	 * @author jian
	 */
	public class Gem extends PileItem implements IEquipable
	{
		private var _slot : IEquipableSlot;
		private var _propKey : String;
		private var _prop : ItemProp;
		private var _otherKey : String;
		private var _description : String;

		// ==========================================================
		// @属性
		// ==========================================================
		public function get level() : uint
		{
			return (id - 1) % 10 + 1;
		}

		public function get propKey() : String
		{
			return _propKey;
		}

		// TODO
		public function get propName() : String
		{
			return "";
		}

		/*
		 * 安装ID
		 */
		public function get equipId() : uint
		{
			if (_slot)
				return _slot.equipPosition;
			else
				return 0x8000 | (binding ? 0x4000 : 0x0000) | id;
		}

		/*
		 * 武器插槽
		 */
		public function get slot() : IEquipableSlot
		{
			return _slot;
		}

		/*
		 * 是否已装备
		 */
		public function get isEquipped() : Boolean
		{
			return _slot != null;
		}

		/*
		 * 将领ID
		 */
		public function get heroId() : uint
		{
			if (_slot)
			{
				return HeroSlot(_slot).heroId;
			}

			return 0;
		}

		override public function get searchName() : String
		{
			return (name + " Lv" + level);
		}

		public function get prop() : ItemProp
		{
			return _prop;
		}

		public function set prop(value : ItemProp) : void
		{
			_prop = value;

			updateOtherKey();
			if (otherKey)
			{
				var property : Prop = PropManager.instance.getPropByKey(otherKey);
				_description = property.name + StringUtils.addColor(" +" + this.prop[otherKey] + (property.per == 1 ? "%" : ""), ColorUtils.GOOD);
			}
		}

		public function get otherKey() : String
		{
			return _otherKey;
		}

		override public function get description() : String
		{
			return _description;
		}

		// ==========================================================
		// @方法
		// ==========================================================
		public static function create(config : ItemConfig, binding : Boolean, prop : ItemProp) : Gem
		{
			var gem : Gem = new Gem();
			gem.config = config;
			gem.prop = prop;
			gem.binding = binding;

			return gem;
		}

		override protected function parse(source : *) : void
		{
			var item : Gem = source as Gem;
			item.config = config;
			item.binding = binding;
			item.topType = topType;
			item.nums = nums;
			item.prop = prop;
		}

		public function Gem()
		{
			super();
		}

		/*
		 * 响应装上
		 */
		public function onEquipped(target : IEquipableSlot) : void
		{
			if (_slot && target != _slot)
			{
				_slot.onReleased();
			}

			_slot = target;
		}

		/*
		 * 响应卸下
		 */
		public function onReleased() : void
		{
			_slot = null;
		}

		// ------------------------------------------------
		// 属性
		// ------------------------------------------------
		private function updateOtherKey() : void
		{
			for each (var key:String in _prop.allKeys)
			{
				if (_prop[key] != 0)
				{
					_otherKey = key;
					break;
				}
			}
		}
	}
}
