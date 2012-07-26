package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xD1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCArrivePonitRes extends com.protobuf.Message {
		 /**
		  *@ret   ret
		  **/
		public var ret:uint;

		 /**
		  *@ponit   ponit
		  **/
		public var ponit:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var ret$count:uint = 0;
			var ponit$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (ret$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCArrivePonitRes.ret cannot be set twice.');
					}
					++ret$count;
					ret = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (ponit$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCArrivePonitRes.ponit cannot be set twice.');
					}
					++ponit$count;
					ponit = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
