package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x43
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCRemoveContact extends com.protobuf.Message {
		 /**
		  *@player   player
		  **/
		public var player:uint;

		 /**
		  *@operation   operation
		  **/
		private var operation$field:uint;

		private var hasField$0:uint = 0;

		public function removeOperation():void {
			hasField$0 &= 0xfffffffe;
			operation$field = new uint();
		}

		public function get hasOperation():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set operation(value:uint):void {
			hasField$0 |= 0x1;
			operation$field = value;
		}

		public function get operation():uint {
			return operation$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player$count:uint = 0;
			var operation$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRemoveContact.player cannot be set twice.');
					}
					++player$count;
					player = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (operation$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCRemoveContact.operation cannot be set twice.');
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
