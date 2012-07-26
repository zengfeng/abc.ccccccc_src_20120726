package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x03
	 **/
	import com.protobuf.*;
	public dynamic final class CSIPAddress extends com.protobuf.Message {
		 /**
		  *@ipAddr   ipAddr
		  **/
		public var ipAddr:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, ipAddr);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
