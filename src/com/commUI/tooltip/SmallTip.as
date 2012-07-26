package com.commUI.tooltip
{
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipData;

	/**
	 * @author jian
	 */
	public class SmallTip extends ToolTip
	{
		public function SmallTip(data : ToolTipData)
		{
			super(data);
		}
		
		override protected function layout():void
		{
			_width = Math.max(_data.minWidth, _data.padding * 2 + _label.width);
			_height = _data.padding * 2 + _label.height;

			_backgroundSkin.width = _width;
			_backgroundSkin.height = _height;			
		}
	}
}
