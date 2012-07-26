package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GEDrayData extends com.protobuf.Message {
		 /**
		  *@drayId   drayId
		  **/
		public var drayId:uint;

		 /**
		  *@status   status
		  **/
		public var status:uint;

		 /**
		  *@HP   HP
		  **/
		private var HP$field:uint;

		private var hasField$0:uint = 0;

		public function removeHP():void {
			hasField$0 &= 0xfffffffe;
			HP$field = new uint();
		}

		public function get hasHP():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set hP(value:uint):void {
			hasField$0 |= 0x1;
			HP$field = value;
		}

		public function get hP():uint {
			return HP$field;
		}

		 /**
		  *@monsterHP   monsterHP
		  **/
		private var monsterHP$field:uint;

		public function removeMonsterHP():void {
			hasField$0 &= 0xfffffffd;
			monsterHP$field = new uint();
		}

		public function get hasMonsterHP():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set monsterHP(value:uint):void {
			hasField$0 |= 0x2;
			monsterHP$field = value;
		}

		public function get monsterHP():uint {
			return monsterHP$field;
		}

		 /**
		  *@monsterTotalHP   monsterTotalHP
		  **/
		private var monsterTotalHP$field:uint;

		public function removeMonsterTotalHP():void {
			hasField$0 &= 0xfffffffb;
			monsterTotalHP$field = new uint();
		}

		public function get hasMonsterTotalHP():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set monsterTotalHP(value:uint):void {
			hasField$0 |= 0x4;
			monsterTotalHP$field = value;
		}

		public function get monsterTotalHP():uint {
			return monsterTotalHP$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, drayId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, status);
			if (hasHP) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, HP$field);
			}
			if (hasMonsterHP) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, monsterHP$field);
			}
			if (hasMonsterTotalHP) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, monsterTotalHP$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var drayId$count:uint = 0;
			var status$count:uint = 0;
			var HP$count:uint = 0;
			var monsterHP$count:uint = 0;
			var monsterTotalHP$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (drayId$count != 0) {
						throw new flash.errors.IOError('Bad data format: GEDrayData.drayId cannot be set twice.');
					}
					++drayId$count;
					drayId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: GEDrayData.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (HP$count != 0) {
						throw new flash.errors.IOError('Bad data format: GEDrayData.hP cannot be set twice.');
					}
					++HP$count;
					hP = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (monsterHP$count != 0) {
						throw new flash.errors.IOError('Bad data format: GEDrayData.monsterHP cannot be set twice.');
					}
					++monsterHP$count;
					monsterHP = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (monsterTotalHP$count != 0) {
						throw new flash.errors.IOError('Bad data format: GEDrayData.monsterTotalHP cannot be set twice.');
					}
					++monsterTotalHP$count;
					monsterTotalHP = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
