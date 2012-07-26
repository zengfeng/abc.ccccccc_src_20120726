package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xE001
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCBackendTopup extends com.protobuf.Message {
		 /**
		  *@topupId   topupId
		  **/
		public var topupId:String;

		 /**
		  *@result   result
		  **/
		public var result:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var topupId$count:uint = 0;
			var result$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (topupId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBackendTopup.topupId cannot be set twice.');
					}
					++topupId$count;
					topupId = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBackendTopup.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
