package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x35
	 **/
	import com.protobuf.*;
	public dynamic final class CSCompleteQuest extends com.protobuf.Message {
		 /**
		  *@questId   questId
		  **/
		public var questId:uint;

		 /**
		  *@flag   flag
		  **/
		public var flag:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, questId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, flag);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
