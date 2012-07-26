package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xB5
	 **/
	import com.protobuf.*;
	public dynamic final class CSStartSale extends com.protobuf.Message {
		 /**
		  *@itemid   itemid
		  **/
		public var itemid:uint;

		 /**
		  *@param   param
		  **/
		public var param:uint;

		 /**
		  *@price   price
		  **/
		public var price:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, param);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, price);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
