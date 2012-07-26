package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xBE
	 **/
	import com.protobuf.*;
	public dynamic final class CSFitPurchase extends com.protobuf.Message {
		 /**
		  *@purchid   purchid
		  **/
		public var purchid:uint;

		 /**
		  *@itemcnt   itemcnt
		  **/
		public var itemcnt:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, purchid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemcnt);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
