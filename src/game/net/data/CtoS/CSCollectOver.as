package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x34
	 **/
	import com.protobuf.*;
	public dynamic final class CSCollectOver extends com.protobuf.Message {
		 /**
		  *@questId   questId
		  **/
		public var questId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, questId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
