package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2CB
	 **/
	import com.protobuf.*;
	public dynamic final class CSViewGuild extends com.protobuf.Message {
		 /**
		  *@guild   guild
		  **/
		public var guild:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, guild);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
