package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x291
	 **/
	import com.protobuf.*;
	public dynamic final class CSMergeSoulAll extends com.protobuf.Message {
		 /**
		  *@mergeBound   mergeBound
		  **/
		public var mergeBound:Boolean;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, mergeBound);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
