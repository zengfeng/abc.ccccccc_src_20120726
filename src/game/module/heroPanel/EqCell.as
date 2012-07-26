package game.module.heroPanel
{
	import com.commUI.icon.ItemIcon;
	import com.utils.UICreateUtils;

	import flash.events.MouseEvent;

	import game.core.item.equipable.EquipableItem;
	import game.core.item.equipment.Equipment;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.definition.UI;
	import game.manager.SignalBusManager;

	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;

	import net.AssetData;

	/**
	 * @author yangyiqiang
	 */
	public class EqCell extends GComponent
	{
		// =====================
		// 属性
		// =====================
		private var _icon : ItemIcon;
		private var _showPair : Boolean;
		private var _transButton : GButton;
		private var _transSource : Equipment;

		// =====================
		// Setter/Getter
		// =====================
		override public function set source(value : *) : void
		{
			_source = value;
			updateIcon();
		}

		override public function get source() : *
		{
			return _source;
		}

		public function set transferTarget(value : Equipment) : void
		{
			_transSource = value;
			updateTransButton();
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function EqCell(showPair : Boolean = false)
		{
			_showPair = showPair;
			var data : GComponentData = new GComponentData();
			super(data);
		}

		override protected function create() : void
		{
			addItemIcon();
			addTransButton();
		}

		private function addItemIcon() : void
		{
			_icon = UICreateUtils.createItemIcon({showBorder:true, showLevel:true, showToolTip:true, showRollOver:true, showPair:_showPair});
			addChild(_icon);
		}

		private function addTransButton() : void
		{
			var data : GButtonData = new GButtonData();
			data.x = 32;
			data.y = -4;
			data.width = 24;
			data.height = 24;
			data.upAsset = new AssetData(UI.BUTTON_UP_ARROW_UP);
			data.overAsset = new AssetData(UI.BUTTON_UP_ARROW_OVER);
			data.downAsset = new AssetData(UI.BUTTON_UP_ARROW_DOWN);
			_transButton = new GButton(data);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateIcon() : void
		{
			_icon.source = _source;
		}

		private function updateTransButton() : void
		{
			if (_transSource)
			{
				if (!contains(_transButton))
					addChild(_transButton);
			}
			else
			{
				if (contains(_transButton))
					removeChild(_transButton);
			}
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			addEventListener(MouseEvent.CLICK, singleClickHandler);
			_transButton.addEventListener(MouseEvent.CLICK, transButton_clickHandler);
		}

		override protected function onHide() : void
		{
			removeEventListener(MouseEvent.CLICK, singleClickHandler);
			_transButton.removeEventListener(MouseEvent.CLICK, transButton_clickHandler);
		}

		private function singleClickHandler(event : MouseEvent) : void
		{
			if (event.ctrlKey)
				return;
				
			if (!(_icon.source as EquipableItem))
				return;

			var item : EquipableItem = _icon.source as EquipableItem;

			if (item.slot)
			{
				item.slot.release();
				if (!MenuManager.getInstance().getMenuState(MenuType.PACK))
					MenuManager.getInstance().openMenuView(MenuType.PACK);

				// SignalBusManager.packPanelSelectPage.dispatch(0);
			}

			event.stopPropagation();
		}

		private function transButton_clickHandler(event : MouseEvent) : void
		{
			event.stopPropagation();

			var e : EnhanceTransferEvent = new EnhanceTransferEvent(EnhanceTransferEvent.TRANSFER);
			e.sourceEquipment = _source;
			e.targetEquipment = _transSource;
			dispatchEvent(e);
		}
	}
}
