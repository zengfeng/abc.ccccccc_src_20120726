package game.module.trade.ui
{
	import gameui.controls.GButton;
	import gameui.manager.UIManager;

	import net.AssetData;

	import flash.display.Sprite;

	/**
	 * @author 1
	 */
	public class PaginationButton extends GButton {
		
		public var btntype:uint ;
		private var _select:Boolean = false;
		private var _txt:String = "" ;
		private var _value:uint = 0 ;
		private var _selBg:Sprite ;
		
		public function PaginationButton(data : PaginationBtnData) {
			
			btntype = data.btntype ;
			_txt = data.text ;
			super(data);
			if( data.selAsset != null )
				addBg(data.selAsset);
		}
		
		public function set select(v:Boolean):void
		{
			_select = v ;
			if(_selBg)
				_selBg.visible = v ;
		}
		
		public function get select():Boolean
		{
			return _select ;
		}
		
		public function set value(v:uint):void
		{
			_value = v ;
			label.text = _txt == null ? "" : _txt.replace( "(v)",_value.toString() );
		}
		
		public function get value():uint
		{
			return _value ;
		}
		
		public function addBg(data:AssetData):void
		{
			_selBg = UIManager.getUI(data);
			_selBg.width = width ;
			_selBg.height = height ;
			_upSkin.addChild(_selBg);
		}
	}
}
