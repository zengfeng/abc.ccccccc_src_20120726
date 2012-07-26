package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2C7
	 **/
	import com.protobuf.*;
	public dynamic final class CSGuildVote extends com.protobuf.Message {
		 /**
		  *@voted   voted
		  **/
		public var voted:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, voted);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
