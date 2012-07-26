package com.commUI.tooltip
{
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	/**
	 * @author zheng
	 */
	public class FindHeroRuleTip extends ToolTip
	{
		public function FindHeroRuleTip(data : ToolTipData)
		{
			super(data);
			data.labelData.wordWrap=false;
			data.labelData.width=350;
		}
		
		override protected function getToolTipText() : String
		{
			var text : String = "点击“请神”按钮，随机出现下列神仙之一\r";
            var str:String="七星符印";
			text += "<font size='12' color='#FFCC00'>福神：</font>" +"<font size='12' color='#ffffff'>福神送你</font>"+StringUtils.addColorById(str,ColorUtils.BLUE)+"\r";
			str="龙纹玉珏";			
			text += "<font size='12' color='#FFCC00'>财神：</font>" +"<font size='12' color='#ffffff'>财神送你</font>"+StringUtils.addColorById(str,ColorUtils.GREEN)+"\r";		
			text += "<font size='12' color='#FFCC00'>土地：</font>"+"<font size='12' color='#ffffff'>下次请神效果翻倍（可累计）</font>"+"\r";
			text += "<font size='12' color='#FFCC00'>穷神：</font>"+"<font size='12' color='#ffffff'>嘿嘿，穷神上身，一无所获</font>";

			return text;
		}
	}
}
