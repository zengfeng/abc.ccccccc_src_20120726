package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2C9
	 **/
	import com.protobuf.*;
	public dynamic final class CSGuildAnnounce extends com.protobuf.Message {
		 /**
		  *@announce   announce
		  **/
		public var announce:String;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, announce);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
