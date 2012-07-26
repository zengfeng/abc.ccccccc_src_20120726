package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x5A
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCDelSpecialNotification extends com.protobuf.Message {
		 /**
		  *@type   type
		  **/
		public var type:uint;

		 /**
		  *@idList   idList
		  **/
		public var idList:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			idList = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDelSpecialNotification.type cannot be set twice.');
					}
					++type$count;
					type = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
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
