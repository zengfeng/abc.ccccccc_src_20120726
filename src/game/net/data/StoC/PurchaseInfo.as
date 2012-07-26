package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class PurchaseInfo extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@item   item
		  **/
		public var item:uint;

		 /**
		  *@uprice   uprice
		  **/
		public var uprice:uint;

		 /**
		  *@status   status
		  **/
		public var status:uint;

		 /**
		  *@buyer   buyer
		  **/
		private var buyer$field:String;

		public function removeBuyer():void {
			buyer$field = null;
		}

		public function get hasBuyer():Boolean {
			return buyer$field != null;
		}

		public function set buyer(value:String):void {
			buyer$field = value;
		}

		public function get buyer():String {
			return buyer$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, item);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, uprice);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, status);
			if (hasBuyer) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, buyer$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var item$count:uint = 0;
			var uprice$count:uint = 0;
			var status$count:uint = 0;
			var buyer$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseInfo.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (item$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseInfo.item cannot be set twice.');
					}
					++item$count;
					item = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (uprice$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseInfo.uprice cannot be set twice.');
					}
					++uprice$count;
					uprice = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseInfo.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (buyer$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseInfo.buyer cannot be set twice.');
					}
					++buyer$count;
					buyer = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
