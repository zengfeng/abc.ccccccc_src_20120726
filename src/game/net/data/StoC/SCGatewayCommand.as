package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xFFF1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGatewayCommand extends com.protobuf.Message {
		 /**
		  *@command   command
		  **/
		public var command:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var command$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (command$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGatewayCommand.command cannot be set twice.');
					}
					++command$count;
					command = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
