package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2F3
	 **/
	import com.protobuf.*;
	public dynamic final class CSGEPlayerBattle extends com.protobuf.Message {
		 /**
		  *@drayId   drayId
		  **/
		public var drayId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, drayId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
