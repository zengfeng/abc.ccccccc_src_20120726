package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x3E
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCInstantFish extends com.protobuf.Message {
		 /**
		  *@ret   ret
		  **/
		private var ret$field:uint;

		private var hasField$0:uint = 0;

		public function removeRet():void {
			hasField$0 &= 0xfffffffe;
			ret$field = new uint();
		}

		public function get hasRet():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set ret(value:uint):void {
			hasField$0 |= 0x1;
			ret$field = value;
		}

		public function get ret():uint {
			return ret$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var ret$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (ret$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCInstantFish.ret cannot be set twice.');
					}
					++ret$count;
					ret = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
