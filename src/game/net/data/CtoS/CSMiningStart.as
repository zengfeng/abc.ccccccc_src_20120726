package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x1D0
	 **/
	import com.protobuf.*;
	public dynamic final class CSMiningStart extends com.protobuf.Message {
		 /**
		  *@useGold   useGold
		  **/
		public var useGold:Boolean;

		 /**
		  *@batch   batch
		  **/
		public var batch:Boolean;

		 /**
		  *@mineralId   mineralId
		  **/
		public var mineralId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, useGold);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, batch);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, mineralId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
