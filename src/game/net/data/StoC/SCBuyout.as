package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xB9
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCBuyout extends com.protobuf.Message {
		 /**
		  *@tradeid   tradeid
		  **/
		public var tradeid:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var tradeid$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (tradeid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBuyout.tradeid cannot be set twice.');
					}
					++tradeid$count;
					tradeid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
