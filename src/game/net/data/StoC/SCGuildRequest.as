package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2C4
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGuildRequest extends com.protobuf.Message {
		 /**
		  *@guild   guild
		  **/
		public var guild:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var guild$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (guild$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildRequest.guild cannot be set twice.');
					}
					++guild$count;
					guild = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
