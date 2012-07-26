package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x37
	 **/
	import com.protobuf.*;
	public dynamic final class CSFishBegin extends com.protobuf.Message {
		 /**
		  *@quality   quality
		  **/
		public var quality:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, quality);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
