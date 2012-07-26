package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2C5
	 **/
	import com.protobuf.*;
	public dynamic final class CSGuildPass extends com.protobuf.Message {
		 /**
		  *@player   player
		  **/
		public var player:uint;

		 /**
		  *@pass   pass
		  **/
		private var pass$field:Boolean;

		private var hasField$0:uint = 0;

		public function removePass():void {
			hasField$0 &= 0xfffffffe;
			pass$field = new Boolean();
		}

		public function get hasPass():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set pass(value:Boolean):void {
			hasField$0 |= 0x1;
			pass$field = value;
		}

		public function get pass():Boolean {
			return pass$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, player);
			if (hasPass) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
				com.protobuf.WriteUtils.write$TYPE_BOOL(output, pass$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
