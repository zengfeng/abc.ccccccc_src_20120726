package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x44
	 **/
	import com.protobuf.*;
	public dynamic final class CSFollowName extends com.protobuf.Message {
		 /**
		  *@playerName   playerName
		  **/
		public var playerName:String;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, playerName);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
