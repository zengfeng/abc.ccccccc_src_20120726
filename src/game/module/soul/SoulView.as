package game.module.soul {
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.hero.VoHero;
	import game.core.item.IndexListModel;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.ItemService;
	import game.core.item.soul.Soul;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.SignalBusManager;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.quest.guide.GuideMange;
	import game.module.soul.pack.SoulGrid;
	import game.module.soul.pack.SoulGridCell;
	import game.module.soul.soulBD.SoulFlameManager;
	import game.net.core.Common;
	import game.net.data.CtoC.CCHeroEqChange;
	import game.net.data.CtoC.CCPackChange;
	import game.net.data.StoC.SCMergeSoulAllFinish;
	import gameui.cell.LabelSource;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GCheckBox;
	import gameui.controls.GComboBox;
	import gameui.controls.GImage;
	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GImageData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.drag.DragManage;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import log4a.Logger;
	import model.SelectionModel;
	import net.AssetData;
	import net.LibData;
	import com.commUI.GCommonWindow;
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.herotab.HeroTabList;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.commUI.tooltip.SoulPowerTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.ColorUtils;
	import com.utils.ItemUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;











	/**
	 * @author jian
	 */
	public class SoulView extends GCommonWindow  implements IModuleInferfaces, IAssets
	{
		// =====================
		// Attributes
		// =====================
		private var _gridModel : IndexListModel;

		private var _subPanel : GPanel;

		private var _heroListPanel : HeroTabList;

		private var _heroInfoText : TextField;

		private var _soulPowerText : TextField;

		private var _soulPowerIcon : Sprite;

		private var _soulWheel : SoulWheel;

		private var _heroImage : GImage;

		private var _bossArenaButton : GButton;

		private var _autoMergeButton : GButton;

		private var _selectedHero : VoHero;

		private var _soulGrid : SoulGrid;

		// private var _emptyText:TextField;
		private var _comboBox : GComboBox;

		private var _checkBox : GCheckBox;

		private var _comboColors : Array = [ColorUtils.GREEN, ColorUtils.BLUE, ColorUtils.VIOLET, ColorUtils.ORANGE];

		private var _filterColor : int = -1;

		// =====================
		// Methods
		// =====================
		public function SoulView()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 740;
			data.height = 420;
			data.parent = ViewManager.instance.uiContainer;
			data.panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			data.allowDrag = true;
			super(data);
		}

		// ------------------------------------------------
		// Methods - Create View
		// ------------------------------------------------
		override protected function create() : void
		{
			
			super.create();

			title = "元神";
		}

		private function addGridModel() : void
		{
			_gridModel = ItemManager.instance.soulModel;
		}

		private function addSubPanel() : void
		{
			var data : GPanelData = new GPanelData();
			data.align = new GAlign(77, 10, 0, 5);
			data.bgAsset = new AssetData(UI.PANEL_BACKGROUND);

			_subPanel = new GPanel(data);
			_contentPanel.addChild(_subPanel);
		}

		private function addHeroListPanel() : void
		{
			_heroListPanel = new HeroTabList(UICreateUtils.heroListDataLeft);
			_heroListPanel.x = 6;
			_heroListPanel.y = 0;
			_contentPanel.addChild(_heroListPanel);
		}

		private function addSoulPower() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.SOUL_POWER_BACKGROUND));
			bg.x = 14;
			bg.y = 9;
			_subPanel.addChild(bg);

			_heroInfoText = new TextField();
			_heroInfoText.defaultTextFormat = TextFormatUtils.panelSubTitle;
			_heroInfoText.x = 94;
			_heroInfoText.y = 24;
			_heroInfoText.width = 136;
			// TODO: 先注掉
			_heroInfoText.visible = false;
			_subPanel.addChild(_heroInfoText);

			_soulPowerIcon = UIManager.getUI(new AssetData(UI.SOUL_POWER_ICON));
			_soulPowerIcon.mouseEnabled = true;
			_soulPowerIcon.x = 11;
			_soulPowerIcon.y = 0;
			_subPanel.addChild(_soulPowerIcon);

			_soulPowerText = UICreateUtils.createTextField(null, null, 120, 20, 55, 20, TextFormatUtils.panelContent);
			// _soulPowerText.x = 55;
			// _soulPowerText.y = 20;
			// _soulPowerText.defaultTextFormat = TextFormatUtils.panelContent;
			_soulPowerText.textColor = ColorUtils.TEXTCOLOROX[ColorUtils.GOLDEN];
			_subPanel.addChild(_soulPowerText);
		}

		private function addSoulWheel() : void
		{
			_soulWheel = new SoulWheel();
			_soulWheel.x = 8;
			_soulWheel.y = 59;

			_subPanel.addChild(_soulWheel);
		}

		private function addHeroImage() : void
		{
			var imageData : GImageData = new GImageData();
			imageData.x = 24;
			imageData.y = -19;
			imageData.iocData.align = new GAlign(0, -1, -1, 0);

			_heroImage = new GImage(imageData);
			_heroImage.mouseEnabled = false;
			_heroImage.mouseChildren = false;
			_soulWheel.addChildAt(_heroImage, 2);
			// _subPanel.addChild(_heroImage);
		}

		private function addPackText() : void
		{
			_subPanel.addChild(UICreateUtils.createTextField("←拖动至元神位可装备，拖离可拆卸", null, 240, 20, 354, 2, TextFormatUtils.panelContent));
		}

		private function addCommboBox() : void
		{
			var labels : Array = [new LabelSource("全部")];

			for each (var color:uint in _comboColors)
			{
				labels.push(new LabelSource(ColorUtils.TEXTNAME[color]));
			}

			_comboBox = UICreateUtils.createGComboBox(labels, 80, 80, 100, 629, 29);
			_subPanel.addChild(_comboBox);
		}

		private function addCheckBox() : void
		{
			_checkBox = UICreateUtils.createGCheckBox("隐藏可交易", 0, 0, 549, 18);

			_subPanel.addChild(_checkBox);
		}

		private function addPack() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 360;
			gridData.y = 40;
			gridData.allowDrag = false;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 6;
			gridData.columns = 5;
			gridData.hgap = 6;
			gridData.vgap = 6;
			gridData.padding = 6;
			gridData.cell = SoulGridCell;
			gridData.verticalScrollPolicy = GPanelData.ON;
			// gridData.showEmptyText = "没有符合条件的元神";

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 48;
			cellData.height = 48;
			cellData.allowSelect = true;
			cellData.fakeRollOut = true;
			cellData.iconData.showToolTip = true;
			cellData.iconData.showBg = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showBinding = true;
			cellData.iconData.showNums = true;
			cellData.iconData.showLevel = true;
			cellData.iconData.showPair = true;
			cellData.iconData.showRollOver = true;
			cellData.iconData.showName = true;

			gridData.cellData = cellData;

			_soulGrid = new SoulGrid(gridData);


			_subPanel.addChild(_soulGrid);
		}

		private function addBossArenaButton() : void
		{
			var data : GButtonData = new KTButtonData();
			data.x = 133;
			data.y = 378;

			_bossArenaButton = new GButton(data);
			_bossArenaButton.text = "前往深渊";
			_subPanel.addChild(_bossArenaButton);
		}

		private function addAutoMergeButton() : void
		{
			var data : GButtonData = new KTButtonData();
			data.x = 459;
			data.y = 378;

			_autoMergeButton = new GButton(data);
			_autoMergeButton.text = "一键合成";
			_subPanel.addChild(_autoMergeButton);
		}

		// ------------------------------------------------
		// Methods - Update View
		// ------------------------------------------------
		// 更新面板
		private function updateView() : void
		{
			updateHeroInfo();
			updateHeroImage();
			updateSoulWheel();
			updateSoulGrid();
		}

		private function updateHeroInfo() : void
		{
			if (_selectedHero)
			{
				_heroInfoText.text = _selectedHero._name + " " + _selectedHero.level + "级";
				_soulPowerText.text = "元神力：" + SoulUtils.calHeroSoulPower(_selectedHero).toString();
			}
		}

		// TODO
		private function updateHeroImage() : void
		{
			if (_selectedHero)
			{
				_heroImage.url = _selectedHero.fullImage;
			}
		}

		private function updateSoulWheel() : void
		{
			if (_selectedHero)
			{
				_soulWheel.slots = _selectedHero.soulSlots;
				_soulWheel.slotNum = SoulUtils.getSoulSlotNumByHeroLevel(_selectedHero.level);
			}
		}

		private function updateSoulGrid() : void
		{
			_soulGrid.source = _gridModel.source;
			// _emptyText.visible = (_checkBox.selected && _gridModel.itemNums == 0);
		}

		// private function selectDefaultHero() : void
		// {
		// //  if (!_selectedHero)
		// //  _heroListPanel.selectHero(UserData.instance.myHero.id);
		// //  _selectedHero = UserData.instance.myHero;
		// }
		private function reloadSouls() : void
		{
			if (_checkBox.selected)
				_gridModel.source = ItemManager.instance.packModel.getPageItems(Item.SOUL).filter(soulFilterUnBindingFunc);
			else
				_gridModel.source = ItemManager.instance.packModel.getPageItems(Item.SOUL);
		}

		// ------------------------------------------------
		// Methods - Event Binding/Handling
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			// selectDefaultHero();
			reloadSouls();
			updateView();
			addEvents();
			
			if (!_gridModel.source || !(_gridModel.source[0] is Soul))
			{
				GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL, 4);
				GuideMange.getInstance().hide();
			}
		}

		override protected function onHide() : void
		{
			removeEvents();
			super.onHide();
		}

		// 添加事件
		private function addEvents() : void
		{
			//trace("onShow");
			Common.game_server.addCallback(0xFFF2, packChangeHandler);
			Common.game_server.addCallback(0x291, onMergeAllSoul);
			_heroListPanel.selectionModel.addEventListener(Event.CHANGE, heroSelectHandler);
			_bossArenaButton.addEventListener(MouseEvent.CLICK, clickBossArenaHandler);
			_autoMergeButton.addEventListener(MouseEvent.CLICK, mergeAllSoulHandler);
			_checkBox.addEventListener(Event.CHANGE, checkBox_changeHandler);
			Common.game_server.addCallback(0xFFF1, heroLevelUpCallback);
			ToolTipManager.instance.registerToolTip(_soulPowerIcon, SoulPowerTip, provideSelectedHero);
			SignalBusManager.soulPanelSelectHero.add(onExternalSelectHero);
			// _comboBox.selectionModel.addEventListener(Event.CHANGE, colorSelectHandler);
		}

		// 移除事件
		private function removeEvents() : void
		{
			Common.game_server.removeCallback(0xFFF2, packChangeHandler);
			Common.game_server.removeCallback(0x291, onMergeAllSoul);
			_heroListPanel.selectionModel.removeEventListener(Event.CHANGE, heroSelectHandler);
			_bossArenaButton.removeEventListener(MouseEvent.CLICK, clickBossArenaHandler);
			_autoMergeButton.removeEventListener(MouseEvent.CLICK, mergeAllSoulHandler);
			_checkBox.removeEventListener(Event.CHANGE, checkBox_changeHandler);
			Common.game_server.removeCallback(0xFFF1, heroLevelUpCallback);
			ToolTipManager.instance.destroyToolTip(_soulPowerIcon);
			SignalBusManager.soulPanelSelectHero.remove(onExternalSelectHero);
			// _comboBox.selectionModel.removeEventListener(Event.CHANGE, colorSelectHandler);
		}

		private function onMergeAllSoul(msg : SCMergeSoulAllFinish) : void
		{
			reloadSouls();
			updateSoulGrid();
		}

		private function onExternalSelectHero(heroId : uint) : void
		{
			_heroListPanel.selectHero(heroId);
		}

		private function heroLevelUpCallback(...arg) : void
		{
			updateView();
		}

		private function checkBox_changeHandler(event : Event) : void
		{
			reloadSouls();
			updateSoulGrid();
		}

		// 包裹变化
		private function packChangeHandler(msg : CCPackChange) : void
		{
			if (msg.topType | Item.SOUL)
			{
				updateSoulGrid();
				updateSoulWheel();
				updateHeroInfo();

				if (SoulDragManager.state == SoulDragManager.WAITING_REPLY)
				{
					SoulDragManager.state = SoulDragManager.IDLE;
					DragManage.getInstance().finishDrag(true);
				}
			}
		}

		// 将领元神变化: TODO
		private function heroChangeHandler(msg : CCHeroEqChange) : void
		{
			if (true)
			{
				updateSoulWheel();
			}
		}

		// 选择英雄
		private function heroSelectHandler(event : Event) : void
		{
			_selectedHero = _heroListPanel.selection;
			updateHeroInfo();
			updateHeroImage();
			updateSoulWheel();
		}

		// 筛选颜色
		private function colorSelectHandler(event : Event) : void
		{
			var selectionModel : SelectionModel = SelectionModel(event.currentTarget);

			if (selectionModel.isSelected)
			{
				_filterColor = selectionModel.index - 1;
			}

			_gridModel.source = ItemManager.instance.getPackSouls().filter(soulFilterColorFunc).sort(ItemUtils.sortSoulFunc);
			updateSoulGrid();
		}

		// 前往星宿台
		private function clickBossArenaHandler(event : MouseEvent) : void
		{
			GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL, 4);
			MenuManager.getInstance().closeMenuView(MenuType.SOUL);
			MenuManager.getInstance().openMenuView(MenuType.SOUL_ABYSS);
		}

		// 一键合成
		private function mergeAllSoulHandler(event : MouseEvent) : void
		{
			if (_gridModel.itemNums == 0)
				StateManager.instance.checkMsg(233);
			else
				StateManager.instance.checkMsg(117, null, mergeAllConfirmHandler);
		}

		private function mergeAllConfirmHandler(type : String) : Boolean
		{
			if (type == Alert.YES_EVENT || type == Alert.OK_EVENT)
				ItemService.instance.sendMergeAllSoulMessage(_checkBox.selected);

			return true;
		}

		// ------------------------------------------------
		// Others
		// ------------------------------------------------
		// 布局
		override protected function layout() : void
		{
			super.layout();

			GLayout.layout(_subPanel);
		}

		// 元神筛选
		private function soulFilterColorFunc(soul : Soul, index : int, arr : Array/* of Item */) : Boolean
		{
			if (!soul)
				return true;
			return (_filterColor < 0 || soul.color == _comboColors[_filterColor]);
		}

		private function soulFilterUnBindingFunc(soul : Soul, index : int, arr : Array/* of Item */) : Boolean
		{
			if (!soul)
				return true;
			return soul.binding;
		}

		private function provideSelectedHero() : VoHero
		{
			return _selectedHero;
		}

		// ------------------------------------------------
		// 模块
		// ------------------------------------------------
		public function getResList() : Array
		{
			var res:Array = [];
			res.push(new LibData(VersionManager.instance.getUrl("assets/swf/soul_flame.swf"), "soul_flame"));
			res.push(new LibData(VersionManager.instance.getUrl("assets/swf/soul.swf"), "soul"));
			
			for each (var hero:VoHero in UserData.instance.heroes)
			{
				res.push (hero.heroImage);
				res.push (hero.fullImage);
			}
			return res;
		}

		public function initModule() : void
		{
			Logger.debug("元神加载完成");
			SoulFlameManager.instance.initiate();
			addGridModel();
			addSubPanel();
			addHeroListPanel();
			addSoulPower();
			addSoulWheel();
			addHeroImage();
			addPackText();
			// addCommboBox();
			addCheckBox();
			addPack();
			addBossArenaButton();
			addAutoMergeButton();
			layout();
		}
	}
}
