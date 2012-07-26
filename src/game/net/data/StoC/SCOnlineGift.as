package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x74
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCOnlineGift extends com.protobuf.Message {
		 /**
		  *@timeLeft   timeLeft
		  **/
		public var timeLeft:uint;

		 /**
		  *@itemlist   itemlist
		  **/
		public var itemlist:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var timeLeft$count:uint = 0;
			itemlist = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (timeLeft$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCOnlineGift.timeLeft cannot be set twice.');
					}
					++timeLeft$count;
					timeLeft = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, itemlist);
						break;
					}
					itemlist.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
