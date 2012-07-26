package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x12
	 **/
	import com.protobuf.*;
	public dynamic final class CSGuideUpdate extends com.protobuf.Message {
		 /**
		  *@step   step
		  **/
		public var step:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, step);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
