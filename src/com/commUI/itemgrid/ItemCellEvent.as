package com.commUI.itemgrid
{
	import flash.events.Event;
	import game.core.item.Item;
	/**
	 * @author jian
	 */
	public class ItemCellEvent extends Event
	{
		public static const SELECT:String = "select_cell";
		
		public var item:Item;
		
		function ItemCellEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
