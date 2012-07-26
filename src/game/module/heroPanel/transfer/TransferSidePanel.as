package game.module.heroPanel.transfer {
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.equipment.Equipment;
	import game.core.user.UserData;
	import game.definition.ID;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import game.net.data.CtoS.CSEnhanceTransfer;

	import gameui.controls.GButton;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;
	import com.commUI.button.KTButtonData;
	import com.commUI.icon.ExpenseIcon;
	import com.commUI.icon.ItemIcon;
	import com.commUI.quickshop.SingleQuickShop;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;






	/**
	 * @author jian
	 */
	public class TransferSidePanel extends GCommonSmallWindow
	{
		// =====================
		// 属性
		// =====================
		private var _model : TransferModel = new TransferModel();
		private var _bgSkin : Sprite;
		private var _sourceItemName : TextField;
		private var _sourceIcon : ItemIcon;
		private var _targetItemName : TextField;
		private var _targetIcon : ItemIcon;
		private var _targetLevelText : TextField;
		private var _expenseIcon : ExpenseIcon;
		private var _costlessText : TextField;
		private var _transButton : GButton;

		// =====================
		// Setter/Getter
		// =====================
		public function setSourceTarget(source : Equipment, target : Equipment) : void
		{
			_model.setSourceTarget(source, target);
			updateSourceItem();
			updateTargetItem();
			updateCost();
			updateText();
		}

		// =====================
		// @方法
		// =====================
		public function TransferSidePanel(data : GTitleWindowData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			this.title = "装备替换";

			addBgSkin();
			addArrow();
			addSourceItem();
			addTargetItem();
			addExpense();
			addButton();
		}

		private function addBgSkin() : void
		{
			_bgSkin = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			_bgSkin.x = 5;
			_bgSkin.width = width - 10;
			_bgSkin.height = height - 5;
			contentPanel.addChild(_bgSkin);
		}

		/*
		 * 添加箭头
		 */
		private function addArrow() : void
		{
			var arrow : Sprite = UIManager.getUI(new AssetData(UI.ICON_ARROW));
			arrow.x = 120;
			arrow.y = 60;
			contentPanel.addChild(arrow);
		}

		/*
		 * 添加可转移装备
		 */
		private function addSourceItem() : void
		{
			_sourceItemName = UICreateUtils.createTextField("原有装备", null, 120, 26, 43, 16, TextFormatUtils.panelSubTitle);
			contentPanel.addChild(_sourceItemName);

			_sourceIcon = UICreateUtils.createItemIcon({x:50, y:55, showBorder:true, showBg:true, showToolTip:true, showLevel:true, showBinding:true});
			contentPanel.addChild(_sourceIcon);
		}

		/*
		 * 添加接受转移装备
		 */
		private function addTargetItem() : void
		{
			_targetItemName = UICreateUtils.createTextField("目标装备", null, 120, 26, 191, 16, TextFormatUtils.panelSubTitle);
			contentPanel.addChild(_targetItemName);

			_targetIcon = UICreateUtils.createItemIcon({x:199, y:55, showBorder:true, showBg:true, showToolTip:true, showLevel:true, showBinding:true});
			contentPanel.addChild(_targetIcon);

			_targetLevelText = UICreateUtils.createTextField(null, null, 120, 26, 184, 118, TextFormatUtils.panelContent);
			contentPanel.addChild(_targetLevelText);
		}

		/*
		 * 添加转移材料
		 */
		private function addExpense() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.FORGE_FRAME_BACKGROUND));
			bg.x = 13;
			bg.y = 159;
			bg.width = 275;
			bg.height = 73;
			contentPanel.addChild(bg);

			contentPanel.addChild(UICreateUtils.createTextField("所需材料：", null, 100, 26, 18, 141, TextFormatUtils.panelContent));

			var data : GComponentData = new GComponentData();
			data.x = 119;
			data.y = 165;
			_expenseIcon = new ExpenseIcon(data);
			contentPanel.addChild(_expenseIcon);

			_costlessText = UICreateUtils.createTextField("替换目标装备无需任何材料", null, 270, 20, 11, 185, TextFormatUtils.panelSubTitleCenter);
			_costlessText.visible = false;
			contentPanel.addChild(_costlessText);
		}

		/*
		 * 添加按钮
		 */
		private function addButton() : void
		{
			var data : GButtonData = new KTButtonData();
			data.x = 112;
			data.y = 241;

			_transButton = new GButton(data);
			_transButton.text = "替换";
			contentPanel.addChild(_transButton);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateSourceItem() : void
		{
			if (_model.source)
			{
				// _sourceItemName.text = _model.sourceName;
				_sourceIcon.source = _model.source;
			}
			else
			{
				// _sourceItemName.text = "可转移的装备";
				_sourceIcon.clear();
			}
		}

		private function updateTargetItem() : void
		{
			if (_model.target)
			{
				// _targetItemName.text = _model.targetName;
				_targetIcon.source = _model.target;
			}
			else
			{
				// _targetItemName.text = "接受转移的装备";
				_targetIcon.clear();
			}
		}

		private function updateCost() : void
		{
			if (_model.mode == TransferModel.MODE_TRANSFER)
			{
				var cost : Item = ItemManager.instance.getPileItem(_model.costID);

				_expenseIcon.setExpense(cost, _model.costNums);
				_expenseIcon.visible = true;
				_costlessText.visible = false;
			}
			else
			{
				_expenseIcon.visible = false;
				_costlessText.visible = true;
			}
		}

		private function updateText() : void
		{
			if (_model.mode == TransferModel.MODE_TRANSFER)
			{
				_targetLevelText.visible = true;
				_targetLevelText.htmlText = "强化等级变为" + StringUtils.addColorById(_model.source.enhanceLevel.toString(), _model.source.enhanceColor);
			}
			else
			{
				_targetLevelText.visible = false;
			}
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
//			updateCost();
			_transButton.addEventListener(MouseEvent.CLICK, tansferClickHandler);
			Common.game_server.addCallback(0xFFF2, onPackChange);
		}

		override protected function onHide() : void
		{
			super.onHide();
			_transButton.removeEventListener(MouseEvent.CLICK, tansferClickHandler);
			Common.game_server.removeCallback(0xFFF2, onPackChange);
		}

		private function onPackChange(msg : CCPackChange) : void
		{
			if (msg.topType | Item.ENHANCE)
			{
				updateCost();
			}
		}

		private function tansferClickHandler(event : MouseEvent) : void
		{
			if (_model.mode == TransferModel.MODE_TRANSFER)
			{
				if (_model.costID == ID.SILVER)
				{
					if (UserData.instance.trySpendSilver(_model.costNums) < 0)
						SingleQuickShop.show(ID.SILVER_CARD, ID.GOLD, 1, processTransfer, null, this);
					else
					{
						processTransfer();
					}
				}
				else
				{
					var item : Item = ItemManager.instance.getPileItem(_model.costID);

					if (item && item.nums < _model.costNums)
						SingleQuickShop.show(item.id, ID.GOLD, (_model.costNums - item.nums), processTransfer, null, this);
					else
					{
						processTransfer();
					}
				}
			}
			else if (_model.mode == TransferModel.MODE_EQUIP)
			{
				processEquip();
			}
			else
			{
				hide();
			}
		}

		private function processTransfer() : void
		{
			var msg : CSEnhanceTransfer = new CSEnhanceTransfer();
			msg.sourceID = _model.source.equipId;
			msg.targetID = _model.target.equipId;

			Logger.info("强化转移：从" + _model.source.name + _model.source.uuid + " 到" + _model.target.name + _model.target.uuid);
			Common.game_server.sendMessage(0x281, msg);
			hide();
		}

		private function processEquip() : void
		{
			Logger.info("装备替换：从" + _model.source.name + _model.source.uuid + " 到" + _model.target.name + _model.target.uuid);
			_model.source.slot.equip(_model.target);
			hide();
		}
	}
}
