package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x20
	 **/
	import com.protobuf.*;
	public dynamic final class CSWalkTo extends com.protobuf.Message {
		 /**
		  *@toX   toX
		  **/
		public var toX:uint;

		 /**
		  *@toY   toY
		  **/
		public var toY:uint;

		 /**
		  *@fromX   fromX
		  **/
		private var fromX$field:uint;

		private var hasField$0:uint = 0;

		public function removeFromX():void {
			hasField$0 &= 0xfffffffe;
			fromX$field = new uint();
		}

		public function get hasFromX():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set fromX(value:uint):void {
			hasField$0 |= 0x1;
			fromX$field = value;
		}

		public function get fromX():uint {
			return fromX$field;
		}

		 /**
		  *@fromY   fromY
		  **/
		private var fromY$field:uint;

		public function removeFromY():void {
			hasField$0 &= 0xfffffffd;
			fromY$field = new uint();
		}

		public function get hasFromY():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set fromY(value:uint):void {
			hasField$0 |= 0x2;
			fromY$field = value;
		}

		public function get fromY():uint {
			return fromY$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, toX);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, toY);
			if (hasFromX) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, fromX$field);
			}
			if (hasFromY) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, fromY$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
