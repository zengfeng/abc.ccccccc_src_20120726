package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xC7
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGroupBattlePlayerLost extends com.protobuf.Message {
		 /**
		  *@playerId   playerId
		  **/
		public var playerId:uint;

		 /**
		  *@groupScore   groupScore
		  **/
		public var groupScore:uint;

		 /**
		  *@silver   silver
		  **/
		public var silver:uint;

		 /**
		  *@donateCnt   donateCnt
		  **/
		public var donateCnt:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playerId$count:uint = 0;
			var groupScore$count:uint = 0;
			var silver$count:uint = 0;
			var donateCnt$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattlePlayerLost.playerId cannot be set twice.');
					}
					++playerId$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (groupScore$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattlePlayerLost.groupScore cannot be set twice.');
					}
					++groupScore$count;
					groupScore = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (silver$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattlePlayerLost.silver cannot be set twice.');
					}
					++silver$count;
					silver = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (donateCnt$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattlePlayerLost.donateCnt cannot be set twice.');
					}
					++donateCnt$count;
					donateCnt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
