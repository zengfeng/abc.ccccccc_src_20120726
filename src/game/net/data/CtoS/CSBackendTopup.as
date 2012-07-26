package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xE001
	 **/
	import com.protobuf.*;
	public dynamic final class CSBackendTopup extends com.protobuf.Message {
		 /**
		  *@topupId   topupId
		  **/
		public var topupId:String;

		 /**
		  *@playerId   playerId
		  **/
		public var playerId:String;

		 /**
		  *@amount   amount
		  **/
		public var amount:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, topupId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, playerId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, amount);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
