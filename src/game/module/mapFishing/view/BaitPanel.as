package game.module.mapFishing.view
{
	import log4a.Logger;
	import game.module.mapFishing.FishingState;
	import com.commUI.GCommonWindow;
	import com.commUI.button.GItemRadioButton;
	import com.commUI.quickshop.SingleQuickShop;
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
	import game.manager.ViewManager;
	import game.module.mapFishing.FishingManager;
	import game.module.mapFishing.FishingModel;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import gameui.controls.GButton;
	import gameui.core.GAlign;
	import gameui.data.GTitleWindowData;
	import gameui.group.GToggleGroup;
	import gameui.manager.UIManager;
	import net.AssetData;




	/**
	 * @author jian
	 */
	public class BaitPanel extends GCommonWindow
	{
		// =====================
		// 常数
		// =====================
		private static const ITEM_NUMS : int = 4;
		private static const BAIT_IDS : Array = [ID.NORMAL_BAIT, ID.PRIMARY_BAIT, ID.MEDIUM_BAIT, ID.SENIOR_BAIT];
		// =====================
		// 属性
		// =====================
		private var _startButton : GButton;
		private var _GItemRadioButtones : Array;
		private var _bgSkin : Sprite;
		private var _group : GToggleGroup;
		private var _remainText : TextField;
		private var _model : FishingModel;

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function BaitPanel(model : FishingModel)
		{
			_model = model;
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 330;
			data.height = 187;
			data.parent = ViewManager.instance.uiContainer;
			data.align = new GAlign(-1, -1, -1, -1, 1, 1);
			data.allowDrag = true;
			// data.modal = true;
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			this.title = "钓鱼";
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
			_bgSkin.width = width - 15;
			_bgSkin.height = height - 5;
			_contentPanel.addChild(_bgSkin);
		}

		private function addHint() : void
		{
			addChild(UICreateUtils.createTextField("选择本次使用的鱼饵：", null, 150, 20, 20, 10, TextFormatUtils.panelContent));
		}

		private function addRemainText() : void
		{
			_remainText = UICreateUtils.createTextField("钓鱼次数：", null, 80, 20, 213, 146, TextFormatUtils.panelContent);
			addChild(_remainText);
		}

		private function addButtons() : void
		{
			_startButton = UICreateUtils.createGButton("确定", 0, 0, 119, 142);
			addChild(_startButton);
		}

		private function addGItemRadioButtones() : void
		{
			var frameBg : Sprite = UIManager.getUI(new AssetData(UI.AREA_BACKGROUND));
			frameBg.x = 17;
			frameBg.y = 34;
			frameBg.width = 293;
			frameBg.height = 98;
			addChild(frameBg);

			_GItemRadioButtones = [];
			_group = new GToggleGroup();
			for (var i : uint = 0;i < ITEM_NUMS;i++)
			{
				var item : GItemRadioButton = new GItemRadioButton(i == 0);
				item.x = 22 + 77 * i;
				item.y = 40;
				item.group = _group;
				_GItemRadioButtones.push(item);
				addChild(item);
			}
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateBaits() : void
		{
			for (var i : uint = 0;i < ITEM_NUMS;i++)
			{
				(_GItemRadioButtones[i] as GItemRadioButton).source = ItemManager.instance.getPileItem(BAIT_IDS[i]);
			}
		}

		private function selectDefaultBaits() : void
		{
			if (_model.bait <= 0)
				_group.selectionModel.index = 0;
			else
				_group.selectionModel.index = _model.bait;
		}

		private function updateRemainText() : void
		{
			_remainText.text = "钓鱼次数：" + _model.leftTimes;
		}

		// -----------------------------------------------
		// 交互
		// -----------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			x = Math.floor((UIManager.stage.stageWidth - this.width) / 2);
			y = Math.floor((UIManager.stage.stageHeight - this.height) / 2);

			updateBaits();
			selectDefaultBaits();
			updateRemainText();

			_startButton.addEventListener(MouseEvent.CLICK, startButton_clickHandler);
			Common.game_server.addCallback(0xfff2, onPackChange);
		}

		override protected function onHide() : void
		{
			super.onHide();
			_startButton.removeEventListener(MouseEvent.CLICK, startButton_clickHandler);
			Common.game_server.removeCallback(0xfff2, onPackChange);
		}

		private function startButton_clickHandler(event : Event) : void
		{
			if(_model.state != FishingState.INIT)
			{
				Logger.info("钓鱼重复点击，跳过");
				return;
			}
				
			var index : int = _group.selectionModel.index;

			var good : Item = (_GItemRadioButtones[index] as GItemRadioButton).source;
//			var order : VoOrder;
			if (good.nums > 0 || index == 0)
			{
				_model.bait = index;
				FishingManager.instance.sendFishBeginMessage();
				hide();
			}
			else
			{
				SingleQuickShop.show(good.id, ID.GOLD, 1, null, null, this);
				// order = new VoOrder();
				// order.id = good.id;
				// order.count = 1;
//				 MultiQuickShop.showOrder([order], null, null, this);
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
