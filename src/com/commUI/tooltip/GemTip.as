package com.commUI.tooltip
{
	import com.utils.StringUtils;
	import game.core.item.gem.Gem;


	/**
	 * @author jian
	 */
	public class GemTip extends ItemTip
	{
		public function GemTip(data : ToolTipData)
		{
			super(data);
		}

		override protected function getToolTipText() : String
		{
			var text : String = "";

			text += getDescriptionText() + "\r\r";
			text += getSellPriceText() + "\r";
			text += getSendChatText() + "\r";

			return text;
		}

		override protected function getItemNameText() : String
		{
			var item : Gem = _source as Gem;
			var text : String = '<font size="14"><b>' + StringUtils.addColorById(item.name + " " + item.level  + "级", item.color)+  "</b></font>";
			return text;
		}
	}
}
