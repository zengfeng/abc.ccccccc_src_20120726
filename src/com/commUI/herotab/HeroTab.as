package com.commUI.herotab
{
	import com.commUI.tooltip.SimpleHeroTip;

	import gameui.controls.GToolTip;

	import game.core.hero.VoHero;

	import gameui.controls.GTab;
	import gameui.core.PhaseState;
	import gameui.data.GTabData;

	import com.commUI.icon.HeroIcon;
	import com.commUI.icon.HeroIconData;

	/**
	 * @author yangyiqiang
	 */
	public class HeroTab extends GTab
	{
		// =====================
		// 属性
		// =====================
		protected var _icon : HeroIcon;

		// =====================
		// Setter/Getter
		// =====================
		override public function set source(value : *) : void
		{
			_icon.source = value;
			enabled = (value != null);
		}

		override public function get source() : *
		{
			return _icon.source;
		}

		public function get hero() : VoHero
		{
			return _icon.source as VoHero;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function HeroTab(data : GTabData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			addHeroIcon();
			addHitArea();
			_label.visible = false;
			_label.mouseEnabled = false;
		}

		private function addHeroIcon() : void
		{
			var data : HeroIconData = new HeroIconData();
			data.showToolTip = true;
			data.sendToChat = true;
			data.toolTip = (_data.toolTip != GToolTip) ? _data.toolTip : SimpleHeroTip;

			_icon = new HeroIcon(data);
			addChild(_icon);
		}

		private function addHitArea() : void
		{
			// var hitAreaMask : Sprite = UIManager.getUI(_data.upAsset);
			// hitAreaMask.width = width - 3;
			//
			// this.hitArea = hitAreaMask;
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		override protected function viewSkin() : void
		{
			super.viewSkin();

			if (enabled && _phase == PhaseState.DOWN)
			{
				if (_selectedUpSkin) _current = swap(_current, _selectedUpSkin);
			}
		}

		override protected function onEnabled() : void
		{
			this.visible = enabled;
			viewSkin();
		}
		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
	}
}
