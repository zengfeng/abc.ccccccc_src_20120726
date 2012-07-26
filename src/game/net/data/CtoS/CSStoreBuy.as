package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x1C1
	 **/
	import com.protobuf.*;
	public dynamic final class CSStoreBuy extends com.protobuf.Message {
		 /**
		  *@storeType   storeType
		  **/
		public var storeType:uint;

		 /**
		  *@itemId   itemId
		  **/
		public var itemId:uint;

		 /**
		  *@itemCount   itemCount
		  **/
		public var itemCount:uint;

		 /**
		  *@opId   opId
		  **/
		private var opId$field:uint;

		private var hasField$0:uint = 0;

		public function removeOpId():void {
			hasField$0 &= 0xfffffffe;
			opId$field = new uint();
		}

		public function get hasOpId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set opId(value:uint):void {
			hasField$0 |= 0x1;
			opId$field = value;
		}

		public function get opId():uint {
			return opId$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, storeType);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemCount);
			if (hasOpId) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, opId$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
