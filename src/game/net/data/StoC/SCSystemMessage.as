package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x08
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCSystemMessage extends com.protobuf.Message {
		 /**
		  *@msgid   msgid
		  **/
		public var msgid:uint;

		 /**
		  *@sparam   sparam
		  **/
		public var sparam:Vector.<String> = new Vector.<String>();

		 /**
		  *@iparam   iparam
		  **/
		public var iparam:Vector.<int> = new Vector.<int>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var msgid$count:uint = 0;
			sparam = new Vector.<String>();

			iparam = new Vector.<int>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (msgid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSystemMessage.msgid cannot be set twice.');
					}
					++msgid$count;
					msgid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					sparam.push(com.protobuf.ReadUtils.read$TYPE_STRING(input));
					break;
				case 3:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_SINT32, iparam);
						break;
					}
					iparam.push(com.protobuf.ReadUtils.read$TYPE_SINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
