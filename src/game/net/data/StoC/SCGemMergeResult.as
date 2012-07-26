package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2A1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGemMergeResult extends com.protobuf.Message {
		 /**
		  *@compactId   compactId
		  **/
		public var compactId:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var compactId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (compactId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGemMergeResult.compactId cannot be set twice.');
					}
					++compactId$count;
					compactId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
