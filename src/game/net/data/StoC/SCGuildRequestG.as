package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2C0
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GuildReserves;
	public dynamic final class SCGuildRequestG extends com.protobuf.Message {
		 /**
		  *@request   request
		  **/
		public var request:game.net.data.StoC.GuildReserves;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var request$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (request$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildRequestG.request cannot be set twice.');
					}
					++request$count;
					request = new game.net.data.StoC.GuildReserves();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, request);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
