package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x280
	 **/
	import com.protobuf.*;
	public dynamic final class CSEnhance extends com.protobuf.Message {
		 /**
		  *@itemID   itemID
		  **/
		public var itemID:uint;

		 /**
		  *@settings   settings
		  **/
		public var settings:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemID);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, settings);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
