package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x4E
	 **/
	import com.protobuf.*;
	public dynamic final class CSDismissFans extends com.protobuf.Message {
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

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (hasPlayer) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, player$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
