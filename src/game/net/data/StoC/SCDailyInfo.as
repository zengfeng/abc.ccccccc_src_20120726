package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x13
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCDailyInfo extends com.protobuf.Message {
		 /**
		  *@dailyValue   dailyValue
		  **/
		public var dailyValue:uint;

		 /**
		  *@dailyStatus   dailyStatus
		  **/
		public var dailyStatus:uint;

		 /**
		  *@timestamp   timestamp
		  **/
		public var timestamp:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dailyValue$count:uint = 0;
			var dailyStatus$count:uint = 0;
			var timestamp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dailyValue$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDailyInfo.dailyValue cannot be set twice.');
					}
					++dailyValue$count;
					dailyValue = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (dailyStatus$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDailyInfo.dailyStatus cannot be set twice.');
					}
					++dailyStatus$count;
					dailyStatus = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (timestamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDailyInfo.timestamp cannot be set twice.');
					}
					++timestamp$count;
					timestamp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
