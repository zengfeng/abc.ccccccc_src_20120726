package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x36
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCFishDraw extends com.protobuf.Message {
		 /**
		  *@ret   ret
		  **/
		public var ret:uint;

		 /**
		  *@itemId   itemId
		  **/
		private var itemId$field:uint;

		private var hasField$0:uint = 0;

		public function removeItemId():void {
			hasField$0 &= 0xfffffffe;
			itemId$field = new uint();
		}

		public function get hasItemId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set itemId(value:uint):void {
			hasField$0 |= 0x1;
			itemId$field = value;
		}

		public function get itemId():uint {
			return itemId$field;
		}

		 /**
		  *@leftTimes   leftTimes
		  **/
		private var leftTimes$field:uint;

		public function removeLeftTimes():void {
			hasField$0 &= 0xfffffffd;
			leftTimes$field = new uint();
		}

		public function get hasLeftTimes():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set leftTimes(value:uint):void {
			hasField$0 |= 0x2;
			leftTimes$field = value;
		}

		public function get leftTimes():uint {
			return leftTimes$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var ret$count:uint = 0;
			var itemId$count:uint = 0;
			var leftTimes$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (ret$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFishDraw.ret cannot be set twice.');
					}
					++ret$count;
					ret = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (itemId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFishDraw.itemId cannot be set twice.');
					}
					++itemId$count;
					itemId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (leftTimes$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFishDraw.leftTimes cannot be set twice.');
					}
					++leftTimes$count;
					leftTimes = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
