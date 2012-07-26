package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x0D
	 **/
	import com.protobuf.*;
	public dynamic final class CSEnterCode extends com.protobuf.Message {
		 /**
		  *@code   code
		  **/
		public var code:String;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, code);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
