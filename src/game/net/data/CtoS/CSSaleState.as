package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xB8
	 **/
	import com.protobuf.*;
	public dynamic final class CSSaleState extends com.protobuf.Message {
		 /**
		  *@tradeid   tradeid
		  **/
		public var tradeid:uint;

		 /**
		  *@status   status
		  **/
		public var status:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, tradeid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, status);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
