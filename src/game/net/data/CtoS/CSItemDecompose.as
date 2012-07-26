package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x282
	 **/
	import com.protobuf.*;
	public dynamic final class CSItemDecompose extends com.protobuf.Message {
		 /**
		  *@uniqueID   uniqueID
		  **/
		public var uniqueID:Vector.<uint> = new Vector.<uint>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (uniqueID != null && uniqueID.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, uniqueID);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
