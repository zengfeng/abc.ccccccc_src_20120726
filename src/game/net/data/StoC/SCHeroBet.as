package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x79
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCHeroBet extends com.protobuf.Message {
		 /**
		  *@type   type
		  **/
		public var type:uint;

		 /**
		  *@count   count
		  **/
		public var count:uint;

		 /**
		  *@item   item
		  **/
		private var item$field:uint;

		private var hasField$0:uint = 0;

		public function removeItem():void {
			hasField$0 &= 0xfffffffe;
			item$field = new uint();
		}

		public function get hasItem():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set item(value:uint):void {
			hasField$0 |= 0x1;
			item$field = value;
		}

		public function get item():uint {
			return item$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			var count$count:uint = 0;
			var item$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCHeroBet.type cannot be set twice.');
					}
					++type$count;
					type = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (count$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCHeroBet.count cannot be set twice.');
					}
					++count$count;
					count = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (item$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCHeroBet.item cannot be set twice.');
					}
					++item$count;
					item = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
