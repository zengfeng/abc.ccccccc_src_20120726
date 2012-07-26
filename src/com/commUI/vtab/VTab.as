package com.commUI.vtab
{
	import com.utils.TextFormatUtils;
	import flash.events.MouseEvent;
	import game.definition.UI;
	import gameui.cell.LabelSource;
	import gameui.controls.GTab;
	import gameui.core.GAlign;
	import gameui.core.PhaseState;
	import gameui.core.ScaleMode;
	import gameui.data.GLabelData;
	import gameui.data.GTabData;
	import gameui.layout.GLayout;
	import net.AssetData;






	/**
	 * @author verycd
	 */
	public class VTab extends GTab
	{
		private static var _tabUpAsset : AssetData = new AssetData(UI.BUTTON_RIGHTTAB_UNSEL_UP);
		private static var _tabOverAsset : AssetData = new AssetData(UI.BUTTON_RIGHTTAB_UNSEL_OVER);
		private static var _tabSelectedUpAsset : AssetData = new AssetData(UI.BUTTON_RIGHTTAB_SEL_UP);
//		private static var _tabSelectedUpAsset : AssetData = new AssetData(UI.BUTTON_RIGHTTAB_SEL_OVER);
//		private static var _tabSelectedOverAsset : AssetData = new AssetData(UI.BUTTON_RIGHTTAB_UNSEL_OVER);

		public function VTab()
		{
			var tabData : GTabData = new GTabData();
			tabData.scaleMode = ScaleMode.SCALE_WIDTH;
			tabData.labelData.align = new GAlign(-1, -1, -1, -1, -2, 0);
			tabData.upAsset = _tabUpAsset;
			tabData.overAsset = _tabOverAsset;
			tabData.selectedUpAsset = _tabSelectedUpAsset;
			tabData.width = 59;
			tabData.height = 33;

			super(tabData);
		}

		override public function set source(value : */* LabelSource */) : void
		{
			_source = value;
			_label.text = LabelSource(value).text;
			layout();
		}

		override protected function create() : void
		{
			super.create();
//			_label.x = 5;
//			_label.y = 2;
		}

		override protected function layout() : void
		{
			super.layout();
		}

		override protected function mouseUpHandler(event : MouseEvent) : void
		{
			if (_phase != PhaseState.DOWN) return;
			super.mouseUpHandler(event);
		}

		public function unGroup() : void
		{
			if (_group)
			{
				_group.model.remove(this);
				_group = null;
			}
		}
	}
}
