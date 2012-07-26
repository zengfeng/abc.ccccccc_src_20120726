package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x25
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCTransport extends com.protobuf.Message {
		 /**
		  *@player_id   player_id
		  **/
		public var playerId:uint;

		 /**
		  *@my_xy   my_xy
		  **/
		public var myXy:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player_id$count:uint = 0;
			var my_xy$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTransport.playerId cannot be set twice.');
					}
					++player_id$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (my_xy$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTransport.myXy cannot be set twice.');
					}
					++my_xy$count;
					myXy = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
