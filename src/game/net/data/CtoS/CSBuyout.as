package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xB9
	 **/
	import com.protobuf.*;
	public dynamic final class CSBuyout extends com.protobuf.Message {
		 /**
		  *@tradeid   tradeid
		  **/
		public var tradeid:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, tradeid);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
