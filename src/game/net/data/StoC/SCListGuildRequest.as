package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2CC
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GuildReserves;
	public dynamic final class SCListGuildRequest extends com.protobuf.Message {
		 /**
		  *@players   players
		  **/
		public var players:Vector.<GuildReserves> = new Vector.<GuildReserves>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			players = new Vector.<GuildReserves>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					players.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.GuildReserves()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
