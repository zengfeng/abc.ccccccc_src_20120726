package game.module.recruitHero.highFindHero
{
	import gameui.core.GComponentData;
	import gameui.data.GTabData;
	/**
	 * @author zheng
	 */
	public class AllHeroListData extends GComponentData
	{
				public var rows : uint;
		public var cols : uint;
		public var showDisable : Boolean;
		public var tabData : GTabData;

		public function AllHeroListData()
		{
			super();
			rows = 1;
			cols = 9;
			showDisable = true;
			width = 350;
			height = 70;
		}
	}
}
