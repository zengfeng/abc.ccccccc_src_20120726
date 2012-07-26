package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xBC
	 **/
	import com.protobuf.*;
	public dynamic final class CSListPurchase extends com.protobuf.Message {
		 /**
		  *@listtype   listtype
		  **/
		public var listtype:uint;

		 /**
		  *@param   param
		  **/
		public var param:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, listtype);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, param);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
