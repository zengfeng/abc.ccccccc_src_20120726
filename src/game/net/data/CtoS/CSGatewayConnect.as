package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xFFF0
	 **/
	import com.protobuf.*;
	public dynamic final class CSGatewayConnect extends com.protobuf.Message {
		 /**
		  *@sessionId   sessionId
		  **/
		public var sessionId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, sessionId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
