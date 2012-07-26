package game.module.trade.exchange 
{
	/**
	 * ...
	 * @author qiujian
	 */
	public class ExchangeVO 
	{
		// =====================
		// @定义
		// =====================
		public static const I_START:uint = 0;
		public static const HE_REPLIED:uint = 1;
		public static const HE_START:uint = 2;
		public static const I_REPLIED:uint = 3;
		public static const SUCCEDED:uint = 4;
		public static const CANCELLED:uint = 5;
		public static const OUT_OF_DATE:uint = 6;
		public static const DELETED:uint = 7;
		public static const NOT_START:uint = 8;
		
		// =====================
		// @属性
		// =====================		
		public var tradeId:uint;
		public var serverId:uint;
		public var partnerName:String;
		public var partnerId:uint;
		public var partnerLevel:uint;
		public var partnerColor:uint;
		public var partnerItems:Array = [];
		public var partnerPrice:uint;
		public var partnerMessage:String = "";
		public var myItems:Array = [];
		public var myPrice:uint;
		public var myMessage:String = "";
		public var sendtime:uint;
		public var newTrade:Boolean;
		public var iamPartA:Boolean;
		public var status:uint = NOT_START;
        public var packFull:Boolean;
	}
}
