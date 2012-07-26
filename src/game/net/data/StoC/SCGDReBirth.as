package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xF9
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGDReBirth extends com.protobuf.Message {
		 /**
		  *@result   result
		  **/
		private var result$field:uint;

		private var hasField$0:uint = 0;

		public function removeResult():void {
			hasField$0 &= 0xfffffffe;
			result$field = new uint();
		}

		public function get hasResult():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set result(value:uint):void {
			hasField$0 |= 0x1;
			result$field = value;
		}

		public function get result():uint {
			return result$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDReBirth.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
