package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xC2
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GBUpdateData;
	public dynamic final class SCGroupBattleUpdate extends com.protobuf.Message {
		 /**
		  *@updateData   updateData
		  **/
		public var updateData:Vector.<GBUpdateData> = new Vector.<GBUpdateData>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			updateData = new Vector.<GBUpdateData>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					updateData.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.GBUpdateData()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
