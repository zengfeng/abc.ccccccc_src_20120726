package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xB3
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCListTrade.TradeInfo;
	public dynamic final class SCListTrade extends com.protobuf.Message {
		 /**
		  *@tradeList   tradeList
		  **/
		public var tradeList:Vector.<TradeInfo> = new Vector.<TradeInfo>();

		 /**
		  *@begin   begin
		  **/
		public var begin:uint;

		 /**
		  *@total   total
		  **/
		public var total:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			tradeList = new Vector.<TradeInfo>();

			var begin$count:uint = 0;
			var total$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					tradeList.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCListTrade.TradeInfo()));
					break;
				case 2:
					if (begin$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCListTrade.begin cannot be set twice.');
					}
					++begin$count;
					begin = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (total$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCListTrade.total cannot be set twice.');
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
