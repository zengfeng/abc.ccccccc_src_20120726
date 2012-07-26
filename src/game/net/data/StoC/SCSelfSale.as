package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xB6
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SaleInfo;
	public dynamic final class SCSelfSale extends com.protobuf.Message {
		 /**
		  *@sale   sale
		  **/
		public var sale:Vector.<SaleInfo> = new Vector.<SaleInfo>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			sale = new Vector.<SaleInfo>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					sale.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SaleInfo()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
