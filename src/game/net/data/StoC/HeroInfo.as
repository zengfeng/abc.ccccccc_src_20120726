package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class HeroInfo extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@skillID   skillID
		  **/
		public var skillID:uint;

		 /**
		  *@potential   potential
		  **/
		private var potential$field:uint;

		private var hasField$0:uint = 0;

		public function removePotential():void {
			hasField$0 &= 0xfffffffe;
			potential$field = new uint();
		}

		public function get hasPotential():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set potential(value:uint):void {
			hasField$0 |= 0x1;
			potential$field = value;
		}

		public function get potential():uint {
			return potential$field;
		}

		 /**
		  *@wpLevel   wpLevel
		  **/
		private var wpLevel$field:uint;

		public function removeWpLevel():void {
			hasField$0 &= 0xfffffffd;
			wpLevel$field = new uint();
		}

		public function get hasWpLevel():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set wpLevel(value:uint):void {
			hasField$0 |= 0x2;
			wpLevel$field = value;
		}

		public function get wpLevel():uint {
			return wpLevel$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, skillID);
			if (hasPotential) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, potential$field);
			}
			if (hasWpLevel) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, wpLevel$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var skillID$count:uint = 0;
			var potential$count:uint = 0;
			var wpLevel$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: HeroInfo.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (skillID$count != 0) {
						throw new flash.errors.IOError('Bad data format: HeroInfo.skillID cannot be set twice.');
					}
					++skillID$count;
					skillID = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: HeroInfo.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (wpLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: HeroInfo.wpLevel cannot be set twice.');
					}
					++wpLevel$count;
					wpLevel = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
