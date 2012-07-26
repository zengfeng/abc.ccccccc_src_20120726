package com.commUI.button
{
	import gameui.core.ScaleMode;

	import game.definition.UI;

	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;

	import net.AssetData;

	/**
	 * @author jian
	 */
	public class KTButtonData extends GButtonData
	{
		public static const NORMAL_BUTTON : uint = 0;
		public static const NORMAL_RED_BUTTON : uint = 1;
		public static const SMALL_BUTTON : uint = 2;
		public static const SMALL_RED_BUTTON : uint = 3;
		public static const ALERT_BUTTON : uint = 4;
		public static const PAGE_LEFT_BUTTON : int = 5;
		public static const PAGE_RIGHT_BUTTON : int = 6;
		public static const EXIT_BUTTON : int = 7;
		public static const REPORT_BUTTON : int = 8;
		public static const EXIT_ROUND_BUTTON : int = 9;

		public function KTButtonData(type : uint = NORMAL_BUTTON)
		{
			super();
			if (type == NORMAL_BUTTON)
			{
				upAsset = new AssetData(UI.BUTTON_NORAML_UP);
				overAsset = new AssetData(UI.BUTTON_NORMAL_OVER);
				downAsset = new AssetData(UI.BUTTON_NORMAL_DOWN);
				disabledAsset = new AssetData(UI.BUTTON_NORMAL_DISABLE);
				height = 30;
				width = 80;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			else if (type == NORMAL_RED_BUTTON)
			{
				upAsset = new AssetData(UI.BUTTON_NORAML_RED_UP);
				overAsset = new AssetData(UI.BUTTON_NORMAL_RED_OVER);
				downAsset = new AssetData(UI.BUTTON_NORMAL_RED_DOWN);
				disabledAsset = new AssetData(UI.BUTTON_NORMAL_RED_DISABLE);
				height = 30;
				width = 80;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			else if (type == SMALL_BUTTON)
			{
				upAsset = new AssetData(UI.BUTTON_SMALL_UP);
				overAsset = new AssetData(UI.BUTTON_SMALL_OVER);
				downAsset = new AssetData(UI.BUTTON_SMALL_DOWN);
				disabledAsset = new AssetData(UI.BUTTON_SMALL_DISABLE);
				height = 22;
				width = 80;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			else if (type == SMALL_RED_BUTTON)
			{
				upAsset = new AssetData(UI.BUTTON_SMALL_RED_UP);
				overAsset = new AssetData(UI.BUTTON_SMALL_RED_OVER);
				downAsset = new AssetData(UI.BUTTON_SMALL_RED_DOWN);
				disabledAsset = new AssetData(UI.BUTTON_SMALL_RED_DISABLE);
				height = 22;
				width = 80;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			else if (type == ALERT_BUTTON)
			{
				upAsset = new AssetData(UI.BUTTON_ALERT_UP);
				overAsset = new AssetData(UI.BUTTON_ALERT_OVER);
				downAsset = new AssetData(UI.BUTTON_ALERT_DOWN);
				disabledAsset = new AssetData(UI.BUTTON_ALERT_DISABLE);
				height = 26;
				width = 80;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			else if (type == PAGE_LEFT_BUTTON)
			{
				upAsset = new AssetData(UI.BUTTON_PAGE_LEFT_UP);
				overAsset = new AssetData(UI.BUTTON_PAGE_LEFT_OVER);
				downAsset = new AssetData(UI.BUTTON_PAGE_LEFT_DOWN);
				disabledAsset = new AssetData(UI.BUTTON_PAGE_LEFT_DISABLE);

				height = 21;
				width = 14;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			else if (type == PAGE_RIGHT_BUTTON)
			{
				upAsset = new AssetData(UI.BUTTON_PAGE_RIGHT_UP);
				overAsset = new AssetData(UI.BUTTON_PAGE_RIGHT_OVER);
				downAsset = new AssetData(UI.BUTTON_PAGE_RIGHT_DOWN);
				disabledAsset = new AssetData(UI.BUTTON_PAGE_RIGHT_DISABLE);

				height = 21;
				width = 14;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			else if (type == EXIT_BUTTON)
			{
				upAsset = new AssetData(UI.BUTTON_EXIT_UP);
				overAsset = new AssetData(UI.BUTTON_EXIT_OVER);
				downAsset = new AssetData(UI.BUTTON_EXIT_DOWN);
				disabledAsset = new AssetData(UI.BUTTON_EXIT_UP);

				scaleMode = ScaleMode.SCALE_NONE;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			else if (type == REPORT_BUTTON)
			{
				upAsset = new AssetData(UI.REPORT_CLOSE_UP);
				overAsset = new AssetData(UI.REPORT_CLOSE_OVER);
				downAsset = new AssetData(UI.REPORT_CLOSE_DOWN);
				disabledAsset = new AssetData(UI.REPORT_CLOSE_UP);

				height = 10;
				width = 10;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			else if (type == EXIT_ROUND_BUTTON)
			{
				upAsset = new AssetData(UI.BUTTON_ROUND_EXIT_UP);
				overAsset = new AssetData(UI.BUTTON_ROUND_EXIT_OVER);
				downAsset = new AssetData(UI.BUTTON_ROUND_EXIT_DOWN);
				disabledAsset = new AssetData(UI.BUTTON_ROUND_EXIT_UP);

				height = 48;
				width = 50;
				labelData = new GLabelData();
				labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			}
			labelData.wordWrap = false;
		}
	}
}
