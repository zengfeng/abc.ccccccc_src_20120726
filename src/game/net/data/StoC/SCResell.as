package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xBE
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCResell extends com.protobuf.Message {
		 /**
		  *@preid   preid
		  **/
		public var preid:uint;

		 /**
		  *@postid   postid
		  **/
		public var postid:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var preid$count:uint = 0;
			var postid$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (preid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCResell.preid cannot be set twice.');
					}
					++preid$count;
					preid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (postid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCResell.postid cannot be set twice.');
					}
					++postid$count;
					postid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
