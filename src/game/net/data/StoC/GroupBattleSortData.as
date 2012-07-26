package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GroupBattleSortData extends com.protobuf.Message {
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
		  *@maxKillStreak   maxKillStreak
		  **/
		public var maxKillStreak:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, group);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, playerName);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, maxKillStreak);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var group$count:uint = 0;
			var playerId$count:uint = 0;
			var playerName$count:uint = 0;
			var maxKillStreak$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (group$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattleSortData.group cannot be set twice.');
					}
					++group$count;
					group = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattleSortData.playerId cannot be set twice.');
					}
					++playerId$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (playerName$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattleSortData.playerName cannot be set twice.');
					}
					++playerName$count;
					playerName = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (maxKillStreak$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattleSortData.maxKillStreak cannot be set twice.');
					}
					++maxKillStreak$count;
					maxKillStreak = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
