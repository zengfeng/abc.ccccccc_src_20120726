package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GuildReserves extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@rank   rank
		  **/
		public var rank:uint;

		 /**
		  *@potential   potential
		  **/
		public var potential:uint;

		 /**
		  *@latestonl   latestonl
		  **/
		private var latestonl$field:uint;

		private var hasField$0:uint = 0;

		public function removeLatestonl():void {
			hasField$0 &= 0xfffffffe;
			latestonl$field = new uint();
		}

		public function get hasLatestonl():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set latestonl(value:uint):void {
			hasField$0 |= 0x1;
			latestonl$field = value;
		}

		public function get latestonl():uint {
			return latestonl$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, level);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, rank);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, potential);
			if (hasLatestonl) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, latestonl$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var name$count:uint = 0;
			var level$count:uint = 0;
			var rank$count:uint = 0;
			var potential$count:uint = 0;
			var latestonl$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildReserves.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildReserves.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildReserves.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildReserves.rank cannot be set twice.');
					}
					++rank$count;
					rank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildReserves.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (latestonl$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildReserves.latestonl cannot be set twice.');
					}
					++latestonl$count;
					latestonl = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
