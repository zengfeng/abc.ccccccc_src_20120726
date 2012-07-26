package game.module.enhance
{
	import game.module.daily.DailyManage;
	import game.core.menu.MenuManager;
	import game.core.user.VIPUtils;
	import game.core.user.UserData;
	import game.module.quest.QuestUtil;
	import flash.display.DisplayObject;
	import game.core.user.StateManager;
	import game.core.menu.MenuType;
	import game.module.quest.guide.GuideMange;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.equipment.Equipment;
	import game.core.item.pile.PileItem;
	import game.definition.ID;
	import game.definition.UI;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;

	import gameui.controls.BDPlayer;
	import gameui.controls.GButton;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.BDSWFLoader;
	import net.LibData;
	import net.RESManager;

	import com.commUI.GCommonWindow;
	import com.commUI.button.KTButtonData;
	import com.commUI.icon.ItemIcon;
	import com.commUI.itemgrid.ItemCellEvent;
	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.utils.ItemUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author verycd
	 */
	public class EnhanceView extends GCommonWindow implements IModuleInferfaces, IAssets
	{
		// =====================
		// 属性
		// =====================
		private var _itemIcon : ItemIcon;
		private var _itemName : TextField;
		private var _heroTabList : EnhanceHeroList;
		private var _enhanceButton : GButton;
		private var _miningButton : GButton;
		private var _model : EnhanceModel;
		private var _manager : EnhanceManager;
		// private var _noItemText : TextField;
		private var _hitLimitText : TextField;
		private var _levelName : TextField;
		private var _levelText : TextField;
		private var _enhanceProp : TextField;
		private var _enhanceValue : TextField;
		private var _silverIcon : ItemIcon;
		private var _silverText : TextField;
		private var _enhanceStone : ItemIcon;
		private var _enhanceStoneText : TextField;
		private var _cachedItems : Array;
		private var _itemGrid : ItemGrid;
		private var _subPanel : Sprite;
		private var _effectPlayer : BDPlayer;
		private var _selectedHeroId : int = -1;

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function EnhanceView()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.parent = ViewManager.instance.uiContainer;
			data.width = 612;
			data.height = 356;
			super(data);

			_model = new EnhanceModel();
			_manager = EnhanceManager.instance;
			_manager.model = _model;
			_manager.panel = this;
		}

		private function addEffectPlayer() : void
		{
			title = "强化";
			
			var data : GComponentData = new GComponentData();
			data.parent = _subPanel;
			data.x = 164;
			data.y = 102;
			_effectPlayer = new BDPlayer(data);
			_effectPlayer.setBDData(RESManager.getBDData(new AssetData("1", "enhanceLight")));
		}

		private function addSubPanel() : void
		{
			_subPanel = new Sprite();
			_subPanel.x = 5;
			_subPanel.y = 0;
			contentPanel.addChild(_subPanel);

			var bg : Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			bg.width = 525;
			bg.height = 351;
			_subPanel.addChild(bg);
		}

		private function addCircle() : void
		{
			var bitmapData : BitmapData = RESManager.getBitmapData(new AssetData(UI.ENHANCE_CIRCLE_BACKGROUND, "enhance"));
			var circle : Bitmap = new Bitmap(bitmapData);
			circle.x = 86;
			circle.y = 30;
			_subPanel.addChild(circle);
		}

		/*
		 * 添加接受强化物品
		 */
		private function addItem() : void
		{
			// 物品图标
			_itemIcon = UICreateUtils.createItemIcon({x:142, y:85, showBorder:false, showBg:false, showToolTip:true, showLevel:true, showBinding:true, showRollOver:true, sendChat:true});
			_subPanel.addChild(_itemIcon);

			// 物品名称
			_itemName = UICreateUtils.createTextField(null, null, 120, 30, 105, 8, TextFormatUtils.panelSubTitleCenter);
			_subPanel.addChild(_itemName);
		}

		// private function addNoItemText() : void
		// {
		// _noItemText = UICreateUtils.createTextField("请放入装备", null, 150, 20, 100, 133, TextFormatUtils.panelSubTitleCenter);
		// _noItemText.visible = false;
		// _subPanel.addChild(_noItemText);
		// }
		/*
		 * 强化等级
		 */
		private function addLevel() : void
		{
			// 强化等级
			_levelName = UICreateUtils.createTextField(null, "强化等级：", 80, 20, 82, 187, TextFormatUtils.panelContentRight);
			_subPanel.addChild(_levelName);

			_levelText = UICreateUtils.createTextField(null, null, 140, 20, 162, 187, TextFormatUtils.panelContent);
			_subPanel.addChild(_levelText);
		}

		/*
		 * 增强效果
		 */
		private function addIncrValue() : void
		{
			_enhanceProp = UICreateUtils.createTextField(null, "强化效果：", 80, 20, 82, 204, TextFormatUtils.panelContentRight);
			_subPanel.addChild(_enhanceProp);

			_enhanceValue = UICreateUtils.createTextField(null, null, 140, 20, 162, 204, TextFormatUtils.panelContent);
			_subPanel.addChild(_enhanceValue);
		}

		/*
		 * 强化消耗
		 */
		private function addCost() : void
		{
			var costText : TextField = UICreateUtils.createTextField("所需材料", null, 80, 20, 14, 209, TextFormatUtils.panelContent);
			_subPanel.addChild(costText);

			var frame : Sprite = UIManager.getUI(new AssetData(UI.FORGE_FRAME_BACKGROUND));
			frame.width = 313;
			frame.height = 78;
			frame.x = 12;
			frame.y = 229;
			_subPanel.addChild(frame);

			addCostSilver();
			addCostStone();
		}

		/*
		 * 消耗银币
		 */
		private function addCostSilver() : void
		{
			var silver : Item = ItemManager.instance.newItem(ID.SILVER);
			_silverIcon = UICreateUtils.createItemIcon({x:76, y:237, showBorder:true, showBg:true, showShopping:true, showRollOver:true, showToolTip:true});
			_silverIcon.source = silver;
			_subPanel.addChild(_silverIcon);

			// var icon : Sprite = UIManager.getUI(new AssetData(UI.MONEY_ICON_SILVER));
			// icon.x = 36;
			// icon.y = 290;
			// _subPanel.addChild(icon);

			_silverText = UICreateUtils.createTextField(null, null, 120, 20, 41, 284, TextFormatUtils.panelContentCenter);
			_subPanel.addChild(_silverText);
		}

		/*
		 * 消耗仙石
		 */
		private function addCostStone() : void
		{
			_enhanceStone = UICreateUtils.createItemIcon({x:205, y:237, showBorder:true, showBg:true, showNums:true, showToolTip:true, showRollOver:true});
			_enhanceStone.background = UIManager.getUI(new AssetData(UI.ROUND_ICON_BACKGROUND_WHITE));
			_subPanel.addChild(_enhanceStone);

			_enhanceStoneText = UICreateUtils.createTextField(null, null, 120, 20, 170, 284, TextFormatUtils.panelContentCenter);
			_subPanel.addChild(_enhanceStoneText);
		}

		/*
		 * 添加按钮
		 */
		private function addButton() : void
		{
			// 强化按钮
			var enhanceButtonData : GButtonData = new KTButtonData();
			enhanceButtonData.labelData.text = "强化";
			enhanceButtonData.x = 124;
			enhanceButtonData.y = 314;
			_enhanceButton = new GButton(enhanceButtonData);
			_subPanel.addChild(_enhanceButton);
			
			// 前往采矿按钮
			var miningButtonData:GButtonData = new KTButtonData();
			miningButtonData.labelData.text = "获得仙石";
			miningButtonData.x = 390;
			miningButtonData.y = 314;
			_miningButton = new GButton(miningButtonData);
			_subPanel.addChild(_miningButton);
		}

		private function addHitLimitText() : void
		{
			_hitLimitText = new TextField();

			var textFormat : TextFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.color = 0x279F15;
			textFormat.size = 14;
			textFormat.leading = 3;
			textFormat.kerning = true;
			textFormat.bold = true;
			_hitLimitText.defaultTextFormat = textFormat;
			_hitLimitText.text = "已强化至上限";
			_hitLimitText.width = 170;
			_hitLimitText.height = 24;
			_hitLimitText.x = 120;
			_hitLimitText.y = 312;
			_hitLimitText.mouseEnabled = false;

			_hitLimitText.visible = false;
			_subPanel.addChild(_hitLimitText);
		}

		private function addPackTitle() : void
		{
			_subPanel.addChild(UICreateUtils.createTextField("可强化装备", null, 160, 20, 336, 4, TextFormatUtils.panelSubTitle));
		}

		/*
		 * 添加物品格
		 */
		private function addItemGrid() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 336;
			gridData.y = 33;
			gridData.allowDrag = false;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 5;
			gridData.columns = 3;
			gridData.hgap = 6;
			gridData.vgap = 5;
			gridData.padding = 6;
			gridData.cell = ItemGridCell;
			// gridData.showEmptyText = "没有符合条件的装备";

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 48;
			cellData.height = 48;
			cellData.iconData.showToolTip = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showLevel = true;
			cellData.iconData.showBinding = true;
			cellData.iconData.sendChat = true;
			cellData.iconData.showRollOver = true;
			cellData.iconData.showBg = true;

			gridData.cellData = cellData;
			gridData.scrollBarData.visible = true;
			gridData.scrollBarData.movePre = 1;
			gridData.scrollBarData.wheelSpeed = 1;
			gridData.verticalScrollPolicy = GPanelData.ON;

			_itemGrid = new ItemGrid(gridData);
			_subPanel.addChild(_itemGrid);
		}

		/*
		 * 添加将领列表
		 */
		private function addHeroTab() : void
		{
			// 将领名称列表
			_heroTabList = new EnhanceHeroList();
			_heroTabList.x = 526;
			_heroTabList.y = 0;
			_heroTabList.width = 70;
			_subPanel.addChild(_heroTabList);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		public function showEffect() : void
		{
			_effectPlayer.addEventListener(Event.COMPLETE, effectCompleteHandler);
			_effectPlayer.show();
			_effectPlayer.play(33, null, 1, 0);
		}

		private function effectCompleteHandler(event : Event) : void
		{
			_effectPlayer.removeEventListener(Event.COMPLETE, effectCompleteHandler);
			_effectPlayer.hide();
		}

		public function updateView() : void
		{
			updateItem();
			updateLevel();
			updateIncrValue();
			updateButton();
			// updateNoItemText();
			updateHitLimitText();
			updateCostSilver();
			updateCostStone();
		}

		private function updateItem() : void
		{
			if (_model.item)
			{
				_itemName.htmlText = _model.item.htmlName;
				_itemIcon.source = _model.item;
			}
			else
			{
				_itemName.text = "请放入装备";
				_itemIcon.source = null;
			}
			_itemGrid.selectItem(_model.item);
		}

		private function updateLevel() : void
		{
			var eq : Equipment = _model.item;

			var text : String = "";

			if (eq)
			{
				text += EnhanceUtils.getEnhanceLevelHtmlText2(eq.enhanceLevel);
				text += " → ";
				text += EnhanceUtils.getEnhanceLevelHtmlText2(_model.targetLevel);
				_levelName.visible = true;
			}
			else
			{
				_levelName.visible = false;
				text = "";
			}

			_levelText.htmlText = text;
		}

		private function updateIncrValue() : void
		{
			var item : Item = _model.item;

			if (item)
			{
				_enhanceProp.text = _model.item.enhancePropName + "： ";

				var text : String = "";
				text = StringUtils.addColorById(_model.item.enhanceValue.toString(), EnhanceUtils.getColorIdByEnhanceLevel(_model.item.enhanceLevel));
				text += " → ";
				text += StringUtils.addColorById(ItemUtils.getEnhancePropValue(_model.item.type, _model.targetLevel).toString(), EnhanceUtils.getColorIdByEnhanceLevel(_model.targetLevel));
				_enhanceValue.htmlText = text;
			}
			else
			{
				_enhanceProp.text = "";
				_enhanceValue.text = "";
			}
		}

		private function updateCostSilver() : void
		{
			_silverText.text = (_model.costSilver == 0) ? "消耗银币" : _model.costSilver.toString();
			// _silverIcon.enabled = (_model.item != null);
		}

		private function updateCostStone() : void
		{
			if (_model.costStoneID)
			{
				var item : PileItem = ItemManager.instance.getPileItem(_model.costStoneID);
				_enhanceStone.minNums = _model.costStone;
				_enhanceStone.showNums = true;
				_enhanceStone.source = item;
				_enhanceStoneText.htmlText = StringUtils.addColorById(item.name + "×" + _model.costStone, item.color);
			}
			else
			{
				_enhanceStone.showNums = false;
				_enhanceStone.source = ItemManager.instance.getPileItem(ID.ENHANCE_STONE_0);
				_enhanceStoneText.htmlText = "消耗仙石";
			}

			// _enhanceStone.enabled = (_model.item != null);
		}

		private function updateButton() : void
		{
			if (!_model.hitLimit)
			{
				_enhanceButton.visible = true;
			}
			else
			{
				_enhanceButton.visible = false;
			}
		}

		// private function updateNoItemText() : void
		// {
		// _noItemText.visible = (_model.item == null);
		// }
		private function updateHitLimitText() : void
		{
			_hitLimitText.visible = _model.hitLimit;
		}

		private function updateItemGrid() : void
		{
			var heroId : uint = _heroTabList.heroId;

			_itemGrid.showOwner = (heroId == 0) ? true : false;
			_itemGrid.source = _cachedItems;//.filter(filterItemFunc);
		}

		private function reloadHeroItems() : void
		{
			_cachedItems = EnhanceUtils.getHeroEquipmetns(_heroTabList, false).sort(ItemUtils.sortEquipmentFunc);
		}

		private function selectDefaultHero() : void
		{
			if (_selectedHeroId != -1)
			_heroTabList.selectHero(_selectedHeroId);
			else
				_heroTabList.selectionModel.index = 0;
			
//			if (_heroTabList.selectionModel.index == 0)
//			{
//				reloadHeroItems();
//				selectDefaultItem();
//				updateView();
//				updateItemGrid();
//			}
//			_heroTabList.selectionModel.index = 0;
		}

		private function selectDefaultItem() : void
		{
			var match:Boolean = false;
			if (_model.item)
			{
				for each (var eq:Equipment in _cachedItems)
				{
					if (_model.item.uuid == eq.uuid)
					{
						_model.item = eq;
						match = true;
						break;
					}
				}
			}
			
			if (!match)
				_model.item = null;
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		// 进入面板
		override protected function onShow() : void
		{
			addEvents();
			super.onShow();
			selectDefaultHero();
			reloadHeroItems();
			selectDefaultItem();
			updateItemGrid();
			updateView();
			GuideMange.getInstance().checkGuideByMenuid(MenuType.ENHANCE, 1);
		}

		// 退出面板
		override protected function onHide() : void
		{
			removeEvents();
			super.onHide();
		}

		// 添加监听事件
		private function addEvents() : void
		{
			_itemGrid.addEventListener(ItemCellEvent.SELECT, selectItemHandler, true);
			_enhanceButton.addEventListener(MouseEvent.CLICK, doEnhanceHandler);
			_miningButton.addEventListener(MouseEvent.CLICK, miningButton_clickHandler);
			_heroTabList.selectionModel.addEventListener(Event.CHANGE, selectHeroHandler);
			_itemIcon.addEventListener(MouseEvent.CLICK, itemClickHandler);

			Common.game_server.addCallback(0x280, _manager.onEnhanceResult);
			Common.game_server.addCallback(0xFFF2, onPackChange);
		}



		// 移除监听事件
		private function removeEvents() : void
		{
			_itemGrid.removeEventListener(ItemCellEvent.SELECT, selectItemHandler, true);
			_enhanceButton.removeEventListener(MouseEvent.CLICK, doEnhanceHandler);
			_miningButton.removeEventListener(MouseEvent.CLICK, miningButton_clickHandler);
			// _autoButton.removeEventListener(MouseEvent.CLICK, autoEnhanceHandler);
			_heroTabList.selectionModel.removeEventListener(Event.CHANGE, selectHeroHandler);
			_itemIcon.removeEventListener(MouseEvent.CLICK, itemClickHandler);
			Common.game_server.removeCallback(0x280, _manager.onEnhanceResult);
			Common.game_server.removeCallback(0xFFF2, onPackChange);
		}

		private function onPackChange(msg : CCPackChange) : void
		{
			if (msg.topType | Item.EQ)
			{
				reloadHeroItems();
				updateItemGrid();
			}
			if (msg.topType | Item.ENHANCE)
			{
				// updateCostScroll();
				updateCostStone();
			}
		}

		private function selectHeroHandler(event : Event) : void
		{
			_selectedHeroId = _heroTabList.selection.id;
			reloadHeroItems();
			selectDefaultItem();
			updateView();
			updateItemGrid();
		}

		private function itemClickHandler(event : MouseEvent) : void
		{
			_model.item = null;
			updateView();
//			updateItemGrid();
		}

		// 选择物品事件
		private function selectItemHandler(event : Event) : void
		{
			GuideMange.getInstance().checkGuideByMenuid(MenuType.ENHANCE, 2);
			_model.item = ItemGridCell(event.target).source as Equipment;
//			updateItemGrid();
			updateView();
		}

		// 发送强化请求
		private function doEnhanceHandler(event : MouseEvent) : void
		{
			if (!_model.item)
			{
				StateManager.instance.checkMsg(102);
				return;
			}

			GuideMange.getInstance().checkGuideByMenuid(MenuType.ENHANCE, 3);
			_manager.askForShopping();
		}
		
		// 前往采矿
		private function miningButton_clickHandler(event:MouseEvent) : void
		{
			DailyManage.getInstance().getDailyVo(10).execute();
//			MenuManager.getInstance().closeMenuView(MenuType.ENHANCE);
		}

//		private function filterItemFunc(item : Item, index : int, arr : Array/* of Item */) : Boolean
//		{
//			return (item != _model.item);
//		}

		// ------------------------------------------------
		// 模块
		// ------------------------------------------------
		public function getResList() : Array
		{
			return [new LibData(VersionManager.instance.getUrl("assets/swf/enhance.swf"), "enhance"), new BDSWFLoader(new LibData(VersionManager.instance.getUrl("assets/avatar/184549377.swf"), "enhanceLight"))];
		}

		public function initModule() : void
		{
			addSubPanel();
			addCircle();
			addItem();
			// addNoItemText();
			addLevel();
			addIncrValue();
			addCost();
			addButton();
			addHitLimitText();
			addPackTitle();
			addItemGrid();
			addHeroTab();
			addEffectPlayer();
		}
	}
}
