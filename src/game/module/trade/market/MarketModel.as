package game.module.trade.market
{
	/**
	 * @author yangyiqiang
	 */
	public final class MarketModel
	{
		public var begin:int=0;
		public var searchbegin:int=0;                     //搜索标志位
		public var total:int;
		public var pagecountnow:int;

		public var current_treeid:int=0;                  //当前树上选中id
		public var current_itemid:int=0;                 //當前搜索的物品的ID
		
		
		public var initpage:int=0;                       //判斷頁碼是否需要初始化
		public var initmarket:int=0;
	    public var inittree:int=0;                        
		
//		public var pricebutton_status:uint=0;              //排序按鈕當前狀態
//		public var countbutton_status:uint=0;
		
//		public static const PRICEBUTTON_UP:uint=0;
//		public static const PRICEBUTTON_DOWN:uint=1;
//		
//		public static const COUNTBUTTON_UP:uint=0;
//		public static const COUNTBUTTON_DOWN:uint=1;
		
		
		public var market_list_type:uint=0;      //請求查詢方式
		
		
	    public var market_type:uint=0;      //請求查詢方式
		
		public static const LISTALL:uint=0;         //全部查找
		public static const LISTPART:uint=1;         //部分查找
		
		public static const LISTPAGE_ID:uint=0;         //根据页签查找
		public static const LISTITEM_ID:uint=1;          //根据物品id
		
		public static const FINDALL:uint=0;          //根据物品id
		
		
		
		public var market_sort_type:uint=4;      //請求排序方式 默认为4DEFAULTSORT
		
		
		public static const PRICEUP:uint=0;       //价格升序 物品升序
		public static const PRICEDOWN:uint=1;
		public static const COUNTUP:uint=2;
		public static const COUNTDOWN:uint=3;
		public static const DEFAULTSORT:uint =4;	
		
		public static const PAGEINIT_REQ:int=1;        //是否需要初始化翻页控件
		public static const PAGEINIT_NREQ:int=0;
		
		
		public var userlevel:int=150;          //记录用户等级
	}
}
