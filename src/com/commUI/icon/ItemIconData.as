package com.commUI.icon
{
	import gameui.core.GComponentData;

	/**
	 * @author jian
	 */
	public class ItemIconData extends GComponentData
	{
		public var showBorder : Boolean = false;
		public var showBg : Boolean = false;
		public var showNums : Boolean = false;
		public var showLevel : Boolean = false;
		public var showOwner : Boolean = false;
		public var showBinding : Boolean = false;
		public var showToolTip : Boolean = false;
		public var showShopping : Boolean = false;
		public var showPair : Boolean = false;
		public var showRollOver : Boolean = false;
		public var showName : Boolean = false;
		public var shopMinLimit : uint = 0;
		public var sendChat : Boolean = true;
		// 少于minNums就显示红色个数
		public var minNums : int = 1;

		public function ItemIconData()
		{
			super();

			width = 48;
			height = 48;
		}

		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : ItemIconData = source as ItemIconData;
			if (data == null) return;

			data.showBorder = showBorder;
			data.showBg = showBg;
			data.showNums = showNums;
			data.showLevel = showLevel;
			data.showOwner = showOwner;
			data.showBinding = showBinding;
			data.showToolTip = showToolTip;
			data.showShopping = showShopping;
			data.showPair = showPair;
		}

		override public function clone() : *
		{
			var data : ItemIconData = new ItemIconData();
			parse(data);
			return data;
		}
	}
}
