package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1C1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCStoreBuyRet extends com.protobuf.Message {
		 /**
		  *@result   result
		  **/
		public var result:Boolean;

		 /**
		  *@opId   opId
		  **/
		public var opId:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			var opId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCStoreBuyRet.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 2:
					if (opId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCStoreBuyRet.opId cannot be set twice.');
					}
					++opId$count;
					opId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
