package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xB7
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SaleInfo;
	public dynamic final class SCListSale extends com.protobuf.Message {
		 /**
		  *@begin   begin
		  **/
		public var begin:uint;

		 /**
		  *@sale   sale
		  **/
		public var sale:Vector.<SaleInfo> = new Vector.<SaleInfo>();

		 /**
		  *@total   total
		  **/
		public var total:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var begin$count:uint = 0;
			sale = new Vector.<SaleInfo>();

			var total$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (begin$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCListSale.begin cannot be set twice.');
					}
					++begin$count;
					begin = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					sale.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SaleInfo()));
					break;
				case 3:
					if (total$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCListSale.total cannot be set twice.');
					}
					++total$count;
					total = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
