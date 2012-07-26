package com.commUI.tooltip
{
	import com.utils.StringUtils;
	import com.utils.printf;
	import game.core.hero.VoHero;
	import game.core.item.soul.Soul;


	/**
	 * @author jian
	 */
	public class SoulPowerTip extends ToolTip
	{
		public function SoulPowerTip(data : ToolTipData)
		{
			super(data);
		}
		
		override protected function getToolTipText():String
		{
			var hero:VoHero = _source as VoHero;
			var text:String = "";
			if (hero)
			{
				if (hero.souls.length == 0)
					return "未装备元神";
					
				for each (var soul:Soul in  hero.souls)
				{
					text += StringUtils.addColorById(soul.name + " " + printf("%2s", soul.level) + "级", soul.color) + " " + soul.description + "\r";
				}
			}
			
			return text;
		}
		
//		override protected function layout() : void
//		{		
//			_width = Math.max(_data.minWidth, _data.padding * 2 + _label.width);
//			_height = _data.padding * 2 + _label.height;
//
//			_backgroundSkin.width = _width;
//			_backgroundSkin.height = _height;
//		}
	}
}
