package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x39
	 **/
	import com.protobuf.*;
	public dynamic final class CSPlotEnd extends com.protobuf.Message {
		 /**
		  *@plotId   plotId
		  **/
		public var plotId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, plotId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
