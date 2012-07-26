package game.module.heroPanel
{
	import flash.events.Event;
	import game.core.item.equipment.Equipment;

	/**
	 * @author jian
	 */
	public class EnhanceTransferEvent extends Event
	{
		public static var TRANSFER:String = "enhance_transfer";
		
		public var sourceEquipment:Equipment;
		public var targetEquipment:Equipment;
		
		public function EnhanceTransferEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
