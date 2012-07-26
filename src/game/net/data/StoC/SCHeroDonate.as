package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x17
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCHeroDonate extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@totalCount   totalCount
		  **/
		public var totalCount:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var totalCount$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCHeroDonate.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (totalCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCHeroDonate.totalCount cannot be set twice.');
					}
					++totalCount$count;
					totalCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
