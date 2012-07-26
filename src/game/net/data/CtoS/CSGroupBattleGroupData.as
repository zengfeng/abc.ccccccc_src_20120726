package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xCA
	 **/
	import com.protobuf.*;
	public dynamic final class CSGroupBattleGroupData extends com.protobuf.Message {
		 /**
		  *@groupId   groupId
		  **/
		public var groupId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, groupId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
