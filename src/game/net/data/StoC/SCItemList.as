package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x200
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.EquipAttribute;
	public dynamic final class SCItemList extends com.protobuf.Message {
		 /**
		  *@items   items
		  **/
		public var items:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@equipments   equipments
		  **/
		public var equipments:Vector.<EquipAttribute> = new Vector.<EquipAttribute>();

		 /**
		  *@hint   hint
		  **/
		public var hint:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			items = new Vector.<uint>();

			equipments = new Vector.<EquipAttribute>();

			var hint$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, items);
						break;
					}
					items.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 2:
					equipments.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.EquipAttribute()));
					break;
				case 3:
					if (hint$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCItemList.hint cannot be set twice.');
					}
					++hint$count;
					hint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
