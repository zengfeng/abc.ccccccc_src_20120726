package game.module.pack.merge
{
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.ID;
	import game.definition.UI;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.shop.staticValue.ShopStaticValue;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;

	import gameui.cell.LabelSource;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GList;
	import gameui.core.GAlign;
	import gameui.data.GListData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.skin.SkinStyle;
	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.alert.Alert;
	import com.commUI.icon.ItemIcon;
	import com.commUI.quickshop.SingleQuickShop;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author jian
	 */
	public class MergeView extends GCommonWindow
	{
		private var _manager : MergeManager;
		private var _itemManager : ItemManager;
		private var _config : MergeConfig;
		private var _subPanel : GPanel;
		private var _targetItem : Item;
		private var _materialItem : Item;
		private var _targetList : GList;
		private var _resultIcon : ItemIcon;
		private var _mergeButton : GButton;
		private var _autoButton : GButton;
		private var _resultName : TextField;
		private var _materialIcon : ItemIcon;
		private var _moneyIcon : ItemIcon;
		private var _materialName : TextField;
		private var _moneyCountText : TextField;

		// =====================
		// 属性
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function MergeView()
		{
			// 单例注入
			_manager = MergeManager.instance;
			_itemManager = ItemManager.instance;

			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 430;
			data.height = 349;
			data.parent = ViewManager.instance.uiContainer;
			data.align = new GAlign(-1, -1, -1, -1, 0, 0);

			super(data);
		}

		override protected function create() : void
		{
			super.create();

			title = "物品合成";

			addSubPanel();
			addTargetList();
			addResult();
			addMaterial();
			addButtons();
		}

		private function addSubPanel() : void
		{
			var data : GPanelData = new GPanelData();
			data.x = 5;
			data.y = 0;
			data.width = width - 15;
			data.height = height - 5;
			data.bgAsset = new AssetData(UI.PANEL_BACKGROUND);

			_subPanel = new GPanel(data);
			_contentPanel.addChild(_subPanel);
		}

		private function addButtons() : void
		{
			_mergeButton = new GButton(UICreateUtils.buttonDataNormal);
			_mergeButton.x = 186;
			_mergeButton.y = 284;
			_mergeButton.text = "合成";
			_subPanel.addChild(_mergeButton);

			_autoButton = new GButton(UICreateUtils.buttonDataNormal);
			_autoButton.x = 293;
			_autoButton.y = 284;
			_autoButton.text = "全部合成";
			_subPanel.addChild(_autoButton);
		}

		private function addTargetList() : void
		{
			var frame : FrameArea = new FrameArea("合成列表", 135, 320, TextFormatAlign.CENTER);
			frame.x = 12;
			frame.y = 12;
			_subPanel.addChild(frame);

			var data : GListData = new GListData();
			data.rows = 0;
			data.x = 0;
			data.y = 28;
			data.width = 135;
			data.height = 290;
			data.cellData.width = 133;
			data.cellData.labelData.width = 120;
			data.cellData.selected_upAsset = new AssetData(UI.TRADE_TREE_SUBNODE_SELECTBG);
			data.cellData.selected_overAsset = new AssetData(UI.TRADE_TREE_SUBNODE_SELECTBG);
			data.cellData.overAsset = new AssetData(UI.TRADE_TREE_SUBNODE_SELECTBG);
			data.bgAsset = new AssetData(SkinStyle.emptySkin);
			_targetList = new GList(data);
			frame.addChild(_targetList);
		}

		private function addResult() : void
		{
			var frame : FrameArea = new FrameArea("合成结果", 251, 145);
			frame.x = 153;
			frame.y = 12;
			_subPanel.addChild(frame);

			_resultIcon = UICreateUtils.createItemIcon({x:56, y:60, showBorder:true, showBg:true, showToolTip:true});
			frame.addChild(_resultIcon);

			_resultName = UICreateUtils.createTextField(null, null, 120, 26, 112, 75, TextFormatUtils.panelSubTitle);
			frame.addChild(_resultName);
		}

		private function addMaterial() : void
		{
			var frame : FrameArea = new FrameArea("所需材料", 251, 180);
			frame.x = 153;
			frame.y = 152;
			_subPanel.addChild(frame);

			_materialIcon = UICreateUtils.createItemIcon({x:56, y:43, showBorder:true, showBg:true, showNums:true, showToolTip:true});
			frame.addChild(_materialIcon);

			_materialName = UICreateUtils.createTextField(null, null, 100, 26, 31, 92, TextFormatUtils.panelContentCenter);
			frame.addChild(_materialName);

			_moneyIcon = UICreateUtils.createItemIcon({x:146, y:43, showBorder:true, showBg:true, showToolTip:true, showShopping:true, showRollOver:true});
			_moneyIcon.source = ItemManager.instance.getPileItem(ID.SILVER);

			frame.addChild(_moneyIcon);

			_moneyCountText = UICreateUtils.createTextField(null, null, 100, 26, 121, 92, TextFormatUtils.panelContentCenter);
			frame.addChild(_moneyCountText);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		public function selectFirstItem() : void
		{
			_targetList.selectionModel.index = 0;
		}

		public function selectTargetItem(targetId : int) : void
		{
			var i : int = 0;
			for each (var labelSource:LabelSource in _targetList.model.source)
			{
				var mergeConfig : MergeConfig = labelSource.value as MergeConfig;
				if (mergeConfig.targetId == targetId)
				{
					_targetList.selectionModel.index = i;
					return;
				}

				i++;
			}
		}

		private function updateView() : void
		{
			updateTargetList();
			updateResult();
			updateMaterial();
			updateButtons();
		}

		private function updateTargetList() : void
		{
			var labelSources : Array = [];
			var labelSource : LabelSource;
			var text : String;
			var sourceCount : int;
			var targetCount : int;
			var targetItem : Item;

			for each (var config:MergeConfig in _manager.configList)
			{
				sourceCount = _itemManager.getPileItemNums(config.sourceId);
				targetCount = Math.floor(sourceCount / config.count);
				targetItem = _itemManager.getPileItem(config.targetId);
				text = StringUtils.addColorById(targetItem.name + (targetCount == 0 ? "" : " (" + targetCount + ")"), targetItem.color);
				labelSource = new LabelSource(text, config);
				labelSources.push(labelSource);
			}

			_targetList.model.source = labelSources;
		}

		private function updateResult() : void
		{
			_resultIcon.source = _targetItem;
			_resultName.htmlText = _targetItem.htmlName;
		}

		private function updateMaterial() : void
		{
			_materialItem = ItemManager.instance.getPileItem(_config.sourceId);
			_materialIcon.source = _materialItem;
			_materialIcon.minNums = _config.count;
			
			if (ShopStaticValue.getGoodsIsPresent(_materialItem.id))
			{
				_materialIcon.showRollOver = true;
				_materialIcon.showShopping = true;
			}
			else
			{
				_materialIcon.showRollOver = false;
				_materialIcon.showShopping = false;
			}
			
			_materialName.htmlText = StringUtils.addColorById(_materialItem.name + "×" + _config.count, _materialItem.color);

			_moneyCountText.text = _config.moneyCount.toString();
		}

		private function updateButtons() : void
		{
		}

		override protected function onClickClose(event : MouseEvent) : void
		{
			MenuManager.getInstance().openMenuView(MenuType.PACK);
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();

			GLayout.layout(this);

			_mergeButton.addEventListener(MouseEvent.CLICK, mergeButton_clickHandler);
			_autoButton.addEventListener(MouseEvent.CLICK, autoButton_clickHandler);
			Common.game_server.addCallback(0xFFF2, onPackChange);
			_targetList.selectionModel.addEventListener(Event.CHANGE, targetList_selectHandler);
			SignalBusManager.mergeViewSelectSource.add(onSelectSource);

			updateTargetList();
			selectFirstItem();
		}

		private function onSelectSource(sourceId : int) : void
		{
			var config : MergeConfig = _manager.getConfig(sourceId);
			if (config)
				selectTargetItem(config.targetId);
		}

		override protected function onHide() : void
		{
			_mergeButton.removeEventListener(MouseEvent.CLICK, mergeButton_clickHandler);
			_autoButton.removeEventListener(MouseEvent.CLICK, autoButton_clickHandler);
			Common.game_server.removeCallback(0xFFF2, onPackChange);
			_targetList.selectionModel.removeEventListener(Event.CHANGE, targetList_selectHandler);
			SignalBusManager.mergeViewSelectSource.remove(onSelectSource);
			super.onHide();
		}

		private function onPackChange(msg : CCPackChange) : void
		{
			if (msg.topType | Item.ENHANCE || msg.topType | Item.EXPEND)
			{
				updateTargetList();
				updateMaterial();
			}
		}

		private function mergeButton_clickHandler(event : MouseEvent) : void
		{
			if (_materialItem.nums < _config.count)
			{
				StateManager.instance.checkMsg(16);
				return;
			}

			if (UserData.instance.silver < _config.moneyCount)
			{
				SingleQuickShop.show(ID.SILVER, ID.GOLD, Math.ceil((_config.moneyCount - UserData.instance.silver)), onMergeShop, null, this);
				return;
			}

			onMergeShop();
		}

		private function onMergeShop() : void
		{
			_manager.sendMaterialMergeMessage(_config.sourceId, MergeType.MERGE_AUTO);
		}

		private function autoButton_clickHandler(event : MouseEvent) : void
		{
			if (_materialItem.nums < _config.count)
			{
				StateManager.instance.checkMsg(16);
				return;
			}

			StateManager.instance.checkMsg(183, null, onConfirmAutoMerge, [int(_materialItem.nums / _config.count) * _config.count, _materialItem.id, int(_materialItem.nums / _config.count) * _config.moneyCount, int(_materialItem.nums / _config.count), _targetItem.id]);
		}

		private function onAutoMerge() : void
		{
			_manager.sendMaterialMergeMessage(_config.sourceId, MergeType.MERGE_ALL);
		}

		private function onConfirmAutoMerge(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				var need : int = _config.moneyCount * int(_materialItem.nums / _config.count);

				if (UserData.instance.silver < need)
				{
					SingleQuickShop.show(ID.SILVER, ID.GOLD, Math.ceil((need - UserData.instance.silver)), onAutoMerge, null, this);
				}
				else
				{
					onAutoMerge();
				}
			}
			return true;
		}

		private function targetList_selectHandler(event : Event) : void
		{
			var labelSource : LabelSource = _targetList.selection as LabelSource;

			if (labelSource)
			{
				_config = labelSource.value as MergeConfig;
				_targetItem = _itemManager.newItem(_config.targetId);
				_materialItem = _itemManager.getPileItem(_config.sourceId);
				updateResult();
				updateMaterial();
			}
		}
	}
}
