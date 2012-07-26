package game.module.trade.sale
{


	import flash.events.Event;
	import game.core.item.Item;

    /**
     * @author zheng
     */
    public class EventSale extends Event
    {
                /** 添加组事件 */
        public static const ADD_MYITEM:String = "addMyItem";
        public var voSaleItem:SaleVO;
		public var itemCell:SaleListCell;
		public var status:int;
		public function EventSale(type : String,bubbles:Boolean=true,cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
		public static const UPDATESATUS_MYITEM:String="updateStatusMyItem";
	

    }
}

