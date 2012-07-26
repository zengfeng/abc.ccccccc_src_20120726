package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2C7
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGuildVote extends com.protobuf.Message {
		 /**
		  *@voter   voter
		  **/
		public var voter:uint;

		 /**
		  *@voted   voted
		  **/
		public var voted:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var voter$count:uint = 0;
			var voted$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (voter$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildVote.voter cannot be set twice.');
					}
					++voter$count;
					voter = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (voted$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildVote.voted cannot be set twice.');
					}
					++voted$count;
					voted = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
