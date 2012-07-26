package com.commUI.tooltip
{
	import game.core.item.ItemManager;
	import game.core.item.Item;
	import game.core.hero.VoHero;

	import gameui.core.ScaleMode;

	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	/**
	 * @author 1
	 */
	public class specialHeroToolTip extends ToolTip
{
		public function specialHeroToolTip(data : ToolTipData)
		{
			data.labelData.scaleMode = ScaleMode.SCALE9GRID;
			data.labelData.wordWrap = true;
			super(data);
		}
		
		override protected function getToolTipText():String
		{
			var text : String = "";
			var hero : VoHero = _source as VoHero;

			text += '<font size="14"><b>' + hero.htmlName + '</b></font>' + "\r";
			text += "职业：" + hero.jobName + "\r";
			text += "技能：" + hero.sutra.skill + "\r";
			text += hero.sutra.story+ "\r\r";;
//			text += StringUtils.addColor("CTRL+左键发送到聊天频道", "#999999");
			
			var cost:Item = ItemManager.instance.newItem(hero.config.relic);
				text +="招募所需"+cost.htmlName +": "+hero.config.sutraValue;
//			if(hero.color==ColorUtils.BLUE)
//			{
//			}
//			else if(hero.color==ColorUtils.GREEN)
//			{
//				text +="招募所需"+StringUtils.addColorById("七星符印", ColorUtils.GREEN) +": 10";
//			}
			return text;
		}
	}
}
