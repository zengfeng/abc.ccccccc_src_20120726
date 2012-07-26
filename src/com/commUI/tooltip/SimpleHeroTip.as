package com.commUI.tooltip
{
	import game.core.hero.VoHero;

	import gameui.core.ScaleMode;

	import com.utils.StringUtils;


	/**
	 * @author jian
	 */
	public class SimpleHeroTip extends ToolTip
	{
		public function SimpleHeroTip(data : ToolTipData)
		{
			data.labelData.scaleMode = ScaleMode.SCALE9GRID;
			data.labelData.wordWrap = true;
			super(data);
		}
		
		override protected function getToolTipText():String
		{
			var text : String = "";
			var hero : VoHero = _source as VoHero;

//			text += '<font size="14"><b>' + hero.htmlName + " " + hero.level + "级" + '</b></font>' + "\r";
			text += '<font size="14"><b>' + hero.htmlName + '</b></font>' + "\r";
			text += "职业：" + hero.jobName + "\r";
			// TODO
			text += "战斗力：" + hero.bt + "\r\r";
			text += StringUtils.addColor("CTRL+左键发送到聊天频道", "#999999");
			
			return text;
		}
	}
}
