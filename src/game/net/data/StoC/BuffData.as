package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class BuffData extends com.protobuf.Message {
		 /**
		  *@buffId   buffId
		  **/
		public var buffId:uint;

		 /**
		  *@leftTime   leftTime
		  **/
		public var leftTime:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, buffId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, leftTime);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var buffId$count:uint = 0;
			var leftTime$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (buffId$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuffData.buffId cannot be set twice.');
					}
					++buffId$count;
					buffId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (leftTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuffData.leftTime cannot be set twice.');
					}
					++leftTime$count;
					leftTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
