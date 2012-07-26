package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x4D
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCRecentContact extends com.protobuf.Message {
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
		  *@serverId   serverId
		  **/
		private var serverId$field:uint;

		private var hasField$0:uint = 0;

		public function removeServerId():void {
			hasField$0 &= 0xfffffffe;
			serverId$field = new uint();
		}

		public function get hasServerId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set serverId(value:uint):void {
			hasField$0 |= 0x1;
			serverId$field = value;
		}

		public function get serverId():uint {
			return serverId$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var name$count:uint = 0;
			var isMale$count:uint = 0;
			var isOnline$count:uint = 0;
			var level$count:uint = 0;
			var potential$count:uint = 0;
			var job$count:uint = 0;
			var serverId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRecentContact.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRecentContact.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (isMale$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRecentContact.isMale cannot be set twice.');
					}
					++isMale$count;
					isMale = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 4:
					if (isOnline$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRecentContact.isOnline cannot be set twice.');
					}
					++isOnline$count;
					isOnline = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 5:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRecentContact.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRecentContact.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (job$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRecentContact.job cannot be set twice.');
					}
					++job$count;
					job = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (serverId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRecentContact.serverId cannot be set twice.');
					}
					++serverId$count;
					serverId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
