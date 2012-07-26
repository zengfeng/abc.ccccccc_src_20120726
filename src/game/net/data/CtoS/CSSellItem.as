package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x202
	 **/
	import com.protobuf.*;
	public dynamic final class CSSellItem extends com.protobuf.Message {
		 /**
		  *@items   items
		  **/
		public var items:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@uniqueID   uniqueID
		  **/
		public var uniqueID:Vector.<uint> = new Vector.<uint>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (items != null && items.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, items);
			}
			if (uniqueID != null && uniqueID.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, uniqueID);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
