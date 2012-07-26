package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x40
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.ContactPlayer;
	public dynamic final class SCShowContact extends com.protobuf.Message {
		 /**
		  *@followList   followList
		  **/
		public var followList:Vector.<ContactPlayer> = new Vector.<ContactPlayer>();

		 /**
		  *@blockOnline   blockOnline
		  **/
		public var blockOnline:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@recentOnline   recentOnline
		  **/
		public var recentOnline:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			followList = new Vector.<ContactPlayer>();

			blockOnline = new Vector.<uint>();

			recentOnline = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					followList.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.ContactPlayer()));
					break;
				case 2:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, blockOnline);
						break;
					}
					blockOnline.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 3:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, recentOnline);
						break;
					}
					recentOnline.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
