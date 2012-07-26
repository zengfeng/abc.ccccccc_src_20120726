package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x70
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCGiftList.GiftData;
	public dynamic final class SCGiftList extends com.protobuf.Message {
		 /**
		  *@gifts   gifts
		  **/
		public var gifts:Vector.<GiftData> = new Vector.<GiftData>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			gifts = new Vector.<GiftData>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					gifts.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCGiftList.GiftData()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
