package game.core.item.equipable
{
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import game.core.item.ItemService;
	import game.manager.SignalBusManager;

	/**
	 * @author jian
	 */
	public class HeroSlot extends EquipableSlot
	{
		// =====================
		// 定义
		// =====================
		public static const EQ : uint = 0;
		public static const SOUL : uint = 1;
		public static const GEM : uint = 2;
		public static const SUTRA : uint = 7;
		// =====================
		// 属性
		// =====================
		private var _hero : VoHero;
		private var _type : uint;
		private var _pos : uint;

		// =====================
		// Getter/Setter
		// =====================
		public function get heroId() : uint
		{
			return _hero.id;
		}

		public function get pos() : uint
		{
			return _pos;
		}

		override public function get equipPosition() : uint
		{
			return (_hero.id | _pos << 8 | _type << 12 );
		}

		public function get hero() : VoHero
		{
			return _hero;
		}

		// =====================
		// 方法
		// =====================
		public function HeroSlot(hero : VoHero, type : uint, pos : uint)
		{
			_hero = hero;
			_type = type;
			_pos = pos;
			
			SignalBusManager.itemPropChange.add(onItemPropChange);
		}

		override public function equip(source : IEquipable) : void
		{
			super.equip(source);
			ItemService.instance.sendEquipChangeMessage(this.equipPosition, source.equipId);
		}

		override public function release() : void
		{
			ItemService.instance.sendEquipChangeMessage(this.equipPosition, 0);
		}

		override public function onEquipped(source : IEquipable) : void
		{
			super.onEquipped(source);
		}

		override public function onReleased() : void
		{
			super.onReleased();
		}
		
		private function onItemPropChange(item:Item):void
		{
			if (item is EquipableItem)
			{
				if (EquipableItem(item).slot == this)
				{
					SignalBusManager.heroItemPropChange.dispatch(item, hero);
				}
			}
		}
	}
}
