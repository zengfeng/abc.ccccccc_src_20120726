package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x296
	 **/
	import com.protobuf.*;
	public dynamic final class CSAbyssLootSingle extends com.protobuf.Message {
		 /**
		  *@index   index
		  **/
		public var index:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, index);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
