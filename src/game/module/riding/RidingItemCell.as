package game.module.riding
{
	import flash.events.Event;
	import game.definition.UI;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.ColorChange;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	/**
	 * @author zhengyuhang
	 */
	public class RidingItemCell extends GComponent
	{
		
		// =====================
		// 定义
		// =====================
		private static var _colorMatrixFilter_disable : ColorMatrixFilter;			
		private static var _colorMatrixFilter_recover : ColorMatrixFilter;
		
		public static const SINGLE_CLICK : String = "singleClick";
		// =====================
		// 属性
		// =====================
		private var _nameTF:TextField;
		private var _itemBg:Sprite;
		// =====================
		// Getter/Setter
		// =====================
	    override public function set source(value:*):void
		{
		    _source=value;	
			updateContent();
		}
		
		public function setMouseDown():void
		{
		  _itemBg.filters=[colorMatrixFilter_disable];
		}		
		
		
		public function setMouseOver():void
		{
		  _itemBg.filters=[colorMatrixFilter_disable];
		}
		
		public function setMouseOut():void
		{
		  _itemBg.filters=[colorMatrixFilter_recover];	
		}
		
		public function getRidingItemVO():RidingVO
		{
			return (_source as RidingVO);
		}
		
		// =====================
		// 方法
		// =====================
		
		public function RidingItemCell()
		{
		    var data : GComponentData = new GComponentData();
			data.width = 50;
			data.height = 50;
			super(data);	
		}
		
	    public static function get colorMatrixFilter_disable() : ColorMatrixFilter
		{
			if (_colorMatrixFilter_disable == null)
			{
				var colorChange : ColorChange = new ColorChange();
				colorChange.adjustSaturation(-100);
				_colorMatrixFilter_disable = new ColorMatrixFilter(colorChange);
			}
			return _colorMatrixFilter_disable;
		}	
		
	    public static function get colorMatrixFilter_recover() : ColorMatrixFilter
		{
			if (_colorMatrixFilter_recover == null)
			{
				var colorChange : ColorChange = new ColorChange();
				colorChange.adjustSaturation(1);
				_colorMatrixFilter_recover = new ColorMatrixFilter(colorChange);
			}
			return _colorMatrixFilter_recover;
		}				
		
		override protected function create():void
		{
			addBg();
			addItemName();
		}
		
		private function addBg():void
		{
			_itemBg=UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));
			_itemBg.width=50;
			_itemBg.height=50;
			addChild(_itemBg);
		}
		
		private function addItemName():void
		{
			_nameTF=UICreateUtils.createTextField("", null, 40, 25, 10, 30, UIManager.getTextFormat(10, 0xff2f1f00, TextFormatAlign.CENTER));
			addChild(_nameTF);
		}
		
		// ------------------------------------------------
		// 更新
		// ------------------------------------------------	
		override protected function onShow():void
		{
			super.onShow();
		}

		override protected function onHide():void
		{
			super.onHide();
		}
			
		private function updateContent():void
		{
			_nameTF.text=(_source as RidingVO).mountName;
		}
		
		// ------------------------------------------------
		// 交互
		// ------------------------------------------------		
			
		
	}
}
