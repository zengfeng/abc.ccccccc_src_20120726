package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x4E
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCDismissFans extends com.protobuf.Message {
		 /**
		  *@player   player
		  **/
		private var player$field:uint;

		private var hasField$0:uint = 0;

		public function removePlayer():void {
			hasField$0 &= 0xfffffffe;
			player$field = new uint();
		}

		public function get hasPlayer():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set player(value:uint):void {
			hasField$0 |= 0x1;
			player$field = value;
		}

		public function get player():uint {
			return player$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDismissFans.player cannot be set twice.');
					}
					++player$count;
					player = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
