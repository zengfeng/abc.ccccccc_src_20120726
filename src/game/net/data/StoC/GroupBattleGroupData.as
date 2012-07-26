package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GroupBattleGroupData extends com.protobuf.Message {
		 /**
		  *@group   group
		  **/
		public var group:uint;

		 /**
		  *@playerNum   playerNum
		  **/
		public var playerNum:uint;

		 /**
		  *@score   score
		  **/
		public var score:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, group);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerNum);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, score);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var group$count:uint = 0;
			var playerNum$count:uint = 0;
			var score$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (group$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattleGroupData.group cannot be set twice.');
					}
					++group$count;
					group = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (playerNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattleGroupData.playerNum cannot be set twice.');
					}
					++playerNum$count;
					playerNum = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (score$count != 0) {
						throw new flash.errors.IOError('Bad data format: GroupBattleGroupData.score cannot be set twice.');
					}
					++score$count;
					score = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
