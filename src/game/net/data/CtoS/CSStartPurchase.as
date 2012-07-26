package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xBA
	 **/
	import com.protobuf.*;
	public dynamic final class CSStartPurchase extends com.protobuf.Message {
		 /**
		  *@itemid   itemid
		  **/
		public var itemid:uint;

		 /**
		  *@count   count
		  **/
		public var count:uint;

		 /**
		  *@uprice   uprice
		  **/
		public var uprice:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, count);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, uprice);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
