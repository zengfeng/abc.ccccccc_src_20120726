package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x0E
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCWallowUpdate extends com.protobuf.Message {
		 /**
		  *@status   status
		  **/
		public var status:uint;

		 /**
		  *@wallowTime   wallowTime
		  **/
		public var wallowTime:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var status$count:uint = 0;
			var wallowTime$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCWallowUpdate.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (wallowTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCWallowUpdate.wallowTime cannot be set twice.');
					}
					++wallowTime$count;
					wallowTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
