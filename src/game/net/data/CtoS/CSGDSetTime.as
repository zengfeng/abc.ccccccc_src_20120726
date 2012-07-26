package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xFC
	 **/
	import com.protobuf.*;
	public dynamic final class CSGDSetTime extends com.protobuf.Message {
		 /**
		  *@weekday   weekday
		  **/
		public var weekday:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, weekday);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
