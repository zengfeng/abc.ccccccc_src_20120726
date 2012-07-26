package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2F8
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGELeave extends com.protobuf.Message {
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
