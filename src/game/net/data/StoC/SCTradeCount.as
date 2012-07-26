package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xB4
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCTradeCount extends com.protobuf.Message {
		 /**
		  *@opera   opera
		  **/
		public var opera:uint;

		 /**
		  *@total   total
		  **/
		public var total:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var opera$count:uint = 0;
			var total$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (opera$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTradeCount.opera cannot be set twice.');
					}
					++opera$count;
					opera = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (total$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTradeCount.total cannot be set twice.');
					}
					++total$count;
					total = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
