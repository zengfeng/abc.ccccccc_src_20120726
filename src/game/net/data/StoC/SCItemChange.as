package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x203
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.EquipAttribute;
	public dynamic final class SCItemChange extends com.protobuf.Message {
		 /**
		  *@equipment   equipment
		  **/
		public var equipment:Vector.<EquipAttribute> = new Vector.<EquipAttribute>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			equipment = new Vector.<EquipAttribute>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					equipment.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.EquipAttribute()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
