package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2F9
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGEEnterInfo extends com.protobuf.Message {
		 /**
		  *@player   player
		  **/
		public var player:uint;

		 /**
		  *@status   status
		  **/
		private var status$field:uint;

		private var hasField$0:uint = 0;

		public function removeStatus():void {
			hasField$0 &= 0xfffffffe;
			status$field = new uint();
		}

		public function get hasStatus():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set status(value:uint):void {
			hasField$0 |= 0x1;
			status$field = value;
		}

		public function get status():uint {
			return status$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player$count:uint = 0;
			var status$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEEnterInfo.player cannot be set twice.');
					}
					++player$count;
					player = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEEnterInfo.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
