package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x293
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCAbyssLootResult extends com.protobuf.Message {
		 /**
		  *@index   index
		  **/
		public var index:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var index$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (index$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAbyssLootResult.index cannot be set twice.');
					}
					++index$count;
					index = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
