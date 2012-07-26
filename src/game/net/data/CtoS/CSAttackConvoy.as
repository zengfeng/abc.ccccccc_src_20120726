package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xD3
	 **/
	import com.protobuf.*;
	public dynamic final class CSAttackConvoy extends com.protobuf.Message {
		 /**
		  *@playerId   playerId
		  **/
		public var playerId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
