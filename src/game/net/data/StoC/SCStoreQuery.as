package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1C0
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCStoreQuery.StoreItem;
	public dynamic final class SCStoreQuery extends com.protobuf.Message {
		 /**
		  *@storeItems   storeItems
		  **/
		public var storeItems:Vector.<StoreItem> = new Vector.<StoreItem>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			storeItems = new Vector.<StoreItem>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					storeItems.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCStoreQuery.StoreItem()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
