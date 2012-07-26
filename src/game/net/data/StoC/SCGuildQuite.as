package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2C6
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGuildQuite extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@kick   kick
		  **/
		private var kick$field:uint;

		private var hasField$0:uint = 0;

		public function removeKick():void {
			hasField$0 &= 0xfffffffe;
			kick$field = new uint();
		}

		public function get hasKick():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set kick(value:uint):void {
			hasField$0 |= 0x1;
			kick$field = value;
		}

		public function get kick():uint {
			return kick$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var kick$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildQuite.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (kick$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildQuite.kick cannot be set twice.');
					}
					++kick$count;
					kick = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
