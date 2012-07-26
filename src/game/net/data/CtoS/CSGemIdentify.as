package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2A0
	 **/
	import com.protobuf.*;
	public dynamic final class CSGemIdentify extends com.protobuf.Message {
		 /**
		  *@compactId   compactId
		  **/
		public var compactId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, compactId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
