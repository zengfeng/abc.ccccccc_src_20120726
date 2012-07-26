package com.commUI.tooltip {
	import game.core.item.sutra.Sutra;

	/**
	 * @author Lv
	 */
	public class SutraStepTip extends ToolTip {
		public function SutraStepTip(data : ToolTipData) {
			super(data);
		}
		override protected function getToolTipText():String
		{
			var text : String = "";
			var sutraStep : Sutra = _source as Sutra;
			text += "技能："+sutraStep.skill+" \r";
//			text += StringUtils.addSize(StringUtils.addColor(StringUtils.addBold("技能："+sutraStep.name+" \r"),"#DE5522"),14);
			if(sutraStep.stepProp == null)return text;
			text += sutraStep.story;
			return text;
		}
	}
}
