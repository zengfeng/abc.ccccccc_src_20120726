package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x5C
	 **/
	import com.protobuf.*;
	public dynamic final class CSListRewardNotification extends com.protobuf.Message {
		 /**
		  *@leastTime   leastTime
		  **/
		private var leastTime$field:uint;

		private var hasField$0:uint = 0;

		public function removeLeastTime():void {
			hasField$0 &= 0xfffffffe;
			leastTime$field = new uint();
		}

		public function get hasLeastTime():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set leastTime(value:uint):void {
			hasField$0 |= 0x1;
			leastTime$field = value;
		}

		public function get leastTime():uint {
			return leastTime$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (hasLeastTime) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, leastTime$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
