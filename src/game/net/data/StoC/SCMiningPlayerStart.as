package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1D1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCMiningPlayerStart extends com.protobuf.Message {
		 /**
		  *@playerId   playerId
		  **/
		public var playerId:uint;

		 /**
		  *@mineralId   mineralId
		  **/
		public var mineralId:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playerId$count:uint = 0;
			var mineralId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCMiningPlayerStart.playerId cannot be set twice.');
					}
					++playerId$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (mineralId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCMiningPlayerStart.mineralId cannot be set twice.');
					}
					++mineralId$count;
					mineralId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
