package com.commUI.tooltip
{
	import gameui.core.ScaleMode;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipData;

	/**
	 * @author jian
	 */
	public class WordWrapToolTip extends ToolTip
	{
		public function WordWrapToolTip(data : ToolTipData)
		{
			data.labelData.wordWrap = true;
			data.labelData.scaleMode = ScaleMode.SCALE9GRID;
			super(data);
		}
	}
}
