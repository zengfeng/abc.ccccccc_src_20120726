package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x49
	 **/
	import com.protobuf.*;
	public dynamic final class CSBlockId extends com.protobuf.Message {
		 /**
		  *@blockId   blockId
		  **/
		public var blockId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, blockId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
