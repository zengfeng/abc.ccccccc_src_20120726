package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xE000
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCBackendCommand extends com.protobuf.Message {
		 /**
		  *@playersNotFound   playersNotFound
		  **/
		public var playersNotFound:Vector.<String> = new Vector.<String>();

		 /**
		  *@commandsFailed   commandsFailed
		  **/
		public var commandsFailed:Vector.<String> = new Vector.<String>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			playersNotFound = new Vector.<String>();

			commandsFailed = new Vector.<String>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					playersNotFound.push(com.protobuf.ReadUtils.read$TYPE_STRING(input));
					break;
				case 2:
					commandsFailed.push(com.protobuf.ReadUtils.read$TYPE_STRING(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
