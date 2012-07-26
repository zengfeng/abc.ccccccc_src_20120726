package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2CE
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GuildInfo;
	public dynamic final class SCSelfGuildInfo extends com.protobuf.Message {
		 /**
		  *@info   info
		  **/
		public var info:game.net.data.StoC.GuildInfo;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var info$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSelfGuildInfo.info cannot be set twice.');
					}
					++info$count;
					info = new game.net.data.StoC.GuildInfo();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, info);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
