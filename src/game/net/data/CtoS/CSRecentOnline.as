package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x4F
	 **/
	import com.protobuf.*;
	public dynamic final class CSRecentOnline extends com.protobuf.Message {
		 /**
		  *@players   players
		  **/
		public var players:Vector.<uint> = new Vector.<uint>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (players != null && players.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, players);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
