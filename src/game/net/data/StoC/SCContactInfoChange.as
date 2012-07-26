package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x42
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCContactInfoChange extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@isOnline   isOnline
		  **/
		private var isOnline$field:Boolean;

		private var hasField$0:uint = 0;

		public function removeIsOnline():void {
			hasField$0 &= 0xfffffffe;
			isOnline$field = new Boolean();
		}

		public function get hasIsOnline():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set isOnline(value:Boolean):void {
			hasField$0 |= 0x1;
			isOnline$field = value;
		}

		public function get isOnline():Boolean {
			return isOnline$field;
		}

		 /**
		  *@level   level
		  **/
		private var level$field:uint;

		public function removeLevel():void {
			hasField$0 &= 0xfffffffd;
			level$field = new uint();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set level(value:uint):void {
			hasField$0 |= 0x2;
			level$field = value;
		}

		public function get level():uint {
			return level$field;
		}

		 /**
		  *@potential   potential
		  **/
		private var potential$field:uint;

		public function removePotential():void {
			hasField$0 &= 0xfffffffb;
			potential$field = new uint();
		}

		public function get hasPotential():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set potential(value:uint):void {
			hasField$0 |= 0x4;
			potential$field = value;
		}

		public function get potential():uint {
			return potential$field;
		}

		 /**
		  *@group   group
		  **/
		private var group$field:uint;

		public function removeGroup():void {
			hasField$0 &= 0xfffffff7;
			group$field = new uint();
		}

		public function get hasGroup():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set group(value:uint):void {
			hasField$0 |= 0x8;
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
			hasField$0 &= 0xffffffef;
			serverId$field = new uint();
		}

		public function get hasServerId():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set serverId(value:uint):void {
			hasField$0 |= 0x10;
			serverId$field = value;
		}

		public function get serverId():uint {
			return serverId$field;
		}

		 /**
		  *@relation   relation
		  **/
		private var relation$field:uint;

		public function removeRelation():void {
			hasField$0 &= 0xffffffdf;
			relation$field = new uint();
		}

		public function get hasRelation():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set relation(value:uint):void {
			hasField$0 |= 0x20;
			relation$field = value;
		}

		public function get relation():uint {
			return relation$field;
		}

		 /**
		  *@operation   operation
		  **/
		private var operation$field:uint;

		public function removeOperation():void {
			hasField$0 &= 0xffffffbf;
			operation$field = new uint();
		}

		public function get hasOperation():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set operation(value:uint):void {
			hasField$0 |= 0x40;
			operation$field = value;
		}

		public function get operation():uint {
			return operation$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var isOnline$count:uint = 0;
			var level$count:uint = 0;
			var potential$count:uint = 0;
			var group$count:uint = 0;
			var serverId$count:uint = 0;
			var relation$count:uint = 0;
			var operation$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCContactInfoChange.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (isOnline$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCContactInfoChange.isOnline cannot be set twice.');
					}
					++isOnline$count;
					isOnline = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 3:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCContactInfoChange.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCContactInfoChange.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (group$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCContactInfoChange.group cannot be set twice.');
					}
					++group$count;
					group = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (serverId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCContactInfoChange.serverId cannot be set twice.');
					}
					++serverId$count;
					serverId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (relation$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCContactInfoChange.relation cannot be set twice.');
					}
					++relation$count;
					relation = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (operation$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCContactInfoChange.operation cannot be set twice.');
					}
					++operation$count;
					operation = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
