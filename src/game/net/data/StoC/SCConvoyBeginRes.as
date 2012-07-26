package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xD0
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCConvoyBeginRes extends com.protobuf.Message {
		 /**
		  *@leftTime   leftTime
		  **/
		public var leftTime:uint;

		 /**
		  *@quality   quality
		  **/
		public var quality:uint;

		 /**
		  *@isRate   isRate
		  **/
		public var isRate:Boolean;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var leftTime$count:uint = 0;
			var quality$count:uint = 0;
			var isRate$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (leftTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCConvoyBeginRes.leftTime cannot be set twice.');
					}
					++leftTime$count;
					leftTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (quality$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCConvoyBeginRes.quality cannot be set twice.');
					}
					++quality$count;
					quality = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (isRate$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCConvoyBeginRes.isRate cannot be set twice.');
					}
					++isRate$count;
					isRate = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
