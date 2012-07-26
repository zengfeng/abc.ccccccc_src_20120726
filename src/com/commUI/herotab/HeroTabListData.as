package com.commUI.herotab
{
	import gameui.core.GComponentData;
	import gameui.data.GTabData;

	/**
	 * @author jian
	 */
	public class HeroTabListData extends GComponentData
	{
		// public var type:uint;
		public var rows : uint;
		public var cols : uint;
		public var showDisable : Boolean;
		public var tabData : GTabData;
		public var tabClass : Class;
		public var loadMyHeroes:Boolean;

		public function HeroTabListData()
		{
			super();
			rows = 8;
			cols = 1;
			showDisable = true;
			width = 75;
			height = 350;
			loadMyHeroes = true;
			tabClass = HeroTab;
		}
	}
}
