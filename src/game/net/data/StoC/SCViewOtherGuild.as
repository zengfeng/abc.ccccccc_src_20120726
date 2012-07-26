package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2C8
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GuildInfoPartB;
	public dynamic final class SCViewOtherGuild extends com.protobuf.Message {
		 /**
		  *@extinfo   extinfo
		  **/
		public var extinfo:game.net.data.StoC.GuildInfoPartB;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var extinfo$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (extinfo$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCViewOtherGuild.extinfo cannot be set twice.');
					}
					++extinfo$count;
					extinfo = new game.net.data.StoC.GuildInfoPartB();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, extinfo);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
