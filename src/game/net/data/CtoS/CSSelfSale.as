package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xB6
	 **/
	import com.protobuf.*;
	public dynamic final class CSSelfSale extends com.protobuf.Message {
		 /**
		  *@begin   begin
		  **/
		public var begin:uint;

		 /**
		  *@count   count
		  **/
		private var count$field:uint;

		private var hasField$0:uint = 0;

		public function removeCount():void {
			hasField$0 &= 0xfffffffe;
			count$field = new uint();
		}

		public function get hasCount():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set count(value:uint):void {
			hasField$0 |= 0x1;
			count$field = value;
		}

		public function get count():uint {
			return count$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, begin);
			if (hasCount) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, count$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
