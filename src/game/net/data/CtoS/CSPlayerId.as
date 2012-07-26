package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x0F
	 **/
	import com.protobuf.*;
	public dynamic final class CSPlayerId extends com.protobuf.Message {
		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@server   server
		  **/
		private var server$field:uint;

		private var hasField$0:uint = 0;

		public function removeServer():void {
			hasField$0 &= 0xfffffffe;
			server$field = new uint();
		}

		public function get hasServer():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set server(value:uint):void {
			hasField$0 |= 0x1;
			server$field = value;
		}

		public function get server():uint {
			return server$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			if (hasServer) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, server$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
