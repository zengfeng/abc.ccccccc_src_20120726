package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2A
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCBarrier extends com.protobuf.Message {
		 /**
		  *@barrierID   barrierID
		  **/
		public var barrierID:uint;

		 /**
		  *@open   open
		  **/
		public var open:Boolean;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var barrierID$count:uint = 0;
			var open$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (barrierID$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBarrier.barrierID cannot be set twice.');
					}
					++barrierID$count;
					barrierID = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (open$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBarrier.open cannot be set twice.');
					}
					++open$count;
					open = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
