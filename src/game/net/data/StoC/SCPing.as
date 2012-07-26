package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x00
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCPing extends com.protobuf.Message {
		 /**
		  *@ping   ping
		  **/
		public var ping:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var ping$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (ping$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPing.ping cannot be set twice.');
					}
					++ping$count;
					ping = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
