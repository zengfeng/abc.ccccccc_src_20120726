package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xB2
	 **/
	import com.protobuf.*;
	public dynamic final class CSTradeStatus extends com.protobuf.Message {
		 /**
		  *@tradeid   tradeid
		  **/
		public var tradeid:uint;

		 /**
		  *@status   status
		  **/
		public var status:uint;

		 /**
		  *@begin   begin
		  **/
		private var begin$field:uint;

		private var hasField$0:uint = 0;

		public function removeBegin():void {
			hasField$0 &= 0xfffffffe;
			begin$field = new uint();
		}

		public function get hasBegin():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set begin(value:uint):void {
			hasField$0 |= 0x1;
			begin$field = value;
		}

		public function get begin():uint {
			return begin$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, tradeid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, status);
			if (hasBegin) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, begin$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
