package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x100
	 **/
	import com.protobuf.*;
	public dynamic final class CSDonate extends com.protobuf.Message {
		 /**
		  *@count   count
		  **/
		public var count:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, count);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
