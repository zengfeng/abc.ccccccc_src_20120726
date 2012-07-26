package game.net.data.StoC.SCGiftList {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GiftData extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@items   items
		  **/
		public var items:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@exp   exp
		  **/
		private var exp$field:uint;

		private var hasField$0:uint = 0;

		public function removeExp():void {
			hasField$0 &= 0xfffffffe;
			exp$field = new uint();
		}

		public function get hasExp():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set exp(value:uint):void {
			hasField$0 |= 0x1;
			exp$field = value;
		}

		public function get exp():uint {
			return exp$field;
		}

		 /**
		  *@params   params
		  **/
		public var params:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@time   time
		  **/
		public var time:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			if (items != null && items.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, items);
			}
			if (hasExp) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, exp$field);
			}
			for (var paramsIndex:uint = 0; paramsIndex < params.length; ++paramsIndex) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, params[paramsIndex]);
			}
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, time);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			items = new Vector.<uint>();

			var exp$count:uint = 0;
			params = new Vector.<uint>();

			var time$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: GiftData.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, items);
						break;
					}
					items.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 3:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: GiftData.exp cannot be set twice.');
					}
					++exp$count;
					exp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, params);
						break;
					}
					params.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 5:
					if (time$count != 0) {
						throw new flash.errors.IOError('Bad data format: GiftData.time cannot be set twice.');
					}
					++time$count;
					time = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
