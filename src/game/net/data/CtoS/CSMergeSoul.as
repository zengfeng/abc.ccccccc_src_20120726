package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x290
	 **/
	import com.protobuf.*;
	public dynamic final class CSMergeSoul extends com.protobuf.Message {
		 /**
		  *@source   source
		  **/
		public var source:uint;

		 /**
		  *@target   target
		  **/
		public var target:uint;

		 /**
		  *@position   position
		  **/
		private var position$field:uint;

		private var hasField$0:uint = 0;

		public function removePosition():void {
			hasField$0 &= 0xfffffffe;
			position$field = new uint();
		}

		public function get hasPosition():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set position(value:uint):void {
			hasField$0 |= 0x1;
			position$field = value;
		}

		public function get position():uint {
			return position$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, source);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, target);
			if (hasPosition) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, position$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
