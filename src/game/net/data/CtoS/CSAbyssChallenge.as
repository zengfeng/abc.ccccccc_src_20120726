package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x292
	 **/
	import com.protobuf.*;
	public dynamic final class CSAbyssChallenge extends com.protobuf.Message {
		 /**
		  *@useGold   useGold
		  **/
		public var useGold:Boolean;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, useGold);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
