package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xD6
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCConvoyNumUpdate extends com.protobuf.Message {
		 /**
		  *@convoyNum   convoyNum
		  **/
		public var convoyNum:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var convoyNum$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (convoyNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCConvoyNumUpdate.convoyNum cannot be set twice.');
					}
					++convoyNum$count;
					convoyNum = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
