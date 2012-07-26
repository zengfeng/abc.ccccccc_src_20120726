package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1A4
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCAthleticsBuy extends com.protobuf.Message {
		 /**
		  *@todayCountLeft   todayCountLeft
		  **/
		public var todayCountLeft:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var todayCountLeft$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (todayCountLeft$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsBuy.todayCountLeft cannot be set twice.');
					}
					++todayCountLeft$count;
					todayCountLeft = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
