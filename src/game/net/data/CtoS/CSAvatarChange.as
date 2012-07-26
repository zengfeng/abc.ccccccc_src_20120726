package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x27
	 **/
	import com.protobuf.*;
	public dynamic final class CSAvatarChange extends com.protobuf.Message {
		 /**
		  *@playerId   playerId
		  **/
		public var playerId:Vector.<uint> = new Vector.<uint>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (playerId != null && playerId.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, playerId);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
