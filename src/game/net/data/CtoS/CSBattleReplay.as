package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x62
	 **/
	import com.protobuf.*;
	public dynamic final class CSBattleReplay extends com.protobuf.Message {
		 /**
		  *@replayId   replayId
		  **/
		public var replayId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, replayId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
