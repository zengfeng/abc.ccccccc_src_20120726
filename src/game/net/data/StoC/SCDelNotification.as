package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x59
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCDelNotification extends com.protobuf.Message {
		 /**
		  *@idList   idList
		  **/
		public var idList:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			idList = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, idList);
						break;
					}
					idList.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
