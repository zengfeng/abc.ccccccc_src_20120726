package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x0F
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCPlayerId extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@name   name
		  **/
		private var name$field:String;

		public function removeName():void {
			name$field = null;
		}

		public function get hasName():Boolean {
			return name$field != null;
		}

		public function set name(value:String):void {
			name$field = value;
		}

		public function get name():String {
			return name$field;
		}

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
		  *@server   server
		  **/
		private var server$field:uint;

		public function removeServer():void {
			hasField$0 &= 0xfffffffd;
			server$field = new uint();
		}

		public function get hasServer():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set server(value:uint):void {
			hasField$0 |= 0x2;
			server$field = value;
		}

		public function get server():uint {
			return server$field;
		}

		 /**
		  *@level   level
		  **/
		private var level$field:uint;

		public function removeLevel():void {
			hasField$0 &= 0xfffffffb;
			level$field = new uint();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set level(value:uint):void {
			hasField$0 |= 0x4;
			level$field = value;
		}

		public function get level():uint {
			return level$field;
		}

		 /**
		  *@blocked   blocked
		  **/
		private var blocked$field:Boolean;

		public function removeBlocked():void {
			hasField$0 &= 0xfffffff7;
			blocked$field = new Boolean();
		}

		public function get hasBlocked():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set blocked(value:Boolean):void {
			hasField$0 |= 0x8;
			blocked$field = value;
		}

		public function get blocked():Boolean {
			return blocked$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var name$count:uint = 0;
			var potential$count:uint = 0;
			var server$count:uint = 0;
			var level$count:uint = 0;
			var blocked$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerId.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerId.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerId.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (server$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerId.server cannot be set twice.');
					}
					++server$count;
					server = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerId.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (blocked$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerId.blocked cannot be set twice.');
					}
					++blocked$count;
					blocked = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
