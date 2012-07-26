package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2CD
	 **/
	import com.protobuf.*;
	public dynamic final class CSGuildRemove extends com.protobuf.Message {
		 /**
		  *@playerid   playerid
		  **/
		public var playerid:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerid);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
