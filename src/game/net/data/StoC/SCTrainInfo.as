package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2D
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCTrainInfo extends com.protobuf.Message {
		 /**
		  *@type   type
		  **/
		public var type:uint;

		 /**
		  *@timeLeft   timeLeft
		  **/
		public var timeLeft:uint;

		 /**
		  *@completeCount   completeCount
		  **/
		public var completeCount:uint;

		 /**
		  *@expGot   expGot
		  **/
		public var expGot:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			var timeLeft$count:uint = 0;
			var completeCount$count:uint = 0;
			var expGot$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainInfo.type cannot be set twice.');
					}
					++type$count;
					type = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (timeLeft$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainInfo.timeLeft cannot be set twice.');
					}
					++timeLeft$count;
					timeLeft = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (completeCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainInfo.completeCount cannot be set twice.');
					}
					++completeCount$count;
					completeCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (expGot$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainInfo.expGot cannot be set twice.');
					}
					++expGot$count;
					expGot = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
