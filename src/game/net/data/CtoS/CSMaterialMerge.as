package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2B0
	 **/
	import com.protobuf.*;
	public dynamic final class CSMaterialMerge extends com.protobuf.Message {
		 /**
		  *@itemId   itemId
		  **/
		public var itemId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
