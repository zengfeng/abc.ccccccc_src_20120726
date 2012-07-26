package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x26
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCMultiAvatarInfoChange.AvatarInfoChange;
	public dynamic final class SCMultiAvatarInfoChange extends com.protobuf.Message {
		 /**
		  *@reason   reason
		  **/
		public var reason:uint;

		 /**
		  *@changes   changes
		  **/
		public var changes:Vector.<AvatarInfoChange> = new Vector.<AvatarInfoChange>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var reason$count:uint = 0;
			changes = new Vector.<AvatarInfoChange>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (reason$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCMultiAvatarInfoChange.reason cannot be set twice.');
					}
					++reason$count;
					reason = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					changes.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCMultiAvatarInfoChange.AvatarInfoChange()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
