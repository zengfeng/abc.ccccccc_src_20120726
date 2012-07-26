package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xE000
	 **/
	import com.protobuf.*;
	public dynamic final class CSBackendCommand extends com.protobuf.Message {
		 /**
		  *@players   players
		  **/
		public var players:Vector.<String> = new Vector.<String>();

		 /**
		  *@commands   commands
		  **/
		public var commands:Vector.<String> = new Vector.<String>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			for (var playersIndex:uint = 0; playersIndex < players.length; ++playersIndex) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, players[playersIndex]);
			}
			for (var commandsIndex:uint = 0; commandsIndex < commands.length; ++commandsIndex) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, commands[commandsIndex]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
