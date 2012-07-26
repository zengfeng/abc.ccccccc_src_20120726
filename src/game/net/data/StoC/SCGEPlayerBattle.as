package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2F5
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGEPlayerBattle extends com.protobuf.Message {
		 /**
		  *@drayId   drayId
		  **/
		public var drayId:uint;

		 /**
		  *@playerId   playerId
		  **/
		public var playerId:uint;

		 /**
		  *@health   health
		  **/
		public var health:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var drayId$count:uint = 0;
			var playerId$count:uint = 0;
			var health$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (drayId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEPlayerBattle.drayId cannot be set twice.');
					}
					++drayId$count;
					drayId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEPlayerBattle.playerId cannot be set twice.');
					}
					++playerId$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (health$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEPlayerBattle.health cannot be set twice.');
					}
					++health$count;
					health = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
