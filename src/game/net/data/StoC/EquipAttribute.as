package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class EquipAttribute extends com.protobuf.Message {
		 /**
		  *@typeID   typeID
		  **/
		public var typeID:uint;

		 /**
		  *@uniqueID   uniqueID
		  **/
		public var uniqueID:uint;

		 /**
		  *@position   position
		  **/
		private var position$field:uint;

		private var hasField$0:uint = 0;

		public function removePosition():void {
			hasField$0 &= 0xfffffffe;
			position$field = new uint();
		}

		public function get hasPosition():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set position(value:uint):void {
			hasField$0 |= 0x1;
			position$field = value;
		}

		public function get position():uint {
			return position$field;
		}

		 /**
		  *@enchantlv   enchantlv
		  **/
		private var enchantlv$field:uint;

		public function removeEnchantlv():void {
			hasField$0 &= 0xfffffffd;
			enchantlv$field = new uint();
		}

		public function get hasEnchantlv():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set enchantlv(value:uint):void {
			hasField$0 |= 0x2;
			enchantlv$field = value;
		}

		public function get enchantlv():uint {
			return enchantlv$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, typeID);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, uniqueID);
			if (hasPosition) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, position$field);
			}
			if (hasEnchantlv) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, enchantlv$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var typeID$count:uint = 0;
			var uniqueID$count:uint = 0;
			var position$count:uint = 0;
			var enchantlv$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (typeID$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipAttribute.typeID cannot be set twice.');
					}
					++typeID$count;
					typeID = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (uniqueID$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipAttribute.uniqueID cannot be set twice.');
					}
					++uniqueID$count;
					uniqueID = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (position$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipAttribute.position cannot be set twice.');
					}
					++position$count;
					position = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (enchantlv$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipAttribute.enchantlv cannot be set twice.');
					}
					++enchantlv$count;
					enchantlv = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
