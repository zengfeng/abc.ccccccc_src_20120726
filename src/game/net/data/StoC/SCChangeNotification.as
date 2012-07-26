package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x5B
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.NotificationItem;
	public dynamic final class SCChangeNotification extends com.protobuf.Message {
		 /**
		  *@oldId   oldId
		  **/
		public var oldId:uint;

		 /**
		  *@newItem   newItem
		  **/
		public var newItem:game.net.data.StoC.NotificationItem;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var oldId$count:uint = 0;
			var newItem$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (oldId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCChangeNotification.oldId cannot be set twice.');
					}
					++oldId$count;
					oldId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (newItem$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCChangeNotification.newItem cannot be set twice.');
					}
					++newItem$count;
					newItem = new game.net.data.StoC.NotificationItem();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, newItem);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
