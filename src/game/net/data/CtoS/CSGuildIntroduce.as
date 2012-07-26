package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2CA
	 **/
	import com.protobuf.*;
	public dynamic final class CSGuildIntroduce extends com.protobuf.Message {
		 /**
		  *@intro   intro
		  **/
		public var intro:String;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, intro);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
