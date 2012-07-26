package game.module.battle.view
{
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipData;
	
	import gameui.core.ScaleMode;

	public class BTGuardBuffTip extends ToolTip
	{
		private var gurdLevel:uint;
		public function BTGuardBuffTip(data:ToolTipData)
		{
			data.labelData.wordWrap = true;
			data.labelData.scaleMode = ScaleMode.SCALE9GRID;
			
			super(data);
		}
		
		override protected function getToolTipText():String
		{
			var tips:String = "";
			var tipd:BTArtifactData = _source as BTArtifactData;
			var colortype:uint;
			if(tipd)
			{
				colortype = tipd.getArtfactLevel();
				tips = "<b><font size= '14' color='#FFFF00'>"+ "仙龟护体" + "</font>\r</b>";
				tips += "\r";
				if(colortype == 1)
				{
					tips += "运送<font color ='#279F15'>普通香炉</font>时，攻击提高" + "<font color = '#279F15'>5%</font>" + "，生命提高" + "<font color = '#279F15'>5%</font>\r";
				}
				else if(colortype == 2)
				{
					tips += "运送<font color ='#279F15'>初级香炉</font>时，攻击提高" + "<font color = '#279F15'>10%</font>" + "，生命提高" + "<font color = '#279F15'>10%</font>\r";
				}
				else if(colortype == 3)
				{
					tips += "运送<font color ='#3882D4'>中级香炉</font>时，攻击提高" + "<font color = '#279F15'>15%</font>" + "，生命提高" + "<font color = '#279F15'>15%</font>\r";
				}
				else if(colortype == 4)
				{
					tips += "运送<font color ='#CE5DD4'>高级香炉</font>时，攻击提高" + "<font color = '#279F15'>20%</font>" + "，生命提高" + "<font color = '#279F15'>20%</font>\r";
				}
				tips += "\r\r";
				tips += "<font color = '#999999'>只有在仙龟拜佛中有效</font>";
			}
			return tips;
		}
	}
}