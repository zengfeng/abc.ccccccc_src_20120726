package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xCA
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GroupBattleGroupData;
	public dynamic final class SCGroupBattleGroupDataReply extends com.protobuf.Message {
		 /**
		  *@groupData   groupData
		  **/
		public var groupData:game.net.data.StoC.GroupBattleGroupData;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var groupData$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (groupData$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleGroupDataReply.groupData cannot be set twice.');
					}
					++groupData$count;
					groupData = new game.net.data.StoC.GroupBattleGroupData();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, groupData);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
