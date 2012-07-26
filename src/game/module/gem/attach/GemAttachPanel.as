package game.module.gem.attach
{
	import com.commUI.HeroColorTab;
	import game.core.hero.VoHero;
	import game.core.item.sutra.Sutra;
	import game.definition.UI;
	import game.module.gem.GemChildPanel;
	import game.net.core.Common;
	import game.net.data.StoC.SCGemChange;

	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.herotab.HeroTabList;
	import com.commUI.herotab.HeroTabListData;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;





	/**
	 * @author jian
	 */
	public class GemAttachPanel extends GemChildPanel {
		// ===========================================================
		// @属性
		// ===========================================================
		private var _heroListPanel : HeroTabList;
//		private var _sutraName : TextField;
//		private var _sutraImage : GImage;
		private var _slotGrid : GemSutraPanel;
		private var _selectedHero : VoHero;

		// ==========================================================
		// @创建
		// ==========================================================
		/*
		 * 创建面板
		 */
		override protected function create() : void {
			_itemGridClass = GemGrid;
			_itemGridCellClass = GemGridCell;

			super.create();
			addHeroeList();
//			addSutra();
			addPackText();
			addSlotGrid();
		}

		/*
		 * 添加将领列表
		 */
		private function addHeroeList() : void {
			var frameBg:Sprite = UIManager.getUI(new AssetData(UI.AREA_BACKGROUND));
			frameBg.x = 8;
			frameBg.y = 34;
			frameBg.width = 150;
			frameBg.height = 224;
			addChild(frameBg);

			var data : HeroTabListData = new HeroTabListData();
			data.tabClass = HeroColorTab;
			data.tabData = UICreateUtils.tabDataHeroBox;
			data.rows = 4;
			data.cols = 2;

			_heroListPanel = new HeroTabList(data);
			_heroListPanel.x = 15;
			_heroListPanel.y = 41;
			addChild(_heroListPanel);
		}

//		/*
//		 * 添加法宝
//		 */
//		private function addSutra() : void {
//			_sutraName = UICreateUtils.createTextField(null, null, 0, 0, 86, 10, TextFormatUtils.panelSubTitle);
//			addChild(_sutraName);
//
//			_sutraImage = UICreateUtils.createGImage(null, 0, 0, 86, 30);
//			ToolTipManager.instance.registerToolTip(_sutraImage, SutraTip, sutraTipDataProvider);
//
//			addChild(_sutraImage);
//		}

		private function addSlotGrid() : void {
//			addChild(UICreateUtils.createTextField("灵珠槽", null, 160, 0, 86, 200, TextFormatUtils.panelSubTitle));
		
			var data:GComponentData = new GComponentData();
			data.x = 163;
			data.y = 34;
			data.width = 250;
			data.height = 312;
			
			_slotGrid = new GemSutraPanel(data);
			addChild(_slotGrid);
		}

		/*
		 * 添加包裹文字
		 */
		private function addPackText() : void {
			addChild(UICreateUtils.createTextField("灵珠列表", null, 0, 0, 355, 14, TextFormatUtils.panelSubTitle));
			addChild(UICreateUtils.createTextField("←拖动灵珠至灵珠槽身上", null, 300, 0, 355, 28, TextFormatUtils.panelContent));
		}

		// ==============================================================
		// @更新
		// ==============================================================
		/*
		 * 更新面板
		 */
		private function updateView() : void {
			updateSutra();
//			updateSlots();
			updatePack();
		}

		/*
		 * 更新法宝
		 */
		private function updateSutra() : void {
			if (_selectedHero) {
//				var sutra : Sutra = _selectedHero.sutra;
//				_sutraName.htmlText = StringUtils.addColorById(sutra.name + " " + sutra.stepString, sutra.color);
//				_sutraImage.url = sutra.imgLargeUrl;
//				// _sutraImage.toolTip.source = sutra;
				_slotGrid.sutra = _selectedHero.sutra;
			}
		}

		/*
		 * 更新灵珠槽
		 */
//		private function updateSlots() : void {
//			if (_selectedHero) {
//				var level : uint = _selectedHero.level;
//				var slotNums : uint = (level < 70) ? 0 : ((level - 70) / 5 + 2);
//				var lock : Boolean = level >= 70 && ((level + 1) % 5 == 0);
//				var unlockLevel : uint = level - (level % 5) + 5;
//				_slotGrid.setSlotNum(slotNums, lock, unlockLevel);
//				_slotGrid.slots = _selectedHero.gemSlots;
//			}
//		}

		// ==============================================================
		// @交互
		// ==============================================================
		/*
		 * 选择默认将领
		 */
		private function selectDefaultHero() : void {
			// _heroListPanel.selectHero(UserData.instance.myHero.id);
			// _selectedHero = UserData.instance.myHero;
			updateSutra();
		}

		/*
		 * 进入面板
		 */
		override protected function onShow() : void {
			super.onShow();
			updateView();
			selectDefaultHero();
			_heroListPanel.selectionModel.addEventListener(Event.CHANGE, selectHeroHandler);
			Common.game_server.addCallback(0x205, gemChangeHandler);
		}

		/*
		 * 退出面板
		 */
		override protected function onHide() : void {
			Common.game_server.removeCallback(0x205, gemChangeHandler);
			_heroListPanel.selectionModel.addEventListener(Event.CHANGE, selectHeroHandler);
			super.onHide();
		}

		/*
		 * 响应英雄选择
		 */
		private function selectHeroHandler(event : Event) : void {
			_selectedHero = _heroListPanel.selection;
			updateSutra();
		}


		/*
		 * 装上卸下灵珠
		 */
		private function gemChangeHandler(msg : SCGemChange) : void {
			updateSutra();
//			updateSlots();
		}

		public function sutraTipDataProvider() : Sutra {
			if (_selectedHero)
				return _selectedHero.sutra;
			return null;
		}
	}
}
