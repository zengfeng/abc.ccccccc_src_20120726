package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class PlayerPosition extends com.protobuf.Message {
		 /**
		  *@player_id   player_id
		  **/
		public var playerId:uint;

		 /**
		  *@avatarVer   avatarVer
		  **/
		public var avatarVer:uint;

		 /**
		  *@xy   xy
		  **/
		public var xy:uint;

		 /**
		  *@to_xy   to_xy
		  **/
		private var to_xy$field:uint;

		private var hasField$0:uint = 0;

		public function removeToXy():void {
			hasField$0 &= 0xfffffffe;
			to_xy$field = new uint();
		}

		public function get hasToXy():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set toXy(value:uint):void {
			hasField$0 |= 0x1;
			to_xy$field = value;
		}

		public function get toXy():uint {
			return to_xy$field;
		}

		 /**
		  *@when   when
		  **/
		private var when$field:uint;

		public function removeWhen():void {
			hasField$0 &= 0xfffffffd;
			when$field = new uint();
		}

		public function get hasWhen():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set when(value:uint):void {
			hasField$0 |= 0x2;
			when$field = value;
		}

		public function get when():uint {
			return when$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, avatarVer);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, xy);
			if (hasToXy) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, to_xy$field);
			}
			if (hasWhen) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, when$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player_id$count:uint = 0;
			var avatarVer$count:uint = 0;
			var xy$count:uint = 0;
			var to_xy$count:uint = 0;
			var when$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerPosition.playerId cannot be set twice.');
					}
					++player_id$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (avatarVer$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerPosition.avatarVer cannot be set twice.');
					}
					++avatarVer$count;
					avatarVer = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (xy$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerPosition.xy cannot be set twice.');
					}
					++xy$count;
					xy = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (to_xy$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerPosition.toXy cannot be set twice.');
					}
					++to_xy$count;
					toXy = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (when$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerPosition.when cannot be set twice.');
					}
					++when$count;
					when = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
