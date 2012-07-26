package game.module.trade.ui {
	import net.AssetData;
	import gameui.data.GButtonData;

	/**
	 * @author 1
	 */
	public class PaginationBtnData extends GButtonData {

		public static const BTN_NORMAL:uint = 0 ;
		public static const BTN_FIRST:uint = 1 ;
		public static const BTN_LAST:uint = 2 ;
		public static const BTN_PRE:uint = 3 ;
		public static const BTN_NEXT:uint = 4 ;
		
		public var btntype:uint = 0 ;
		public var repeat:uint = 1 ;
		public var text:String = "";
		public var selAsset:AssetData ;
		
		public function PaginationBtnData() {
			super();
		}
	}
}
