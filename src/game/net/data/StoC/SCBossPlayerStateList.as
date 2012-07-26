package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2E6
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.BossPlayerState;
	public dynamic final class SCBossPlayerStateList extends com.protobuf.Message {
		 /**
		  *@playerstatelist   playerstatelist
		  **/
		public var playerstatelist:Vector.<BossPlayerState> = new Vector.<BossPlayerState>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			playerstatelist = new Vector.<BossPlayerState>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					playerstatelist.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.BossPlayerState()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
