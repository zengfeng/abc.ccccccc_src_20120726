package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x201
	 **/
	import com.protobuf.*;
	public dynamic final class CSUseItem extends com.protobuf.Message {
		 /**
		  *@itemId   itemId
		  **/
		public var itemId:uint;

		 /**
		  *@HeroId   HeroId
		  **/
		public var heroId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, heroId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
