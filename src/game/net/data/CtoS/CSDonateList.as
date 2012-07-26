package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x103
	 **/
	import com.protobuf.*;
	public dynamic final class CSDonateList extends com.protobuf.Message {
		 /**
		  *@page   page
		  **/
		public var page:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, page);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
