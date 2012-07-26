package game.module.heroPanel
{
	import game.core.item.equipment.Equipment;

	import com.commUI.herotab.HeroTabList;
	import com.commUI.herotab.HeroTabListData;
	import com.commUI.tooltip.HeroPropPanelTip;
	import com.commUI.tooltip.SoulPowerTip;
	import com.commUI.tooltip.SutraTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.UICreateUtils;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jian
	 */
	public class OtherHeroPanel extends HeroPanel
	{
		// =====================
		// 属性
		// =====================
		private var _initiated : Boolean = false;
		private var _cachedHeroes : Array;

		// =====================
		// getter/setter
		// =====================
		public function set heroes(value : *) : void
		{
			if (!_initiated)
				_cachedHeroes = value;
			else
			{
				_heroTabList.source = value;

				selectDefaultHero();
				updateView();
			}
		}

		public function OtherHeroPanel()
		{
			super();
		}
		
		override public function getResList() : Array
		{
			return [];
		}

		override protected function addButtons() : void
		{
		}


		override protected function updateButtons() : void
		{
		}

		override protected function addHeroTabList() : void
		{
			var data : HeroTabListData = new HeroTabListData();
			data.tabData = UICreateUtils.tabDataHeroLeft;
			data.loadMyHeroes = false;

			_heroTabList = new HeroTabList(data);

			_heroTabList.x = 5;
			_heroTabList.y = 0;
			addChild(_heroTabList);
		}

		override protected function updateEqCells() : void
		{
			var cell : EqCell;
			for (var i : int = START_ID;i < (END_ID + 1);i++)
			{
				cell = _eqDic[i];
				if (cell)
				{
					var eq : Equipment = _selectedHero.getEquipment(i);
					cell.source = eq;
				}
			}
		}

		override protected function addEvents() : void
		{
			_heroTabList.selectionModel.addEventListener(Event.CHANGE, heroTab_SelectHandler);
			_heroClickMask.addEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_heroClickMask.addEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_sutraIcon.addEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_sutraIcon.addEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_soulIcon.addEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_soulIcon.addEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_heroClickMask.addEventListener(MouseEvent.CLICK, mask_clickHandler);
			ToolTipManager.instance.registerToolTip(_soulIcon, SoulPowerTip, provideSelectedHero);
			ToolTipManager.instance.registerToolTip(_heroClickMask, HeroPropPanelTip, provideSelectedHero);
			ToolTipManager.instance.registerToolTip(_sutraIcon, SutraTip, provideSelectSutra, true);

			for each (var eqCell:EqCell in _eqDic)
			{
				eqCell.addEventListener(MouseEvent.CLICK, disableEqCell, false, 1000);
			}
		}

		private function disableEqCell(event : MouseEvent) : void
		{
			event.stopImmediatePropagation();
		}

		override protected function removeEvents() : void
		{
			_heroTabList.selectionModel.removeEventListener(Event.CHANGE, heroTab_SelectHandler);
			_heroClickMask.removeEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_heroClickMask.removeEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_heroClickMask.removeEventListener(MouseEvent.CLICK, mask_clickHandler);
			_sutraIcon.removeEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_sutraIcon.removeEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_soulIcon.removeEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_soulIcon.removeEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			ToolTipManager.instance.destroyToolTip(_soulIcon);
			ToolTipManager.instance.destroyToolTip(_heroClickMask);
			ToolTipManager.instance.destroyToolTip(_sutraIcon);

			for each (var eqCell:EqCell in _eqDic)
			{
				eqCell.removeEventListener(MouseEvent.CLICK, disableEqCell, false);
			}
		}
		
		override public function initModule():void
		{
			super.initModule();
			
			_initiated = true;
		}
		
		override protected function onShow():void
		{
			super.onShow();
			
			if (_cachedHeroes)
			{
				source = _cachedHeroes;
				_cachedHeroes = null;
			}
		}
	}
}
