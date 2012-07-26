package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x103
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCDonateList.DonateListInfo;
	public dynamic final class SCDonateList extends com.protobuf.Message {
		 /**
		  *@list   list
		  **/
		public var list:Vector.<DonateListInfo> = new Vector.<DonateListInfo>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			list = new Vector.<DonateListInfo>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					list.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCDonateList.DonateListInfo()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
