package game.module.trade.ui {
	import gameui.containers.GPanel;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.alert.Alert;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author 1
	 */
	public class PaginationPanel extends GPanel {
		
		public var buttons:Vector.<PaginationButton> ;
		private var _xpadding:uint ;
		private var _flag:uint ;
		private var _fixmode:uint ;
		private var _normalCount:uint ;
		private var _current:uint ;
		private var _total:uint ;
		private var _totalwidth:uint ;
		private var _stdx:uint ;
		
		public function get current():uint
		{
			return _current ;
		}
		
		public function PaginationPanel(data :PaginationData) {
			
			data.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(data);
			buttons = new Vector.<PaginationButton>;
			_xpadding = data.padding ;
			_flag = data.flag ;
			_stdx = data.x ;
			_fixmode = data.fixmode ;
			addButtons(data) ;
			update(1,1);
		}
		
		public function addButtons(data:PaginationData):void 
		{
			var lx:uint = 0 ;
			_normalCount = 0;
			for each( var bdata:PaginationBtnData in data.buttons )
			{
				for( var i:int = 0 ; i < bdata.repeat ; ++ i )
				{
				 	var btn:PaginationButton  = new PaginationButton(bdata);
					btn.x = lx ;
					lx += bdata.width + data.xpadding ;
					btn.addEventListener(MouseEvent.CLICK, onButtonClick) ;
					addChild(btn);
					buttons.push(btn);
				}
				if( bdata.btntype == PaginationBtnData.BTN_NORMAL )
				{
					_normalCount += bdata.repeat ;
				}
			}
			_totalwidth = lx - _xpadding ;
		}
		
		public function onButtonClick(evt:Event):void
		{
			var btn:PaginationButton = evt.target as PaginationButton ;
			var tar:uint ;
			switch( btn.btntype )
			{
				case PaginationBtnData.BTN_FIRST:
					tar = 1 ;
					break ;
				case PaginationBtnData.BTN_LAST:
					tar = _total ;
					break ;
				case PaginationBtnData.BTN_NORMAL:
					tar = btn.value ;
					break ;					
				case PaginationBtnData.BTN_PRE:
					tar = _current < 2 ? 1 : _current -1 ;
					break ;
				case PaginationBtnData.BTN_NEXT:
					tar = _current >= _total ? _total : _current + 1 ;
					break ;
				default :
					break ;
			}
			if( (_flag & PaginationData.TRIGGER_NO_CHANGE) || tar != _current )
			{
				_current = tar ;
				var e:Event = new Event(Event.CHANGE);
				dispatchEvent(e);
			}
		}
		
		public function update( sel:uint , tot:uint ):void
		{
			var from:int = sel - Math.floor( _normalCount/2 );
			var to:int = from + _normalCount - 1 ;
			var lx:int = 0 ;
			var val:int ;
			_current = sel ;
			_total = tot ;
			from = from < 1 ? 1 : from ;
			to = to > tot ? tot : to ;
			val = from ;
			for each ( var btn:PaginationButton in buttons )
			{
				switch( btn.btntype )
				{
				case PaginationBtnData.BTN_FIRST:
					if( ( _flag & PaginationData.HIDE_FIRST_PAGE ) && from == 1 )
					{
						btn.visible = false ;
					}
					else if ( ( _flag & PaginationData.HIDE_FIRST_FIRST ) && sel == 1 )
					{
						btn.visible = false ;
					}
					else if ( ( _flag & PaginationData.DISABLE_FIRST_FIRST ) && sel == 1 )
					{
						btn.enabled = false ;
						btn.x = lx ;
						lx += btn.width + _xpadding ;
					}
					else 
					{
						btn.visible = true ;
						btn.enabled = true ;
						btn.x = lx ;
						lx += btn.width + _xpadding ;
					}
					break ;
				case PaginationBtnData.BTN_LAST :
					if( ( _flag & PaginationData.HIDE_LAST_PAGE ) && to == tot )
					{
						btn.visible = false ;
					}
					else if ( ( _flag & PaginationData.HIDE_LAST_LAST ) && sel == tot )
					{
						btn.visible = false ;
					}
					else if ( ( _flag & PaginationData.DISABLE_LAST_LAST ) && sel == tot )
					{
						btn.enabled = false ;
						btn.x = lx ;
						btn.value = tot ;
						lx += btn.width + _xpadding ;
					}
					else 
					{
						btn.visible = true ;
						btn.enabled = true ;
						btn.x = lx ;
						btn.value = tot ;
						lx += btn.width + _xpadding ;
					}
					break ;
				case PaginationBtnData.BTN_PRE :
					if( ( _flag & PaginationData.HIDE_PRE_FIRST ) && sel == 1 )
					{
						btn.visible = false ;
					}
					else if( ( _flag & PaginationData.DISABLE_PRE_FIRST ) && sel == 1 )
					{
						btn.enabled = false ;
						btn.x = lx ;
						lx += btn.width + _xpadding ;
					}
					else
					{
						btn.visible = true ;
						btn.enabled = true ;
						btn.x = lx ;
						lx += btn.width + _xpadding ;
					} 
					break ;		
				case PaginationBtnData.BTN_NEXT :
					if( ( _flag & PaginationData.HIDE_NEXT_LAST ) && sel == tot )
					{
						btn.visible = false ;
					}
					else if( ( _flag & PaginationData.DISABLE_NEXT_LAST ) && sel == tot )
					{
						btn.enabled = false ;
						btn.x = lx ;
						lx += btn.width + _xpadding ;
					}
					else
					{
						btn.visible = true ;
						btn.enabled = true ;
						btn.x = lx ;
						lx += btn.width + _xpadding ;
					} 
					break ;		
				case PaginationBtnData.BTN_NORMAL :
					if( val > tot )
					{
						btn.visible = false ;
						val ++ ;
					}
					else 
					{
						btn.visible = true ;
						btn.enabled = true ;
						btn.x = lx ;
						lx += btn.width + _xpadding ;
						btn.value = val ++  ;
						if( btn.value == sel )
						{
							btn.select = true ;
							if( PaginationData.DISABLE_SELECT & _flag )
							{
								btn.enabled = false ;
							}
						}
					}
					break ;
				default :
					break ;
				}
			}
			lx -= _xpadding ;
			this.width = lx ;
			switch( _fixmode )
			{
				case PaginationData.LEFT_FIX:
					break;
				case PaginationData.RIGHT_FIX:
					x = _stdx + ( _totalwidth - width );
					break;
				case PaginationData.CENTER_FIX:
					x = _stdx + (_totalwidth - width) / 2;
					break ;
				default:
					break ;
			}
		}
	}
}
