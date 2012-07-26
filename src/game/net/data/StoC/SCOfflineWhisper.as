package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x98
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCOfflineWhisper.OfflineMessage;
	public dynamic final class SCOfflineWhisper extends com.protobuf.Message {
		 /**
		  *@msglist   msglist
		  **/
		public var msglist:Vector.<OfflineMessage> = new Vector.<OfflineMessage>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			msglist = new Vector.<OfflineMessage>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					msglist.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCOfflineWhisper.OfflineMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
