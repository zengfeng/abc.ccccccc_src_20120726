package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xB3
	 **/
	import com.protobuf.*;
	public dynamic final class CSListTrade extends com.protobuf.Message {
		 /**
		  *@begin   begin
		  **/
		public var begin:uint;

		 /**
		  *@count   count
		  **/
		public var count:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, begin);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, count);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
