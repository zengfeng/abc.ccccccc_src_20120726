package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x24
	 **/
	import com.protobuf.*;
	public dynamic final class CSSwitchCity extends com.protobuf.Message {
		 /**
		  *@cityId   cityId
		  **/
		public var cityId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, cityId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
