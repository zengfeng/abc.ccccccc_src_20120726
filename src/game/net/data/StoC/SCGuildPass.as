package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2C5
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GuildMember;
	public dynamic final class SCGuildPass extends com.protobuf.Message {
		 /**
		  *@member   member
		  **/
		public var member:game.net.data.StoC.GuildMember;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var member$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (member$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildPass.member cannot be set twice.');
					}
					++member$count;
					member = new game.net.data.StoC.GuildMember();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, member);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
