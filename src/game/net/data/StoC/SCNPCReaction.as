package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x24
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCNPCReaction extends com.protobuf.Message {
		 /**
		  *@reactionId   reactionId
		  **/
		public var reactionId:uint;

		 /**
		  *@npcId   npcId
		  **/
		public var npcId:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var reactionId$count:uint = 0;
			var npcId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (reactionId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCNPCReaction.reactionId cannot be set twice.');
					}
					++reactionId$count;
					reactionId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (npcId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCNPCReaction.npcId cannot be set twice.');
					}
					++npcId$count;
					npcId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
