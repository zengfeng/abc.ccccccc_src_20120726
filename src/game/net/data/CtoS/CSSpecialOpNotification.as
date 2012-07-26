package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x5A
	 **/
	import com.protobuf.*;
	public dynamic final class CSSpecialOpNotification extends com.protobuf.Message {
		 /**
		  *@type   type
		  **/
		public var type:uint;

		 /**
		  *@id   id
		  **/
		public var id:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, type);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
