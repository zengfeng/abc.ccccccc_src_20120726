package game.module.heroPanel
{
	import com.commUI.LoginPanel;
	import com.commUI.tooltip.WordWrapToolTip;
	import game.core.hero.VoHero;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author yangyiqiang
	 */
	public class HeroNature extends GComponent
	{
		// =====================
		// 属性
		// =====================
		private var _hero : VoHero;
		private var _nameText : TextField;
		private var _levelText : TextField;
		private var _skillText : TextField;
		private var _btText : TextField;
		private var _jobText : TextField;

		// =====================
		// getter/setter
		// =====================
		override public function set source(value : *) : void
		{
			_hero = value;
			updateTexts();
		}

		// =====================
		// 方法
		// =====================
		public function HeroNature()
		{
			var data : GComponentData = new GComponentData();
			data.width = 302;
			data.height = 55;

			super(data);
		}

		override protected function create() : void
		{
			super.create();
			addBackground();
			addTexts();
		}

		private function addBackground() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData("common_background_03"));
			bg.width = width;
			bg.height = height;
			addChild(bg);
		}

		private function addTexts() : void
		{
			_nameText = UICreateUtils.createTextField("姓名：", null, 120, 20, 3, 5, TextFormatUtils.panelContent);
			TextFormat
			addChild(_nameText);

			_levelText = UICreateUtils.createTextField("等级：", null, 120, 20, 125, 5, TextFormatUtils.panelContent);
			addChild(_levelText);

			_skillText = UICreateUtils.createTextField("技能：", null, 120, 20, 202, 5, TextFormatUtils.panelContent);
			_skillText.selectable = false;
			_skillText.mouseEnabled = true;
			addChild(_skillText);

			_btText = UICreateUtils.createTextField("战斗力：", null, 120, 20, 3, 27, TextFormatUtils.panelContent);
			addChild(_btText);

			_jobText = UICreateUtils.createTextField("职业：", null, 120, 20, 125, 27, TextFormatUtils.panelContent);
			addChild(_jobText);
		}

		public function updateTexts() : void
		{
			_nameText.htmlText = "姓名：" + _hero.htmlName;
			_levelText.htmlText = "等级：" + _hero.level;
			_skillText.htmlText = "技能：" + _hero.sutra.skill;
			_btText.htmlText = "战斗力：" + _hero.bt;
			_jobText.htmlText = "职业：" + _hero.jobName;
		}

		public function refreshProp() : void
		{
			updateTexts();
		}

		override protected function onShow() : void
		{
			ToolTipManager.instance.registerToolTip(_skillText, WordWrapToolTip, provideToolTipString);
		}

		override protected function onHide() : void
		{
			ToolTipManager.instance.destroyToolTip(_skillText);
		}

		protected function provideToolTipString() : String
		{
			if (_hero)
				return _hero.sutra.story;
			else
				return "";
		}
	}
}
