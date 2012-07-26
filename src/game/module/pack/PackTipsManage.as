package game.module.pack
{
	import com.commUI.tooltip.ToolTip;
	import com.utils.ItemUtils;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import game.core.item.Item;
	import gameui.data.GToolTipData;







	/**
	 * @author yangyiqiang
	 */
	public class PackTipsManage
	{
		private  static var _tips : ToolTip;
		private static var _cachedTips : Dictionary = new Dictionary();

		public static function showTips(point : Point) : void
		{
			if (!_tips) return;
			if (!_tips.parent)
				_tips.show();
			_tips.moveTo(point.x, point.y);
		}

		public static function hideTips() : void
		{
			if (!_tips) return;
			_tips.hide();
		}

		public static function set source(value : Item) : void
		{
			var toolTipClass:Class = ItemUtils.getItemToolTipClass(value);
			
			if (!_cachedTips[toolTipClass])
			{
				var toolTipData:GToolTipData = new GToolTipData();
				_cachedTips[toolTipClass] = new toolTipClass(toolTipData);
			}
			
			_tips = _cachedTips[toolTipClass];
			_tips.source = value;
		}
	}
}
