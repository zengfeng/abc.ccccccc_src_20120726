package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2C3
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GuildInfoPartA;
	public dynamic final class SCGuildList extends com.protobuf.Message {
		 /**
		  *@guild   guild
		  **/
		public var guild:Vector.<GuildInfoPartA> = new Vector.<GuildInfoPartA>();

		 /**
		  *@begin   begin
		  **/
		public var begin:uint;

		 /**
		  *@count   count
		  **/
		public var count:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			guild = new Vector.<GuildInfoPartA>();

			var begin$count:uint = 0;
			var count$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					guild.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.GuildInfoPartA()));
					break;
				case 2:
					if (begin$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildList.begin cannot be set twice.');
					}
					++begin$count;
					begin = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (count$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildList.count cannot be set twice.');
					}
					++count$count;
					count = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
