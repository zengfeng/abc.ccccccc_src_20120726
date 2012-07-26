package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x48
	 **/
	import com.protobuf.*;
	public dynamic final class CSBlockName extends com.protobuf.Message {
		 /**
		  *@blockName   blockName
		  **/
		public var blockName:String;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, blockName);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
