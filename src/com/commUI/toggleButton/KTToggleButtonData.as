package com.commUI.toggleButton
{
	import gameui.core.GAlign;
	import gameui.data.GLabelData;
	import gameui.data.GToggleButtonData;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	/**
	 * @author jian
	 */
	public class KTToggleButtonData extends GToggleButtonData
	{
		public static const NORMAL_TOGGLE_BUTTON : uint = 0;
		public static const SWITCH_TOGGLE_BUTTON : uint = 1;

		public function KTToggleButtonData(type : uint = NORMAL_TOGGLE_BUTTON, allowDisable : Boolean = false)
		{
			if (type == NORMAL_TOGGLE_BUTTON)
			{
				width = 45;
				height = 20;
				upAsset = new AssetData(SkinStyle.toggleButton_upSkin);
				overAsset = new AssetData(SkinStyle.toggleButton_overSkin);
				downAsset = new AssetData(SkinStyle.toggleButton_downSkin);
				selectedUpAsset = new AssetData(SkinStyle.toggleButton_selectedUpSkin);
				selectedOverAsset = new AssetData(SkinStyle.toggleButton_selectedOverSkin);
				selectedDownAsset = new AssetData(SkinStyle.toggleButton_selectedDownSkin);

				if (allowDisable)
				{
					disabledAsset = new AssetData(SkinStyle.toggleButton_downSkin);
					selectedDisabledAsset = new AssetData(SkinStyle.toggleButton_selectedDisabledSkin);
				}

				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
				labelData.textColor = 0x82bffa;
				textRollOverColor = 0xFFFFFF;
			}
			else if (type == SWITCH_TOGGLE_BUTTON)
			{
				width = 70;
				height = 20;
				upAsset = new AssetData("switchButton_close_up");
				overAsset = new AssetData("switchButton_close_over");
				downAsset = new AssetData("switchButton_close_over");
				selectedUpAsset = new AssetData("switchButton_open_up");
				selectedOverAsset = new AssetData("switchButton_open_over");
				selectedDownAsset = new AssetData("switchButton_open_over");
				
				labelData = new GLabelData();
				labelData.align = new GAlign(18, -1, -1, -1, -1, -7);
			}
		}
	}
}
