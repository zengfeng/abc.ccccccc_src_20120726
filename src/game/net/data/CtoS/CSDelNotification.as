package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x59
	 **/
	import com.protobuf.*;
	public dynamic final class CSDelNotification extends com.protobuf.Message {
		 /**
		  *@idList   idList
		  **/
		public var idList:Vector.<uint> = new Vector.<uint>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (idList != null && idList.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, idList);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
