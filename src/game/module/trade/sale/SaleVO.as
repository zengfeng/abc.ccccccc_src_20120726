package game.module.trade.sale
{
	import game.core.item.Item;
	/**
	 * @author 1
	 */
	public class SaleVO
	{
		public var id:int;                    //物品的交易id
		public var item:Item;
		public var salePrice:uint;
		public var ownerName:String;
		public var saleStatus:int;
		public var background:int;
		
		public var time_outdays:int=0;
		
	}
}
