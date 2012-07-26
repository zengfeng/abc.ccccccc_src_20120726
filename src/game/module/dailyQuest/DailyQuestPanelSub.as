package game.module.dailyQuest
{
	import com.commUI.GCommonSmallWindow;
	import com.commUI.button.GItemRadioButton;
	import com.commUI.quickshop.SingleQuickShop;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.definition.ID;
	import game.definition.UI;
	import game.module.quest.QuestManager;
	import game.module.quest.QuestUtil;
	import game.module.quest.VoQuest;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import gameui.controls.GButton;
	import gameui.core.GAlign;
	import gameui.data.GTitleWindowData;
	import gameui.group.GToggleGroup;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import net.AssetData;





	public class DailyQuestPanelSub extends GCommonSmallWindow
	{
		private static const ITEM_NUMS : int = 4;
		private static const IDS : Array = [ID.NORMAL_DAILY, ID.PRIMARY_DAILY, ID.MEDIUM_DAILY, ID.SENIOR_DAILY];
		private var _startButton : GButton;
		private var _GItemRadioButtones : Array;
		private var _bgSkin : Sprite;
		private var _group : GToggleGroup;
		private var _remainText : TextField;
		public var preWindow : DailyQuestPanel;
		private var _targetQuestId : uint;

		public function DailyQuestPanelSub()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 345;
			data.height = 205;
			data.parent = UIManager.root;
			data.align = new GAlign(-1, -1, -1, -1, 1, 1);
			data.modal = true;
			super(data);
		}

		public function set targetQuestId(value : uint) : void
		{
			_targetQuestId = value;
		}

		override protected function create() : void
		{
			super.create();
			this.title = "选择悬赏令";
			addBackground();
			addHint();
			addRemainText();
			addGItemRadioButtones();
			addButtons();
		}

		private function addBackground() : void
		{
			_bgSkin = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			_bgSkin.x = 5;
			_bgSkin.y = 0;
			_bgSkin.width = 330;
			_bgSkin.height = 198;
			_contentPanel.addChild(_bgSkin);
		}

		private function addHint() : void
		{
			addChild(UICreateUtils.createTextField("选择本次使用的悬赏令:", null, 150, 20, 13, 10, TextFormatUtils.panelContent));
		}

		private function addRemainText() : void
		{
			_remainText = UICreateUtils.createTextField("可获得:", null, 200, 20, 13, 133, TextFormatUtils.panelContent);
			_remainText.htmlText = "可获得:" + StringUtils.addColor("白色宝箱", "#ffffff");
			addChild(_remainText);
			_remainText.y = 136;
		}

		private function addButtons() : void
		{
			_startButton = UICreateUtils.createGButton("确定", 0, 0, 129, 155);
			addChild(_startButton);
		}

		private function addGItemRadioButtones() : void
		{
			var frameBg : Sprite = UIManager.getUI(new AssetData(UI.AREA_BACKGROUND));
			frameBg.x = 13;
			frameBg.y = 34;
			frameBg.width = 312;
			frameBg.height = 98;
			addChild(frameBg);

			_GItemRadioButtones = [];
			_group = new GToggleGroup();
			for (var i : uint = 0;i < ITEM_NUMS;i++)
			{
				var item : GItemRadioButton = new GItemRadioButton(i == 0);
				item.x = 27 + 77 * i;
				item.y = 40;
				item.group = _group;
				_GItemRadioButtones.push(item);
				addChild(item);
			}
			_group.selectionModel.index = 0;
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateBaits() : void
		{
			for (var i : uint = 0;i < ITEM_NUMS;i++)
			{
				(_GItemRadioButtones[i] as GItemRadioButton).source = ItemManager.instance.getPileItem(IDS[i]);
			}
		}

		private function selection_changeHandler(event : Event) : void
		{
			var index : int = _group.selectionModel.index;
			var colorTreasure : Array = ["白色宝箱", "绿色宝箱", "蓝色宝箱", "紫色宝箱"];
			var colorValueTreasure : Array = ["#ffffff", "#279F15", "#3882D4", "#CE5DD4"];
			_remainText.htmlText = "可获得:" + StringUtils.addColor(colorTreasure[index], colorValueTreasure[index]);
		}

		// -----------------------------------------------
		// 交互
		// -----------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			_startButton.addEventListener(MouseEvent.CLICK, startButton_clickHandler);
			Common.game_server.addCallback(0xfff2, onPackChange);
			GLayout.layout(this);
			_group.selectionModel.addEventListener(Event.CHANGE, selection_changeHandler);
			updateBaits();
			this._startButton.enabled = true;
		}

		override protected function onHide() : void
		{
			super.onHide();
			_startButton.removeEventListener(MouseEvent.CLICK, startButton_clickHandler);
			Common.game_server.removeCallback(0xfff2, onPackChange);
			_group.selectionModel.removeEventListener(Event.CHANGE, selection_changeHandler);
		}

		private function startButton_clickHandler(event : Event) : void
		{
			var index : int = _group.selectionModel.index;

			var good : Item = (_GItemRadioButtones[index] as GItemRadioButton).source;
			var quest : VoQuest = QuestManager.getInstance().search(_targetQuestId);
			if (good.nums > 0 || index == 0)
			{
				QuestManager.getInstance().resetQuestState(_targetQuestId, QuestManager.UNDONE);
				quest.resetReqStep();
				QuestUtil.sendTaskOperateReq(_targetQuestId, 1, index);
				hide();
				this._startButton.enabled = false;
			}
			else
			{
				SingleQuickShop.show(good.id, ID.GOLD, 1, null, null, this);
			}
		}

		// 0xfff2
		private function onPackChange(msg : CCPackChange) : void
		{
			if (msg.topType == Item.EXPEND)
				updateBaits();
		}
	}
}
