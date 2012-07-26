package com.commUI.herotab
{
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.net.core.Common;
	import game.net.data.CtoC.CCTeamChange;
	import game.net.data.CtoC.CCUserDataChangeUp;

	import gameui.core.GComponent;
	import gameui.group.GToggleGroup;
	import gameui.manager.UIManager;

	import model.SingleSelectionModel;

	import net.AssetData;

	import com.utils.HeroUtils;

	import flash.display.Sprite;

	/**
	 * @author yangyiqiang
	 */
	public class HeroTabList extends GComponent
	{
		// =====================
		// 属性
		// =====================
		private var _bgAsset : Sprite;
		private var _selectedHero : VoHero;
		protected var _group : GToggleGroup;

		// =====================
		// Getter/Setter
		// =====================
		public function get selection() : VoHero
		{
			if (!_group.selection)
				return null;

			return (_group.selection as HeroTab).source;
		}

		public function get selectionModel() : SingleSelectionModel
		{
			return _group.selectionModel;
		}

		public function get group() : GToggleGroup
		{
			return _group;
		}

		protected function get thisdata() : HeroTabListData
		{
			return _base as HeroTabListData;
		}

		override public function set source(value : *) : void
		{
			super.source = value;

			update();
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function HeroTabList(data : HeroTabListData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			_group = new GToggleGroup();

			for (var i : int = 0;i < thisdata.rows;i++)
			{
				for (var j : int = 0; j < thisdata.cols;j++)
				{
					var tab : HeroTab = new (_base as HeroTabListData).tabClass (thisdata.tabData);
					tab.x = j * (thisdata.tabData.width + thisdata.tabData.gap);
					tab.y = i * (thisdata.tabData.height + thisdata.tabData.gap);
					tab.group = _group;
					addChild(tab);
				}
			}

		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function update() : void
		{
			_selectedHero = selection;

			if (thisdata.loadMyHeroes)
				updateList(HeroManager.instance.teamHeroes.sort(HeroUtils.sortFun));
			else
				updateList(_source);
			selectDefaultHero();
		}

		protected function updateList(heroes : Array = null) : void
		{
			var heroNums : int = (heroes != null) ? heroes.length : 0;

			var heroTab : HeroTab;
			for (var i : int = 0;i < thisdata.rows * thisdata.cols;i++)
			{
				heroTab = _group.model.source[i];
				if (i < heroNums)
					heroTab.source = heroes[i];
				else
					heroTab.source = null;
			}
		}

		private function selectDefaultHero() : void
		{
			if (_group.model.size <= 0)
				return;

			var heroTab : HeroTab;

			if (!_selectedHero)
			{
				_group.selectionModel.index = 0;
				_selectedHero = selection;
				_group.model.source[0].selected = true;
			}
			else
			{
				var has : Boolean = false;
				for each ( heroTab in  _group.model.source)
				{
					if (heroTab.source && heroTab.source.id == _selectedHero.id)
					{
						heroTab.selected = true;
						has = true;
						break;
					}
				}

				if (!has)
				{
					_group.selectionModel.index = 0;
					_selectedHero = selection;
					_group.model.source[0].selected = true;
				}
			}
		}

		public function selectHero(id : int) : void
		{
			for each (var cell:HeroTab in _group.model.source)
			{
				if (cell.source && cell.source.id == id)
				{
					cell.selected = true;
					break;
				}
			}
		}

		public function set bgAsset(asset : AssetData) : void
		{
			if (_bgAsset) removeChild(_bgAsset);

			_bgAsset = UIManager.getUI(asset);

			addChildAt(_bgAsset, 0);
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			if (thisdata.loadMyHeroes)
				update();
			Common.game_server.addCallback(0xFFF4, onTeamChange);
			Common.game_server.addCallback(0xFFF1, onHeroLevelUp);
		}

		override protected function onHide() : void
		{
			Common.game_server.removeCallback(0xFFF4, onTeamChange);
			Common.game_server.removeCallback(0xFFF1, onHeroLevelUp);
			super.onHide();
		}

		private function onTeamChange(msg : CCTeamChange) : void
		{
			update();
		}

		private function onHeroLevelUp(msg : CCUserDataChangeUp) : void
		{
			update();
		}
	}
}
