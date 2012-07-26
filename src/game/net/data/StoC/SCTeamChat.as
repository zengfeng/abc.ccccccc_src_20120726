package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x93
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCTeamChat extends com.protobuf.Message {
		 /**
		  *@from   from
		  **/
		public var from:String;

		 /**
		  *@content   content
		  **/
		public var content:String;

		 /**
		  *@potential   potential
		  **/
		public var potential:uint;

		 /**
		  *@server   server
		  **/
		private var server$field:uint;

		private var hasField$0:uint = 0;

		public function removeServer():void {
			hasField$0 &= 0xfffffffe;
			server$field = new uint();
		}

		public function get hasServer():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set server(value:uint):void {
			hasField$0 |= 0x1;
			server$field = value;
		}

		public function get server():uint {
			return server$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var from$count:uint = 0;
			var content$count:uint = 0;
			var potential$count:uint = 0;
			var server$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (from$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTeamChat.from cannot be set twice.');
					}
					++from$count;
					from = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (content$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTeamChat.content cannot be set twice.');
					}
					++content$count;
					content = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTeamChat.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (server$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTeamChat.server cannot be set twice.');
					}
					++server$count;
					server = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
