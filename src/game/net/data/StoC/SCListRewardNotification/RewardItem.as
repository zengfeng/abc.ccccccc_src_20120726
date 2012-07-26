package game.net.data.StoC.SCListRewardNotification {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class RewardItem extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@type   type
		  **/
		public var type:uint;

		 /**
		  *@param   param
		  **/
		public var param:Vector.<uint> = new Vector.<uint>();

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

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, type);
			for (var paramIndex:uint = 0; paramIndex < param.length; ++paramIndex) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, param[paramIndex]);
			}
			if (items != null && items.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, items);
			}
			if (hasExp) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, exp$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var type$count:uint = 0;
			param = new Vector.<uint>();

			items = new Vector.<uint>();

			var exp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardItem.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardItem.type cannot be set twice.');
					}
					++type$count;
					type = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, param);
						break;
					}
					param.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 4:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, items);
						break;
					}
					items.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 5:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardItem.exp cannot be set twice.');
					}
					++exp$count;
					exp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
