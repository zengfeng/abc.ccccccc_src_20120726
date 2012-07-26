package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x90
	 **/
	import com.protobuf.*;
	public dynamic final class CSWhisper extends com.protobuf.Message {
		 /**
		  *@target   target
		  **/
		public var target:String;

		 /**
		  *@content   content
		  **/
		public var content:String;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, target);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, content);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
