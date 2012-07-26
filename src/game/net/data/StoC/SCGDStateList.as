package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xF5
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCGDStateList.GuildBossPlayerState;
	public dynamic final class SCGDStateList extends com.protobuf.Message {
		 /**
		  *@playerstatelist   playerstatelist
		  **/
		public var playerstatelist:Vector.<GuildBossPlayerState> = new Vector.<GuildBossPlayerState>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			playerstatelist = new Vector.<GuildBossPlayerState>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					playerstatelist.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCGDStateList.GuildBossPlayerState()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
