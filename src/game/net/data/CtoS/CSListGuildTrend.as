package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2F0
	 **/
	import com.protobuf.*;
	public dynamic final class CSListGuildTrend extends com.protobuf.Message {
		 /**
		  *@stamp   stamp
		  **/
		public var stamp:uint;

		 /**
		  *@latid   latid
		  **/
		public var latid:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, stamp);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, latid);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
