package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x21
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.PlayerPosition;
	public dynamic final class SCCityEnter extends com.protobuf.Message {
		 /**
		  *@playerPos   playerPos
		  **/
		public var playerPos:game.net.data.StoC.PlayerPosition;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playerPos$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playerPos$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCCityEnter.playerPos cannot be set twice.');
					}
					++playerPos$count;
					playerPos = new game.net.data.StoC.PlayerPosition();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, playerPos);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
