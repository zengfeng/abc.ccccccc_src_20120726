package com.commUI.tooltip
{
	import game.core.item.Item;

	/**
	 * @author jian
	 */
	public class MoneyTip extends ToolTip
	{
		public function MoneyTip(data : ToolTipData)
		{
			super(data);
		}
		
		override protected function getToolTipText() : String
		{
			var item:Item = _source as Item;
			
			return (item.nums>0?item.nums.toString():"") + item.name;
		}
	}
}
