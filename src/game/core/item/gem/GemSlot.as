package game.core.item.gem
{
	import game.core.item.equipable.HeroSlot;
	import game.core.item.equipable.IEquipable;
	import game.core.item.sutra.Sutra;
	import game.manager.SignalBusManager;

	/**
	 * @author jian
	 */
	public class GemSlot extends HeroSlot
	{
		// =====================
		// 属性
		// =====================
		private var _sutra : Sutra;

		// =====================
		// 方法
		// =====================
		public function GemSlot(sutra : Sutra, pos : uint)
		{
			_sutra = sutra;
			super(sutra.hero, HeroSlot.GEM, pos);
		}

		override public function onEquipped(source : IEquipable) : void
		{
			super.onEquipped(source);
			SignalBusManager.itemPropChange.dispatch(_sutra);
		}

		override public function onReleased() : void
		{
			super.onReleased();
			SignalBusManager.itemPropChange.dispatch(_sutra);
		}

		override public function equip(source : IEquipable) : void
		{
			if (!source is Sutra ) return;

			super.equip(source);
		}
	}
}
