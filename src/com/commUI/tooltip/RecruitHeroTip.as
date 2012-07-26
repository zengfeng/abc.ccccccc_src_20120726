package com.commUI.tooltip
{
	import game.core.hero.VoHero;

	import gameui.core.ScaleMode;

	import com.utils.StringUtils;

	/**
	 * @author jian
	 */
	public class RecruitHeroTip extends ToolTip
	{
		public function RecruitHeroTip(data : ToolTipData)
		{
			data.labelData.scaleMode = ScaleMode.SCALE9GRID;
			data.labelData.wordWrap = true;
			super(data);
		}
		
		override protected function getToolTipText():String
		{
			var text : String = "";
			var hero : VoHero = _source as VoHero;

			text += '<font size="14"><b>' + StringUtils.addColorById(hero._name, hero.color) + '</b></font>' + "\r";
			text += "职业：" + hero.jobName + "\r";
			text += "技能：" + hero.sutra.skill + "\r";
			text += hero.sutra.story + "\r";
			
			return text;
		}
	}
}
