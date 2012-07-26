package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x39
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCPlotBegin extends com.protobuf.Message {
		 /**
		  *@plotId   plotId
		  **/
		public var plotId:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var plotId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (plotId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlotBegin.plotId cannot be set twice.');
					}
					++plotId$count;
					plotId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
