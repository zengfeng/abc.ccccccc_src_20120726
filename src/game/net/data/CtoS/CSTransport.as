package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x25
	 **/
	import com.protobuf.*;
	public dynamic final class CSTransport extends com.protobuf.Message {
		 /**
		  *@cityId   cityId
		  **/
		private var cityId$field:uint;

		private var hasField$0:uint = 0;

		public function removeCityId():void {
			hasField$0 &= 0xfffffffe;
			cityId$field = new uint();
		}

		public function get hasCityId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set cityId(value:uint):void {
			hasField$0 |= 0x1;
			cityId$field = value;
		}

		public function get cityId():uint {
			return cityId$field;
		}

		 /**
		  *@toX   toX
		  **/
		public var toX:uint;

		 /**
		  *@toY   toY
		  **/
		public var toY:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (hasCityId) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, cityId$field);
			}
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, toX);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, toY);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
