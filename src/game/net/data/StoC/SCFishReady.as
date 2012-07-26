package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x3B
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCFishReady extends com.protobuf.Message {
		 /**
		  *@leftTimes   leftTimes
		  **/
		public var leftTimes:uint;

		 /**
		  *@quality   quality
		  **/
		private var quality$field:uint;

		private var hasField$0:uint = 0;

		public function removeQuality():void {
			hasField$0 &= 0xfffffffe;
			quality$field = new uint();
		}

		public function get hasQuality():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set quality(value:uint):void {
			hasField$0 |= 0x1;
			quality$field = value;
		}

		public function get quality():uint {
			return quality$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var leftTimes$count:uint = 0;
			var quality$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (leftTimes$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFishReady.leftTimes cannot be set twice.');
					}
					++leftTimes$count;
					leftTimes = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (quality$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFishReady.quality cannot be set twice.');
					}
					++quality$count;
					quality = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
