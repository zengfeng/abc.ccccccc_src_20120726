package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x45
	 **/
	import com.protobuf.*;
	public dynamic final class CSFollowId extends com.protobuf.Message {
		 /**
		  *@isForce   isForce
		  **/
		public var isForce:Boolean = false;

		 /**
		  *@playerId   playerId
		  **/
		public var playerId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, isForce);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
