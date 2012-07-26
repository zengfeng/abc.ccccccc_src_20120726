package game.core.item.equipable
{
	/**
	 * @author jian
	 */
	public interface IEquipable
	{
		function onEquipped(target : IEquipableSlot) : void;

		function onReleased() : void;

		function get equipId() : uint;

		function get slot() : IEquipableSlot;
		
		function get isEquipped() :Boolean
		
//		function get position() :uint
	}
}
