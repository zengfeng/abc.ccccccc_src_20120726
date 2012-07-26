package com.commUI.pager
{
	import game.definition.UI;
	import gameui.cell.GCellData;
	import net.AssetData;

	/**
	 * @author jian
	 */
	public class PagerCellData extends GCellData
	{
		// =====================
		// 定义
		// =====================
		public static const FIRST : uint = 0;
		public static const PREVIOUS : uint = 1;
		public static const NEXT : uint = 2;
		public static const NUMBER : uint = 3;
		
		// =====================
		// 属性
		// =====================
		public var type : uint;
		
		// =====================
		// 方法
		// =====================
		public function PagerCellData()
		{
			super();
			
			height = 16;
			upAsset = new AssetData(UI.PAGER_BG_UP);
			selected_upAsset = new AssetData(UI.PAGER_BG_OVER);
			overAsset = new AssetData(UI.PAGER_BG_OVER);
			selected_overAsset = new AssetData(UI.PAGER_BG_OVER);
			disabledAsset = new AssetData(UI.PAGER_BG_UP);
		}
	}
}
