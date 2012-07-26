package com.commUI
{
	import flash.utils.Dictionary;

	import game.definition.UI;

	import gameui.core.PhaseState;
	import gameui.data.GTabData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.herotab.HeroTab;
	import com.utils.ColorUtils;

	import flash.display.Sprite;

	/**
	 * @author jian
	 */
	public class HeroColorTab extends HeroTab
	{
		private static var _overSkinAssets : Dictionary = initOverSkinAssets();

		private static function initOverSkinAssets() : Dictionary
		{
			var dict : Dictionary = new Dictionary();
			dict[ColorUtils.GREEN] = new AssetData(UI.HEROTAB_GREEN_OVER);
			dict[ColorUtils.BLUE] = new AssetData(UI.HEROTAB_BLUE_OVER);
			dict[ColorUtils.VIOLET] = new AssetData(UI.HEROTAB_VIOLET_OVER);
			dict[ColorUtils.ORANGE] = new AssetData(UI.HEROTAB_ORANGE_OVER);
			return dict;
		}

		private static var _upSkinAssets : Dictionary = initUpSkinAssets();

		private static function initUpSkinAssets() : Dictionary
		{
			var dict : Dictionary = new Dictionary();
			dict[ColorUtils.GREEN] = new AssetData(UI.HEROTAB_GREEN_UP);
			dict[ColorUtils.BLUE] = new AssetData(UI.HEROTAB_BLUE_UP);
			dict[ColorUtils.VIOLET] = new AssetData(UI.HEROTAB_VIOLET_UP);
			dict[ColorUtils.ORANGE] = new AssetData(UI.HEROTAB_ORANGE_UP);
			return dict;
		}

		private var _disableRollOver : Boolean = false;

		public function set disableRollOver(value : Boolean) : void
		{
			_disableRollOver = value;
		}

		override public function set source(value : *) : void
		{
			super.source = value;
			viewSkin();
		}

		public function HeroColorTab(data : GTabData)
		{
			super(data);
			_icon.x = 2;
			_icon.y = 1;
		}

		override protected function viewSkin() : void
		{
			if (_phase == PhaseState.UP)
			{
				if (_selected)
				{
					_current = swap(_current, getOverSkin());
				}
				else
				{
					_current = swap(_current, getUpSkin());
				}
			}
			else if (_phase == PhaseState.OVER)
			{
				_current = swap(_current, getOverSkin());
			}
		}

		private function getOverSkin() : Sprite
		{
			if (!hero)
				return _overSkin;

			if (_disableRollOver)
				return getUpSkin();
			else
				return UIManager.getUI(_overSkinAssets[hero.color]);
		}

		private function getUpSkin() : Sprite
		{
			if (!hero)
				return _upSkin;

			return UIManager.getUI(_upSkinAssets[hero.color]);
		}
	}
}
