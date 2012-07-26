package game.net.data.StoC.SCListTrade {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.EquipAttribute;
	public dynamic final class TradeInfo extends com.protobuf.Message {
		 /**
		  *@tradeid   tradeid
		  **/
		public var tradeid:uint;

		 /**
		  *@partner   partner
		  **/
		public var partner:String;

		 /**
		  *@potential   potential
		  **/
		public var potential:uint;

		 /**
		  *@itemsA   itemsA
		  **/
		public var itemsA:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@itemsB   itemsB
		  **/
		public var itemsB:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@equipA   equipA
		  **/
		public var equipA:Vector.<EquipAttribute> = new Vector.<EquipAttribute>();

		 /**
		  *@equipB   equipB
		  **/
		public var equipB:Vector.<EquipAttribute> = new Vector.<EquipAttribute>();

		 /**
		  *@goldsA   goldsA
		  **/
		private var goldsA$field:uint;

		private var hasField$0:uint = 0;

		public function removeGoldsA():void {
			hasField$0 &= 0xfffffffe;
			goldsA$field = new uint();
		}

		public function get hasGoldsA():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set goldsA(value:uint):void {
			hasField$0 |= 0x1;
			goldsA$field = value;
		}

		public function get goldsA():uint {
			return goldsA$field;
		}

		 /**
		  *@goldsB   goldsB
		  **/
		private var goldsB$field:uint;

		public function removeGoldsB():void {
			hasField$0 &= 0xfffffffd;
			goldsB$field = new uint();
		}

		public function get hasGoldsB():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set goldsB(value:uint):void {
			hasField$0 |= 0x2;
			goldsB$field = value;
		}

		public function get goldsB():uint {
			return goldsB$field;
		}

		 /**
		  *@status   status
		  **/
		public var status:uint;

		 /**
		  *@sendtime   sendtime
		  **/
		public var sendtime:uint;

		 /**
		  *@remarkA   remarkA
		  **/
		private var remarkA$field:String;

		public function removeRemarkA():void {
			remarkA$field = null;
		}

		public function get hasRemarkA():Boolean {
			return remarkA$field != null;
		}

		public function set remarkA(value:String):void {
			remarkA$field = value;
		}

		public function get remarkA():String {
			return remarkA$field;
		}

		 /**
		  *@remarkB   remarkB
		  **/
		private var remarkB$field:String;

		public function removeRemarkB():void {
			remarkB$field = null;
		}

		public function get hasRemarkB():Boolean {
			return remarkB$field != null;
		}

		public function set remarkB(value:String):void {
			remarkB$field = value;
		}

		public function get remarkB():String {
			return remarkB$field;
		}

		 /**
		  *@plevel   plevel
		  **/
		private var plevel$field:uint;

		public function removePlevel():void {
			hasField$0 &= 0xfffffffb;
			plevel$field = new uint();
		}

		public function get hasPlevel():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set plevel(value:uint):void {
			hasField$0 |= 0x4;
			plevel$field = value;
		}

		public function get plevel():uint {
			return plevel$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, tradeid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, partner);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, potential);
			if (itemsA != null && itemsA.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, itemsA);
			}
			if (itemsB != null && itemsB.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, itemsB);
			}
			for (var equipAIndex:uint = 0; equipAIndex < equipA.length; ++equipAIndex) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.protobuf.WriteUtils.write$TYPE_MESSAGE(output, equipA[equipAIndex]);
			}
			for (var equipBIndex:uint = 0; equipBIndex < equipB.length; ++equipBIndex) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.protobuf.WriteUtils.write$TYPE_MESSAGE(output, equipB[equipBIndex]);
			}
			if (hasGoldsA) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 8);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, goldsA$field);
			}
			if (hasGoldsB) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 9);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, goldsB$field);
			}
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 10);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, status);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 11);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, sendtime);
			if (hasRemarkA) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 12);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, remarkA$field);
			}
			if (hasRemarkB) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 13);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, remarkB$field);
			}
			if (hasPlevel) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 14);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, plevel$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var tradeid$count:uint = 0;
			var partner$count:uint = 0;
			var potential$count:uint = 0;
			itemsA = new Vector.<uint>();

			itemsB = new Vector.<uint>();

			equipA = new Vector.<EquipAttribute>();

			equipB = new Vector.<EquipAttribute>();

			var goldsA$count:uint = 0;
			var goldsB$count:uint = 0;
			var status$count:uint = 0;
			var sendtime$count:uint = 0;
			var remarkA$count:uint = 0;
			var remarkB$count:uint = 0;
			var plevel$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (tradeid$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.tradeid cannot be set twice.');
					}
					++tradeid$count;
					tradeid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (partner$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.partner cannot be set twice.');
					}
					++partner$count;
					partner = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, itemsA);
						break;
					}
					itemsA.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 5:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, itemsB);
						break;
					}
					itemsB.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 6:
					equipA.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.EquipAttribute()));
					break;
				case 7:
					equipB.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.EquipAttribute()));
					break;
				case 8:
					if (goldsA$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.goldsA cannot be set twice.');
					}
					++goldsA$count;
					goldsA = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (goldsB$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.goldsB cannot be set twice.');
					}
					++goldsB$count;
					goldsB = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (sendtime$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.sendtime cannot be set twice.');
					}
					++sendtime$count;
					sendtime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 12:
					if (remarkA$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.remarkA cannot be set twice.');
					}
					++remarkA$count;
					remarkA = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 13:
					if (remarkB$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.remarkB cannot be set twice.');
					}
					++remarkB$count;
					remarkB = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 14:
					if (plevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: TradeInfo.plevel cannot be set twice.');
					}
					++plevel$count;
					plevel = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
