package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x1C
	 **/
	import com.protobuf.*;
	public dynamic final class CSSetSquad extends com.protobuf.Message {
		 /**
		  *@formation   formation
		  **/
		public var formation:uint;

		 /**
		  *@heroId   heroId
		  **/
		public var heroId:uint;

		 /**
		  *@position   position
		  **/
		public var position:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, formation);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, heroId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, position);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
