package game.net.data.StoC.SCMultiAvatarInfoChange {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class AvatarInfoChange extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@avatarVer   avatarVer
		  **/
		public var avatarVer:uint;

		 /**
		  *@level   level
		  **/
		private var level$field:uint;

		private var hasField$0:uint = 0;

		public function removeLevel():void {
			hasField$0 &= 0xfffffffe;
			level$field = new uint();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set level(value:uint):void {
			hasField$0 |= 0x1;
			level$field = value;
		}

		public function get level():uint {
			return level$field;
		}

		 /**
		  *@cloth   cloth
		  **/
		private var cloth$field:uint;

		public function removeCloth():void {
			hasField$0 &= 0xfffffffd;
			cloth$field = new uint();
		}

		public function get hasCloth():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set cloth(value:uint):void {
			hasField$0 |= 0x2;
			cloth$field = value;
		}

		public function get cloth():uint {
			return cloth$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, avatarVer);
			if (hasLevel) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, level$field);
			}
			if (hasCloth) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, cloth$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var avatarVer$count:uint = 0;
			var level$count:uint = 0;
			var cloth$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: AvatarInfoChange.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (avatarVer$count != 0) {
						throw new flash.errors.IOError('Bad data format: AvatarInfoChange.avatarVer cannot be set twice.');
					}
					++avatarVer$count;
					avatarVer = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: AvatarInfoChange.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (cloth$count != 0) {
						throw new flash.errors.IOError('Bad data format: AvatarInfoChange.cloth cannot be set twice.');
					}
					++cloth$count;
					cloth = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
