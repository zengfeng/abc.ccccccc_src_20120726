package game.net.data.StoC.SCOtherInfo {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class OtherHeroInfo extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@potential   potential
		  **/
		public var potential:uint;

		 /**
		  *@wpLevel   wpLevel
		  **/
		public var wpLevel:uint;

		 /**
		  *@equips   equips
		  **/
		public var equips:Vector.<uint> = new Vector.<uint>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, potential);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, wpLevel);
			if (equips != null && equips.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, equips);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var potential$count:uint = 0;
			var wpLevel$count:uint = 0;
			equips = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherHeroInfo.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherHeroInfo.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (wpLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherHeroInfo.wpLevel cannot be set twice.');
					}
					++wpLevel$count;
					wpLevel = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, equips);
						break;
					}
					equips.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
