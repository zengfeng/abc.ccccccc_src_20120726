package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2F3
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GEDrayData;
	public dynamic final class SCGEDraySyn extends com.protobuf.Message {
		 /**
		  *@dray   dray
		  **/
		public var dray:game.net.data.StoC.GEDrayData;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dray$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dray$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEDraySyn.dray cannot be set twice.');
					}
					++dray$count;
					dray = new game.net.data.StoC.GEDrayData();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, dray);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
