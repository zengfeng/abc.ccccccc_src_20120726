package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2C0
	 **/
	import com.protobuf.*;
	public dynamic final class CSCreateGuild extends com.protobuf.Message {
		 /**
		  *@name   name
		  **/
		public var name:String;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
