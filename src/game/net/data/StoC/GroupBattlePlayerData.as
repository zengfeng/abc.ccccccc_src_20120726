package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GroupBattlePlayerData extends com.protobuf.Message {
		 /**
		  *@group   group
		  **/
		public var group:uint;

		 /**
		  *@playerId   playerId
		  **/
		public var playerId:uint;

		 /**
		  *@playerName   playerName
		  **/
		public var playerName:String;

		 /**
		  *@isMale   isMale
		  **/
		public var isMale:Boolean;

		 /**
		  *@job   job
		  **/
		public var job:uint;

		 /**
		  *@playerSatus   playerSatus
		  **/
		public var playerSatus:uint;

		 /**
		  *@waitTime   waitTime
		  **/
		public var waitTime:uint;

		 /**
		  *@killStreak   killStreak
		  **/
		public var killStreak:uint;

		 /**
		  *@maxKillStreak   maxKillStreak
		  **/
		public var maxKillStreak:uint;

		 /**
		  *@winCount   winCount
		  **/
		public var winCount:uint;

		 /**
		  *@loseCount   loseCount
		  **/
		public var loseCount:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, group);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, playerName);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, isMale);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, job);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerSatus);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 7);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, waitTime);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 8);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, killStreak);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 9);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, maxKillStreak);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 10);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, winCount);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 11);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, loseCount);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var group$count:uint = 0;
			var playerId$count:uint = 0;
			var playerName$count:uint = 0;
			var isMale$count:uint = 0;
			var job$count:uint = 0;
			var playerSatus$count:uint = 0;
			var waitTime$count:uint = 0;
			var killStreak$count:uint = 0;
			var maxKillStreak$count:uint = 0;
			var winCount$count:uint = 0;
			var loseCount$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (group$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.group cannot be set twice.');
					}
					++group$count;
					group = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.playerId cannot be set twice.');
					}
					++playerId$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (playerName$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.playerName cannot be set twice.');
					}
					++playerName$count;
					playerName = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (isMale$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.isMale cannot be set twice.');
					}
					++isMale$count;
					isMale = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 5:
					if (job$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.job cannot be set twice.');
					}
					++job$count;
					job = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (playerSatus$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.playerSatus cannot be set twice.');
					}
					++playerSatus$count;
					playerSatus = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (waitTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.waitTime cannot be set twice.');
					}
					++waitTime$count;
					waitTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (killStreak$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.killStreak cannot be set twice.');
					}
					++killStreak$count;
					killStreak = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (maxKillStreak$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.maxKillStreak cannot be set twice.');
					}
					++maxKillStreak$count;
					maxKillStreak = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (winCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.winCount cannot be set twice.');
					}
					++winCount$count;
					winCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (loseCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattlePlayerData.loseCount cannot be set twice.');
					}
					++loseCount$count;
					loseCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
