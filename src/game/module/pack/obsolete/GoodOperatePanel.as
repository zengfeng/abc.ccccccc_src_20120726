package game.module.pack.obsolete
{
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.icon.ItemIcon;
	import com.commUI.icon.ItemIconData;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.TextFormatUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.core.item.Item;
	import game.core.user.StateManager;
	import game.definition.UI;
	import game.module.pack.ManagePack;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import net.AssetData;








	/**
	 * @author yangyiqiang
	 */
	public final class GoodOperatePanel extends GPanel
	{
		// =====================
		// 属性
		// =====================
		private var _itemVo : Item;
		private var _itemIcon : ItemIcon;
		private var _sellButton : GButton;
		private var _useButton : GButton;
		private var _closeButton : GButton;
		private var _itemName : GLabel;

		// =====================
		// Setter/Getter
		// =====================
		override public function set source(value : *) : void
		{
			_itemVo = value;

			if (value)
			{
				updateName();
				updateButton();
				updateItemIcon();
			}
			else
			{
				clear();
			}
		}

		// ==============================================================
		// 方法
		// ==============================================================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function GoodOperatePanel()
		{
			var data : GPanelData = new GPanelData();
			data.bgAsset = new AssetData(UI.INFO_WINDOW_BACKGROUND)		;
			data.parent = UIManager.root;
			data.width = 200;
			data.height = 80;
			data.hideEffect = null;
			data.modal = true;

			super(data);
		}

		override protected function create() : void
		{
			super.create();
			addUnderline();
			addItemIcon();
			addButton();
			addName();
		}

		private function addUnderline() : void
		{
			var line : Sprite = UIManager.getUI(new AssetData(UI.PACK_DIALOG_UNDERLINE));
			line.x = 67;
			line.y = 41;
			line.width = 115;
			_content.addChild(line);
		}

		private function addButton() : void
		{
			var sell : GButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
			sell.width = 50;
			sell.x = 139;
			sell.y = 50;
			sell.labelData.text = "出售";
			_sellButton = new GButton(sell);
			_content.addChild(_sellButton);

			var other : GButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
			other.width = 50;
			other.x = 72;
			other.y = 50;
			other.labelData.text = "使用";
			_useButton = new GButton(other);
			_content.addChild(_useButton);

			_closeButton = UIManager.getCloseButton();
			_closeButton.x = 178;
			_closeButton.y = 6;
			_closeButton.width = 16;
			_closeButton.height = 18;
			_content.addChild(_closeButton);
			GLayout.layout(_closeButton);
		}

		private function addName() : void
		{
			var data : GLabelData = new GLabelData();
			data.x = 72;
			data.y = 22;
			data.textFormat = TextFormatUtils.panelSubTitle;
			_itemName = new GLabel(data);
			_content.addChild(_itemName);
		}

		private function addItemIcon() : void
		{
			var data : ItemIconData = new ItemIconData();
			data.showBg = true;
			data.showLevel = true;
			data.showNums = true;
			data.showBorder = true;
			data.showToolTip = true;
			data.showBinding = true;
			data.x = 16;
			data.y = 16;
			_itemIcon = new ItemIcon(data);
			_content.addChild(_itemIcon);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateName() : void
		{
			_itemName.htmlText = _itemVo.htmlName;
		}

		private function updateButton() : void
		{
			_useButton.visible = _itemVo.usable;
		}

		private function updateItemIcon() : void
		{
			_itemIcon.source = _itemVo;
		}

		private function clear() : void
		{
			_itemName.htmlText = "";
			_itemIcon.source = null;
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			addEvent();
			ToolTipManager.instance.enabled = false;
		}

		override protected function onHide() : void
		{
			ToolTipManager.instance.enabled = true;
			removeEvent();
			_itemIcon.source = null;
			super.onHide();
		}

		private function addEvent() : void
		{
			_sellButton.addEventListener(MouseEvent.CLICK, onSellClick);
			_useButton.addEventListener(MouseEvent.CLICK, onUseClick);
			_closeButton.addEventListener(MouseEvent.CLICK, onClose);
			// stage.addEventListener(MouseEvent.CLICK, stage_clickHandler);
		}

		private function removeEvent() : void
		{
			_sellButton.removeEventListener(MouseEvent.CLICK, onSellClick);
			_useButton.removeEventListener(MouseEvent.CLICK, onUseClick);
			_closeButton.removeEventListener(MouseEvent.CLICK, onClose);
			// stage.removeEventListener(MouseEvent.CLICK, stage_clickHandler);
		}

		private function stage_clickHandler(event : MouseEvent) : void
		{
			if (!hitTestPoint(event.stageX, event.stageY))
				hide();
		}

		private function onSellClick(event : MouseEvent) : void
		{
			StateManager.instance.checkMsg(249, null, onSellConfirm);
		}

		private function onSellConfirm(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				ManagePack.sellItem([_itemVo]);
				hide();
			}
			return true;
		}

		private function onUseClick(event : MouseEvent) : void
		{
			ManagePack.useItem(_itemVo.id, _itemVo.binding, 1, 0);
			hide();
		}

		private function onClose(event : MouseEvent) : void
		{
			hide();
		}
	}
}
