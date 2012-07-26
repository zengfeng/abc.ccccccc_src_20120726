package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xC0
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GroupBattleGroupData;
	import game.net.data.StoC.GroupBattleSortData;
	import game.net.data.StoC.GroupBattlePlayerData;
	public dynamic final class SCGroupBattleEnter extends com.protobuf.Message {
		 /**
		  *@result   result
		  **/
		public var result:uint;

		 /**
		  *@playerList   playerList
		  **/
		public var playerList:Vector.<GroupBattlePlayerData> = new Vector.<GroupBattlePlayerData>();

		 /**
		  *@totalWin   totalWin
		  **/
		public var totalWin:uint;

		 /**
		  *@totalLose   totalLose
		  **/
		public var totalLose:uint;

		 /**
		  *@totalSilver   totalSilver
		  **/
		public var totalSilver:uint;

		 /**
		  *@totalDonate   totalDonate
		  **/
		public var totalDonate:uint;

		 /**
		  *@surplusTime   surplusTime
		  **/
		public var surplusTime:uint;

		 /**
		  *@groupData   groupData
		  **/
		public var groupData:Vector.<GroupBattleGroupData> = new Vector.<GroupBattleGroupData>();

		 /**
		  *@sortList   sortList
		  **/
		public var sortList:game.net.data.StoC.GroupBattleSortData;

		 /**
		  *@hasHighlevel   hasHighlevel
		  **/
		public var hasHighlevel:Boolean;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			playerList = new Vector.<GroupBattlePlayerData>();

			var totalWin$count:uint = 0;
			var totalLose$count:uint = 0;
			var totalSilver$count:uint = 0;
			var totalDonate$count:uint = 0;
			var surplusTime$count:uint = 0;
			groupData = new Vector.<GroupBattleGroupData>();

			var sortList$count:uint = 0;
			var hasHighlevel$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleEnter.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					playerList.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.GroupBattlePlayerData()));
					break;
				case 4:
					if (totalWin$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleEnter.totalWin cannot be set twice.');
					}
					++totalWin$count;
					totalWin = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (totalLose$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleEnter.totalLose cannot be set twice.');
					}
					++totalLose$count;
					totalLose = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (totalSilver$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleEnter.totalSilver cannot be set twice.');
					}
					++totalSilver$count;
					totalSilver = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (totalDonate$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleEnter.totalDonate cannot be set twice.');
					}
					++totalDonate$count;
					totalDonate = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (surplusTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleEnter.surplusTime cannot be set twice.');
					}
					++surplusTime$count;
					surplusTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					groupData.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.GroupBattleGroupData()));
					break;
				case 10:
					if (sortList$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleEnter.sortList cannot be set twice.');
					}
					++sortList$count;
					sortList = new game.net.data.StoC.GroupBattleSortData();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, sortList);
					break;
				case 11:
					if (hasHighlevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleEnter.hasHighlevel cannot be set twice.');
					}
					++hasHighlevel$count;
					hasHighlevel = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
