package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xFD
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGDReviveReject extends com.protobuf.Message {
		 /**
		  *@reviveTime   reviveTime
		  **/
		public var reviveTime:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var reviveTime$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (reviveTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDReviveReject.reviveTime cannot be set twice.');
					}
					++reviveTime$count;
					reviveTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
