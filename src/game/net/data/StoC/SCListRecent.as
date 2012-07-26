package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x55
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.ContactPlayer;
	public dynamic final class SCListRecent extends com.protobuf.Message {
		 /**
		  *@playerList   playerList
		  **/
		public var playerList:Vector.<ContactPlayer> = new Vector.<ContactPlayer>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			playerList = new Vector.<ContactPlayer>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					playerList.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.ContactPlayer()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
