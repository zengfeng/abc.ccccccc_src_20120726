package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2A1
	 **/
	import com.protobuf.*;
	public dynamic final class CSGemMerge extends com.protobuf.Message {
		 /**
		  *@gemId0   gemId0
		  **/
		public var gemId0:uint;

		 /**
		  *@gemId1   gemId1
		  **/
		public var gemId1:uint;

		 /**
		  *@gemId2   gemId2
		  **/
		public var gemId2:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, gemId0);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, gemId1);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, gemId2);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
