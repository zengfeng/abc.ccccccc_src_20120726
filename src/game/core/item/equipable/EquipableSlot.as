package game.core.item.equipable
{
	import game.core.item.Item;
	import game.core.user.StateManager;

	/**
	 * @author jian
	 */
	public class EquipableSlot implements IEquipableSlot
	{
		// =====================
		// 属性
		// =====================
		protected var _waitingEquip : Boolean;
		protected var _equipable : IEquipable;

		// =====================
		// 方法
		// =====================
		
		public function equip(source : IEquipable) : void
		{
			if (!source.isEquipped)
				_waitingEquip = true;
		}

		public function release() : void
		{
		}

		public function onEquipped(source : IEquipable) : void
		{
			_equipable = source;
			_equipable.onEquipped(this);

			if (_waitingEquip)
			{
				if (source is Item)
				{
					StateManager.instance.checkMsg(232, null, null, [(source as Item).id]);
				}
				_waitingEquip = false;
			}
		}

		public function onReleased() : void
		{
			if (_equipable)
			{
				_equipable.onReleased();
			}

			_equipable = null;
		}

		public function get equipable() : IEquipable
		{
			return _equipable;
		}

		public function get equipPosition() : uint
		{
			return 0;
		}
	}
}
