package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x281
	 **/
	import com.protobuf.*;
	public dynamic final class CSEnhanceTransfer extends com.protobuf.Message {
		 /**
		  *@sourceID   sourceID
		  **/
		public var sourceID:uint;

		 /**
		  *@targetID   targetID
		  **/
		public var targetID:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, sourceID);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, targetID);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
