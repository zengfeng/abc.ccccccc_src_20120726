package game.net.data.StoC.SCStoreQuery {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class StoreItem extends com.protobuf.Message {
		 /**
		  *@itemId   itemId
		  **/
		public var itemId:uint;

		 /**
		  *@itemPrice1   itemPrice1
		  **/
		public var itemPrice1:uint;

		 /**
		  *@itemPrice2   itemPrice2
		  **/
		private var itemPrice2$field:uint;

		private var hasField$0:uint = 0;

		public function removeItemPrice2():void {
			hasField$0 &= 0xfffffffe;
			itemPrice2$field = new uint();
		}

		public function get hasItemPrice2():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set itemPrice2(value:uint):void {
			hasField$0 |= 0x1;
			itemPrice2$field = value;
		}

		public function get itemPrice2():uint {
			return itemPrice2$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemPrice1);
			if (hasItemPrice2) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, itemPrice2$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var itemId$count:uint = 0;
			var itemPrice1$count:uint = 0;
			var itemPrice2$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (itemId$count != 0) {
						throw new flash.errors.IOError('Bad data format: StoreItem.itemId cannot be set twice.');
					}
					++itemId$count;
					itemId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (itemPrice1$count != 0) {
						throw new flash.errors.IOError('Bad data format: StoreItem.itemPrice1 cannot be set twice.');
					}
					++itemPrice1$count;
					itemPrice1 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (itemPrice2$count != 0) {
						throw new flash.errors.IOError('Bad data format: StoreItem.itemPrice2 cannot be set twice.');
					}
					++itemPrice2$count;
					itemPrice2 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
