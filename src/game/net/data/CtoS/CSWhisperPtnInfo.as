package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x96
	 **/
	import com.protobuf.*;
	public dynamic final class CSWhisperPtnInfo extends com.protobuf.Message {
		 /**
		  *@targe   targe
		  **/
		public var targe:String;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, targe);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
