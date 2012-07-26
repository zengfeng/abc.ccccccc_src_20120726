package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x23
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCCityLeave extends com.protobuf.Message {
		 /**
		  *@player_id   player_id
		  **/
		public var playerId:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCCityLeave.playerId cannot be set twice.');
					}
					++player_id$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
