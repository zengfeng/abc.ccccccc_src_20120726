package game.module.recruitHero.highFindHero
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.SingleSelectionModel;
	import game.core.hero.HeroManager;
	import com.commUI.HeroColorTab;
	import game.core.hero.VoHero;
	import game.core.user.UserData;

	import gameui.core.GComponent;
	import gameui.group.GToggleGroup;

	import com.commUI.herotab.HeroTab;
	import com.utils.HeroUtils;
	/**
	 * @author zheng
	 */
	 
	 
	public class AllHeroList extends GComponent
	{
		protected var _group : GToggleGroup;
		private static const rows:int=1;
		private static const cols : int = 9;
		private var _tabs : Array;
		
		public function get selectionModel():SingleSelectionModel
		{
			return _group.selectionModel;
		}
		
		public function get selectedHero():VoHero
		{
			if (_group.selection)
			{
				return (_group.selection as HeroTab).hero;
			}
			return null;
		}
		
		
		public function AllHeroList(data:AllHeroListData)
		{
			super(data);
			this.height=800;
			this.width=100;
		}
		
		override protected function create() : void
		{
			super.create();

			_group = new GToggleGroup();
            _tabs = [];
				for (var j : int = 0; j < cols;j++)
				{
					var tab : HeroColorTab = new HeroColorTab(thisdata.tabData);					
					tab.addEventListener(MouseEvent.CLICK, tab_clickHandler);
//					tab.disableRollOver = true;
					tab.x = j * (thisdata.tabData.width + thisdata.tabData.gap);
					_tabs.push(tab);
					tab.group = _group;
					addChild(tab);
				}
            
			updateList();
		}


		
		protected function updateList() : void
		{
			var heroes : Array = HeroManager.instance.allHeroes.filter(HeroUtils.filterOtherHeroColor).sort(HeroUtils.sortOtherHeroColor);
			var heroNums : int = heroes.length;
			
            
			var heroTab : HeroColorTab;
			for (var i : int = 0;i < thisdata.cols;i++)
			{    
				heroTab = _tabs[i];
				if (i < heroNums)
					heroTab.source = heroes[i];
				else
					heroTab.source = null;
			}
		}
		
		protected function get thisdata() : AllHeroListData
		{
			return _base as AllHeroListData;
		}
		
		override protected function onShow():void
		{
			super.onShow();
			
			for each(var tab:HeroTab in _tabs)
			{
				tab.addEventListener(MouseEvent.CLICK, tab_clickHandler);
			}
		}
		
	    override protected function onHide():void
		{
			super.onHide();
			
			for each(var tab:HeroTab in _tabs)
			{
				tab.removeEventListener(MouseEvent.CLICK, tab_clickHandler);
			}
		}
		
		private function tab_clickHandler(event : MouseEvent) : void
		{
			event.stopImmediatePropagation();
			dispatchEvent(new Event(Event.SELECT));
		}
		
	}
}
