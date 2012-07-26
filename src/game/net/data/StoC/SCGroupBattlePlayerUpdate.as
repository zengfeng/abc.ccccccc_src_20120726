package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xC3
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GBPlayerUpdateData;
	public dynamic final class SCGroupBattlePlayerUpdate extends com.protobuf.Message {
		 /**
		  *@playerUpdateData   playerUpdateData
		  **/
		public var playerUpdateData:Vector.<GBPlayerUpdateData> = new Vector.<GBPlayerUpdateData>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			playerUpdateData = new Vector.<GBPlayerUpdateData>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					playerUpdateData.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.GBPlayerUpdateData()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
