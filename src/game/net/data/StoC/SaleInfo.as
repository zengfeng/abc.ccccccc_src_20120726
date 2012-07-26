package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SaleInfo extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@item   item
		  **/
		public var item:uint;

		 /**
		  *@price   price
		  **/
		public var price:uint;

		 /**
		  *@status   status
		  **/
		public var status:uint;

		 /**
		  *@expired   expired
		  **/
		private var expired$field:uint;

		private var hasField$0:uint = 0;

		public function removeExpired():void {
			hasField$0 &= 0xfffffffe;
			expired$field = new uint();
		}

		public function get hasExpired():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set expired(value:uint):void {
			hasField$0 |= 0x1;
			expired$field = value;
		}

		public function get expired():uint {
			return expired$field;
		}

		 /**
		  *@seller   seller
		  **/
		private var seller$field:String;

		public function removeSeller():void {
			seller$field = null;
		}

		public function get hasSeller():Boolean {
			return seller$field != null;
		}

		public function set seller(value:String):void {
			seller$field = value;
		}

		public function get seller():String {
			return seller$field;
		}

		 /**
		  *@param   param
		  **/
		private var param$field:uint;

		public function removeParam():void {
			hasField$0 &= 0xfffffffd;
			param$field = new uint();
		}

		public function get hasParam():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set param(value:uint):void {
			hasField$0 |= 0x2;
			param$field = value;
		}

		public function get param():uint {
			return param$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, item);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, price);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, status);
			if (hasExpired) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, expired$field);
			}
			if (hasSeller) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, seller$field);
			}
			if (hasParam) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 7);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, param$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var item$count:uint = 0;
			var price$count:uint = 0;
			var status$count:uint = 0;
			var expired$count:uint = 0;
			var seller$count:uint = 0;
			var param$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SaleInfo.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (item$count != 0) {
						throw new flash.errors.IOError('Bad data format: SaleInfo.item cannot be set twice.');
					}
					++item$count;
					item = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (price$count != 0) {
						throw new flash.errors.IOError('Bad data format: SaleInfo.price cannot be set twice.');
					}
					++price$count;
					price = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: SaleInfo.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (expired$count != 0) {
						throw new flash.errors.IOError('Bad data format: SaleInfo.expired cannot be set twice.');
					}
					++expired$count;
					expired = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (seller$count != 0) {
						throw new flash.errors.IOError('Bad data format: SaleInfo.seller cannot be set twice.');
					}
					++seller$count;
					seller = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 7:
					if (param$count != 0) {
						throw new flash.errors.IOError('Bad data format: SaleInfo.param cannot be set twice.');
					}
					++param$count;
					param = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
