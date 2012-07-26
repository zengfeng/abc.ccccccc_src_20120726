package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xC5
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GroupBattlePlayerData;
	public dynamic final class SCGroupBattlePlayerEnter extends com.protobuf.Message {
		 /**
		  *@playerData   playerData
		  **/
		public var playerData:game.net.data.StoC.GroupBattlePlayerData;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playerData$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playerData$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattlePlayerEnter.playerData cannot be set twice.');
					}
					++playerData$count;
					playerData = new game.net.data.StoC.GroupBattlePlayerData();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, playerData);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
