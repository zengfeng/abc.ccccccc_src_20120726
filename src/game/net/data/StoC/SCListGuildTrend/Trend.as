package game.net.data.StoC.SCListGuildTrend {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class Trend extends com.protobuf.Message {
		 /**
		  *@trendid   trendid
		  **/
		public var trendid:uint;

		 /**
		  *@param   param
		  **/
		public var param:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@stamp   stamp
		  **/
		public var stamp:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, trendid);
			for (var paramIndex:uint = 0; paramIndex < param.length; ++paramIndex) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, param[paramIndex]);
			}
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, stamp);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var trendid$count:uint = 0;
			param = new Vector.<uint>();

			var stamp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (trendid$count != 0) {
						throw new flash.errors.IOError('Bad data format: Trend.trendid cannot be set twice.');
					}
					++trendid$count;
					trendid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, param);
						break;
					}
					param.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 3:
					if (stamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: Trend.stamp cannot be set twice.');
					}
					++stamp$count;
					stamp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
