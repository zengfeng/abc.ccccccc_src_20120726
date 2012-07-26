package game.core.item.equipment
{
	import game.core.hero.VoHero;
	import game.core.item.equipable.HeroSlot;
	import game.core.item.equipable.IEquipable;

	/**
	 * @author jian
	 */
	public class EquipmentSlot extends HeroSlot
	{
		public function EquipmentSlot(hero : VoHero, pos : uint)
		{
			super(hero, HeroSlot.EQ, pos);
		}
		
		public function get eqType():uint
		{
			return this.pos + 81;
		}
		
		override public function onEquipped(source : IEquipable):void
		{
			super.onEquipped(source);
			hero.updateSuite();
		}
		
		override public function onReleased():void
		{
			super.onReleased();
			hero.updateSuite();
		}
	}
}
