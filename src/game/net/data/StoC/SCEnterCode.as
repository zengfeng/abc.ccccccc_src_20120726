package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x0D
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCEnterCode extends com.protobuf.Message {
		 /**
		  *@code   code
		  **/
		public var code:String;

		 /**
		  *@result   result
		  **/
		public var result:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var code$count:uint = 0;
			var result$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (code$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCEnterCode.code cannot be set twice.');
					}
					++code$count;
					code = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCEnterCode.result cannot be set twice.');
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
