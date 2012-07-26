package game.module.enhance
{
	import game.core.hero.HeroConfig;
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;

	import gameui.group.GToggleGroup;

	import com.commUI.herotab.HeroTab;
	import com.commUI.herotab.HeroTabList;
	import com.commUI.herotab.HeroTabListData;
	import com.utils.HeroUtils;
	import com.utils.UICreateUtils;



	/**
	 * @author jian
	 */
	public class EnhanceHeroList extends HeroTabList
	{
		public function get heroId() : uint
		{
			var tab : HeroTab = this.group.selection as HeroTab;
			return tab.source.id;
		}

		public function EnhanceHeroList()
		{
			var data : HeroTabListData = new HeroTabListData();
			data.rows = 6;
			data.tabData = UICreateUtils.tabDataHeroRight;
			super(data);
		}

		override protected function create() : void
		{
			_group = new GToggleGroup();

			for (var i : int = 0;i < thisdata.rows;i++)
			{
				var tab : EnhanceHeroTab = new EnhanceHeroTab(thisdata.tabData);
				tab.x = 0;
				tab.y = i * 50;
				tab.group = _group;
				addChild(tab);
			}

			updateList(HeroManager.instance.teamHeroes.sort(HeroUtils.sortFun));
		}

		override protected function updateList(heroes:Array=null) : void
		{
			var heroNums : int = (heroes !=null)?heroes.length:0;

			var heroTab : EnhanceHeroTab;
			for (var i : int = 0;i < thisdata.rows;i++)
			{
				heroTab = group.model.source[i];

				if ((i == thisdata.rows - 1 && heroNums >= thisdata.rows) || i == heroNums)
				{
					var other : VoHero = new VoHero();
					other.config = new HeroConfig();
					other.id = 0;
					heroTab.source = other;
				}
				else if (i < heroNums)
					heroTab.source = heroes[i];
				else
					heroTab.source = null;
			}
		}

		public function get heroes() : Array /* of Hero */
		{
			var array : Array = [];
			for each (var cell:HeroTab in group.model.source)
			{
				if (cell.source)
				{
					var heroid : uint = cell.source.id;
					if (heroid != 0)
						array.push(heroid);
				}
			}
			return array;
		}
	}
}
