package game.core.item.equipable
{
	/**
	 * @author jian
	 */
	public interface IEquipableSlot
	{
		function equip(source : IEquipable) : void;

		function release() : void;

		function onEquipped(source : IEquipable) : void;

		function onReleased() : void;

		function get equipable() : IEquipable;
		
		function get equipPosition() :uint;
	}
}
