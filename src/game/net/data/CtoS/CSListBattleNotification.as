package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x5E
	 **/
	import com.protobuf.*;
	public dynamic final class CSListBattleNotification extends com.protobuf.Message {
		 /**
		  *@leastID   leastID
		  **/
		private var leastID$field:uint;

		private var hasField$0:uint = 0;

		public function removeLeastID():void {
			hasField$0 &= 0xfffffffe;
			leastID$field = new uint();
		}

		public function get hasLeastID():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set leastID(value:uint):void {
			hasField$0 |= 0x1;
			leastID$field = value;
		}

		public function get leastID():uint {
			return leastID$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (hasLeastID) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, leastID$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
