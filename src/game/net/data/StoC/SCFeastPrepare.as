package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x304
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCFeastPrepare extends com.protobuf.Message {
		 /**
		  *@timeLeft   timeLeft
		  **/
		public var timeLeft:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var timeLeft$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (timeLeft$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFeastPrepare.timeLeft cannot be set twice.');
					}
					++timeLeft$count;
					timeLeft = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
