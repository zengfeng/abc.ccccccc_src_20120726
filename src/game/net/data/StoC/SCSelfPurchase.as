package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xBB
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.PurchaseInfo;
	public dynamic final class SCSelfPurchase extends com.protobuf.Message {
		 /**
		  *@purchase   purchase
		  **/
		public var purchase:Vector.<PurchaseInfo> = new Vector.<PurchaseInfo>();

		 /**
		  *@total   total
		  **/
		public var total:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			purchase = new Vector.<PurchaseInfo>();

			var total$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					purchase.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.PurchaseInfo()));
					break;
				case 2:
					if (total$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSelfPurchase.total cannot be set twice.');
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
