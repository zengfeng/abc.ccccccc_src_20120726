package com.commUI.tooltip
{
	import gameui.skin.SkinStyle;
	import com.utils.TextFormatUtils;
	import game.definition.UI;
	import gameui.core.ScaleMode;
	import gameui.data.GToolTipData;
	import net.AssetData;




	/**
	 * @author jian
	 */
	public class ToolTipData extends GToolTipData
	{
		public function ToolTipData()
		{
			width = 176;
//			backgroundAsset = new AssetData(SkinStyle.emptySkin);
			
			padding = 10;
			scaleMode = ScaleMode.AUTO_SIZE;
			labelData.textFormat = TextFormatUtils.toolTipContent;
			labelData.textFieldFilters = [];
			labelData.width = 168;
		}
	}
}
