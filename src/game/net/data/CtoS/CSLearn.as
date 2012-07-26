package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x1D
	 **/
	import com.protobuf.*;
	public dynamic final class CSLearn extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
