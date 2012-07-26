package game.net.data.StoC.SCGDStateList {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GuildBossPlayerState extends com.protobuf.Message {
		 /**
		  *@playerid   playerid
		  **/
		public var playerid:uint;

		 /**
		  *@state   state
		  **/
		public var state:uint;

		 /**
		  *@lefttime   lefttime
		  **/
		private var lefttime$field:uint;

		private var hasField$0:uint = 0;

		public function removeLefttime():void {
			hasField$0 &= 0xfffffffe;
			lefttime$field = new uint();
		}

		public function get hasLefttime():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set lefttime(value:uint):void {
			hasField$0 |= 0x1;
			lefttime$field = value;
		}

		public function get lefttime():uint {
			return lefttime$field;
		}

		 /**
		  *@goldnum   goldnum
		  **/
		private var goldnum$field:uint;

		public function removeGoldnum():void {
			hasField$0 &= 0xfffffffd;
			goldnum$field = new uint();
		}

		public function get hasGoldnum():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set goldnum(value:uint):void {
			hasField$0 |= 0x2;
			goldnum$field = value;
		}

		public function get goldnum():uint {
			return goldnum$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, state);
			if (hasLefttime) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, lefttime$field);
			}
			if (hasGoldnum) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, goldnum$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playerid$count:uint = 0;
			var state$count:uint = 0;
			var lefttime$count:uint = 0;
			var goldnum$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playerid$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildBossPlayerState.playerid cannot be set twice.');
					}
					++playerid$count;
					playerid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (state$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildBossPlayerState.state cannot be set twice.');
					}
					++state$count;
					state = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (lefttime$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildBossPlayerState.lefttime cannot be set twice.');
					}
					++lefttime$count;
					lefttime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (goldnum$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildBossPlayerState.goldnum cannot be set twice.');
					}
					++goldnum$count;
					goldnum = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
