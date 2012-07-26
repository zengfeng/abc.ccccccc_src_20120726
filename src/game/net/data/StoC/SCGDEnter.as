package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xF2
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCGDEnter.GDPlayer;
	public dynamic final class SCGDEnter extends com.protobuf.Message {
		 /**
		  *@playerlist   playerlist
		  **/
		public var playerlist:Vector.<GDPlayer> = new Vector.<GDPlayer>();

		 /**
		  *@status   status
		  **/
		public var status:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			playerlist = new Vector.<GDPlayer>();

			var status$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					playerlist.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCGDEnter.GDPlayer()));
					break;
				case 2:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDEnter.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
