package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x29
	 **/
	import com.protobuf.*;
	public dynamic final class CSHeroPotential extends com.protobuf.Message {
		 /**
		  *@heroID   heroID
		  **/
		public var heroID:uint;

		 /**
		  *@protect   protect
		  **/
		public var protect:Boolean;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, heroID);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, protect);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
