package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x35
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCBeginConvey extends com.protobuf.Message {
		 /**
		  *@questId   questId
		  **/
		public var questId:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var questId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (questId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBeginConvey.questId cannot be set twice.');
					}
					++questId$count;
					questId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
