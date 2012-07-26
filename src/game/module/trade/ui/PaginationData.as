package game.module.trade.ui {
	import gameui.data.GPanelData;
	/**
	 * @author 1
	 */
	public class PaginationData extends GPanelData{
		
		public static const HIDE_FIRST_FIRST:uint = 0x1 ;
		public static const DISABLE_FIRST_FIRST:uint = 0x2 ;
		public static const HIDE_FIRST_PAGE:uint = 0x4 ;
		
		public static const HIDE_PRE_FIRST:uint = 0x8 ;
		public static const DISABLE_PRE_FIRST:uint = 0x10 ;
		
		public static const HIDE_LAST_LAST:uint = 0x20 ;
		public static const DISABLE_LAST_LAST:uint = 0x40 ;
		public static const HIDE_LAST_PAGE:uint = 0x80 ;
		
		public static const HIDE_NEXT_LAST:uint = 0x100 ;
		public static const DISABLE_NEXT_LAST:uint = 0x200 ;
		public static const DISABLE_SELECT:uint = 0x400 ;
		
		public static const LEFT_FIX:uint = 0 ;
		public static const RIGHT_FIX:uint = 1;
		public static const CENTER_FIX:uint = 2 ;
		
		public static const TRIGGER_NO_CHANGE:uint = 0x400 ;
		
		public var flag:uint = DISABLE_FIRST_FIRST ;
		public var xpadding:uint = 2 ;
		private var _buttons:Vector.<PaginationBtnData> ;
		public var fixmode:uint = CENTER_FIX ;
		
		public function PaginationData()
		{
			super() ;
			_buttons = new Vector.<PaginationBtnData>() ;
		}
		
		public function get buttons():Vector.<PaginationBtnData>
		{
			return _buttons;
		}
	}
}
