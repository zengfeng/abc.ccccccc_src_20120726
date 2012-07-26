package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x5D
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCListContactNotification.ContactItem;
	public dynamic final class SCListContactNotification extends com.protobuf.Message {
		 /**
		  *@items   items
		  **/
		public var items:Vector.<ContactItem> = new Vector.<ContactItem>();

		 /**
		  *@followcnt   followcnt
		  **/
		public var followcnt:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			items = new Vector.<ContactItem>();

			var followcnt$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					items.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCListContactNotification.ContactItem()));
					break;
				case 2:
					if (followcnt$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCListContactNotification.followcnt cannot be set twice.');
					}
					++followcnt$count;
					followcnt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
