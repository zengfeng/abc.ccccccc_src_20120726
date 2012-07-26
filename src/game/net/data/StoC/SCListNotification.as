package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x58
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.NotificationItem;
	public dynamic final class SCListNotification extends com.protobuf.Message {
		 /**
		  *@items   items
		  **/
		public var items:Vector.<NotificationItem> = new Vector.<NotificationItem>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			items = new Vector.<NotificationItem>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					items.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.NotificationItem()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
