package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class ContactPlayer extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@isMale   isMale
		  **/
		public var isMale:Boolean;

		 /**
		  *@isOnline   isOnline
		  **/
		public var isOnline:Boolean;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@potential   potential
		  **/
		public var potential:uint;

		 /**
		  *@job   job
		  **/
		public var job:uint;

		 /**
		  *@group   group
		  **/
		private var group$field:uint;

		private var hasField$0:uint = 0;

		public function removeGroup():void {
			hasField$0 &= 0xfffffffe;
			group$field = new uint();
		}

		public function get hasGroup():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set group(value:uint):void {
			hasField$0 |= 0x1;
			group$field = value;
		}

		public function get group():uint {
			return group$field;
		}

		 /**
		  *@serverId   serverId
		  **/
		private var serverId$field:uint;

		public function removeServerId():void {
			hasField$0 &= 0xfffffffd;
			serverId$field = new uint();
		}

		public function get hasServerId():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set serverId(value:uint):void {
			hasField$0 |= 0x2;
			serverId$field = value;
		}

		public function get serverId():uint {
			return serverId$field;
		}

		 /**
		  *@relation   relation
		  **/
		public var relation:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, isMale);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, isOnline);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, level);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, potential);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 7);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, job);
			if (hasGroup) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 8);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, group$field);
			}
			if (hasServerId) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 9);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, serverId$field);
			}
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 10);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, relation);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var name$count:uint = 0;
			var isMale$count:uint = 0;
			var isOnline$count:uint = 0;
			var level$count:uint = 0;
			var potential$count:uint = 0;
			var job$count:uint = 0;
			var group$count:uint = 0;
			var serverId$count:uint = 0;
			var relation$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (isMale$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.isMale cannot be set twice.');
					}
					++isMale$count;
					isMale = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 4:
					if (isOnline$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.isOnline cannot be set twice.');
					}
					++isOnline$count;
					isOnline = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 5:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (job$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.job cannot be set twice.');
					}
					++job$count;
					job = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (group$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.group cannot be set twice.');
					}
					++group$count;
					group = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (serverId$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.serverId cannot be set twice.');
					}
					++serverId$count;
					serverId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (relation$count != 0) {
						throw new flash.errors.IOError('Bad data format: ContactPlayer.relation cannot be set twice.');
					}
					++relation$count;
					relation = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
