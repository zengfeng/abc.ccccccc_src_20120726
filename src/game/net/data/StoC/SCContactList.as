package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x41
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.ContactPlayer;
	public dynamic final class SCContactList extends com.protobuf.Message {
		 /**
		  *@playerList   playerList
		  **/
		public var playerList:Vector.<ContactPlayer> = new Vector.<ContactPlayer>();

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
			playerList = new Vector.<ContactPlayer>();

			var operation$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					playerList.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.ContactPlayer()));
					break;
				case 2:
					if (operation$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCContactList.operation cannot be set twice.');
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
