package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x61
	 **/
	import com.protobuf.*;
	public dynamic final class CSAttackMonster extends com.protobuf.Message {
		 /**
		  *@monsterId   monsterId
		  **/
		public var monsterId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, monsterId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
