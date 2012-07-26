package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x00
	 **/
	import com.protobuf.*;
	public dynamic final class CSPing extends com.protobuf.Message {
		 /**
		  *@ping   ping
		  **/
		public var ping:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, ping);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
