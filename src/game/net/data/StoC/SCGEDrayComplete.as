package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2F4
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGEDrayComplete extends com.protobuf.Message {
		 /**
		  *@drayId   drayId
		  **/
		public var drayId:uint;

		 /**
		  *@success   success
		  **/
		private var success$field:Boolean;

		private var hasField$0:uint = 0;

		public function removeSuccess():void {
			hasField$0 &= 0xfffffffe;
			success$field = new Boolean();
		}

		public function get hasSuccess():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set success(value:Boolean):void {
			hasField$0 |= 0x1;
			success$field = value;
		}

		public function get success():Boolean {
			return success$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var drayId$count:uint = 0;
			var success$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (drayId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEDrayComplete.drayId cannot be set twice.');
					}
					++drayId$count;
					drayId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (success$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEDrayComplete.success cannot be set twice.');
					}
					++success$count;
					success = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
