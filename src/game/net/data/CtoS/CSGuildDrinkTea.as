package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2D1
	 **/
	import com.protobuf.*;
	public dynamic final class CSGuildDrinkTea extends com.protobuf.Message {
		 /**
		  *@sel   sel
		  **/
		public var sel:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, sel);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
