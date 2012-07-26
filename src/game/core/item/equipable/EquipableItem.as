package game.core.item.equipable
{
	import game.core.item.IComparable;
	import game.core.item.IUnique;
	import game.core.item.Item;
	import game.core.item.prop.ItemProp;

	/**
	 * @author jian
	 */
	public class EquipableItem extends Item implements IEquipable, IUnique
	{
		// =====================
		// 定义
		// =====================
		public static const MASTER_KEYS : Array = ["strength", "quick", "physique"];
		// =====================
		// @属性
		// =====================
		protected var _slot : IEquipableSlot;
		protected var _prop : ItemProp;
		private var _uuid : uint;
		private var _otherKey : String;

		// =====================
		// @方法
		// =====================
		override protected function parse(source : *) : void
		{
			super.parse(source);

			var item : EquipableItem = source as EquipableItem;
			item.slot = slot;
			item.uuid = uuid;
		}

		public function set uuid(value : uint) : void
		{
			_uuid = value;
		}

		public function get uuid() : uint
		{
			return _uuid;
		}

		public function onEquipped(target : IEquipableSlot) : void
		{
			if (_slot && target != _slot)
			{
				_slot.onReleased();
			}

			_slot = target;
		}

		public function onReleased() : void
		{
			_slot = null;
		}

		public function get slot() : IEquipableSlot
		{
			return _slot;
		}

		public function set slot(value : IEquipableSlot) : void
		{
			_slot = value;
		}

		public function get isEquipped() : Boolean
		{
			return _slot != null;
		}

		public function get equipId() : uint
		{
			if (_slot)
				return _slot.equipPosition;
			else
				return uuid;
		}

		override public function equals(value : IComparable) : Boolean
		{
			var other : EquipableItem = value as EquipableItem;

			if (!other) return false;

			return other.uuid == uuid;
		}

		public function set prop(value : ItemProp) : void
		{
			_prop = value;
			updateOtherKey();
		}

		public function get masterKeys() : Array
		{
			return MASTER_KEYS;
		}

		public function get otherKey() : String
		{
			return _otherKey;
		}

		public function get prop() : ItemProp
		{
			return _prop;
		}

		private function updateOtherKey() : void
		{
			for each (var key:String in _prop.allKeys)
			{
				if (_prop[key] != 0)
				{
					// 跳过3个主属性
					if (masterKeys.indexOf(key) != -1)
						continue;

					// 剩下不为0的那个为额外属性
					if (!_otherKey)
						_otherKey = key;
					else
					{
						//trace("超出一个额外属性 !" + id + " " + _otherKey + " " + key);
					}
				}
			}

			if (!_otherKey)
				trace("缺失额外属性！" + id);
		}
	}
}
