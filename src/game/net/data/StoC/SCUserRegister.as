package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x01
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCUserRegister extends com.protobuf.Message {
		 /**
		  *@result   result
		  **/
		public var result:uint;

		 /**
		  *@playerId   playerId
		  **/
		private var playerId$field:uint;

		private var hasField$0:uint = 0;

		public function removePlayerId():void {
			hasField$0 &= 0xfffffffe;
			playerId$field = new uint();
		}

		public function get hasPlayerId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set playerId(value:uint):void {
			hasField$0 |= 0x1;
			playerId$field = value;
		}

		public function get playerId():uint {
			return playerId$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			var playerId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCUserRegister.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCUserRegister.playerId cannot be set twice.');
					}
					++playerId$count;
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
