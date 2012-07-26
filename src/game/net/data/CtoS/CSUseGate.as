package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x22
	 **/
	import com.protobuf.*;
	public dynamic final class CSUseGate extends com.protobuf.Message {
		 /**
		  *@gateId   gateId
		  **/
		public var gateId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, gateId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
