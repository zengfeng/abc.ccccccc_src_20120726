package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2D
	 **/
	import com.protobuf.*;
	public dynamic final class CSTrainStart extends com.protobuf.Message {
		 /**
		  *@action   action
		  **/
		public var action:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, action);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
