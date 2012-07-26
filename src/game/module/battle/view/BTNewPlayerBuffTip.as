package game.module.battle.view
{
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipData;
	import gameui.core.ScaleMode;
	
	public class BTNewPlayerBuffTip extends ToolTip
	{
		public function BTNewPlayerBuffTip(data:ToolTipData)
		{
			data.labelData.wordWrap = true;
			data.labelData.textFormat.leading = 0;
			data.labelData.scaleMode = ScaleMode.SCALE9GRID;
			super(data);
		}
		
		override protected function getToolTipText():String
		{
			var tips:String = "";
			
			if(true)
			{
				tips = "<b><font size= '14' color='#FFFF00'>新手祝福</font></b>\r";
				tips += "\r";
    			tips += "所有队员初始聚气加<font color='#279F15'> 30</font>\r";
				tips += "\r\r";
				//tips += "所有队员初始聚气加30" + "\r";
				tips += "<font color='#999999'>"+"30级前任务战斗有效"+"</font>\r";
			}
			return tips;
		}
	}
}