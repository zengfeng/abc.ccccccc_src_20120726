package game.module.mapFishing.view
{
	import com.commUI.GCommonSmallWindow;
	import com.commUI.itemgrid.ItemCellEvent;
	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.mapFishing.FishingManager;
	import game.module.pack.GoodOperateBox;
	import game.module.pack.ManagePack;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;

	import gameui.controls.GButton;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import net.AssetData;

	/**
	 * @author jian
	 */
	public class BasketPanel extends GCommonSmallWindow
	{
		// 属性
		private var _openButton : GButton;
		private var _itemGrid : ItemGrid;
		private var _bgSkin : Sprite;
		private var _operateBox : GoodOperateBox;
		private var _usingItem : Boolean = false;

		// 创建
		public function BasketPanel()
		{
			_data = new GTitleWindowData();
			_data.width = 248;
			_data.height = 352;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;
			name = FishingManager.BOX;
			super(_data);
		}

		override protected function create() : void
		{
			super.create();
			initView();
		}

		private function initView() : void
		{
			title = "鱼篓";

			addBgSkin();
			addPackage();
			addButtons();
		}

		private function addBgSkin() : void
		{
			_bgSkin = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			_bgSkin.x = 5;
			_bgSkin.width = width - 10;
			_bgSkin.height = height - 5;
			contentPanel.addChild(_bgSkin);
		}

		private function addPackage() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 10;
			gridData.y = 22;
			gridData.allowDrag = false;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 5;
			gridData.columns = 4;
			gridData.hgap = 5;
			gridData.vgap = 7;
			gridData.padding = 5;
			gridData.cell = ItemGridCell;
			gridData.verticalScrollPolicy = GPanelData.ON;

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 48;
			cellData.height = 48;
			cellData.allowSelect = true;
			cellData.iconData.showToolTip = true;
			cellData.iconData.showBg = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showBinding = true;
			cellData.iconData.showRollOver = true;
			gridData.cellData = cellData;

			_itemGrid = new ItemGrid(gridData);
			_itemGrid.source = [];
			addChild(_itemGrid);
		}

		// var a : Item = ItemManager.instance.getPileItem(2016);
		// var b : Item = ItemManager.instance.getPileItem(2008);
		private function addButtons() : void
		{
			_openButton = UICreateUtils.createGButton('全部打开', 0, 0, 85, 308);
			addChild(_openButton);
		}

		// 交互
		override public function show() : void
		{
			if (ViewManager.instance.uiContainer.getChildByName(name))
				hide();
			else
				super.show();
		}

		override protected function onShow() : void
		{
			super.onShow();
			initEvents();
			x = (UIManager.stage.stageWidth - width) / 2;
			y = (UIManager.stage.stageHeight - height) / 2;
			checkFishes();
		}

		private function initEvents() : void
		{
			Common.game_server.addCallback(0xfff2, packChangeCallback);
			_openButton.addEventListener(MouseEvent.CLICK, onOpenAwardClick);
			_itemGrid.addEventListener(ItemCellEvent.SELECT, itemGrid_selectCellHandler, true);
		}

		override protected function onHide() : void
		{
			super.onHide();
			clearEvents();
		}

		private function clearEvents() : void
		{
			Common.game_server.removeCallback(0xfff2, packChangeCallback);
			_itemGrid.removeEventListener(ItemCellEvent.SELECT, itemGrid_selectCellHandler, true);
			_openButton.removeEventListener(MouseEvent.CLICK, onOpenAwardClick);
		}

		private function onOpenAwardClick(event : Event) : void
		{
			_usingItem = true;
			var list : Array = _itemGrid.source;
			var item : Item;
			for (var i : int = 0;i < list.length;i++)
			{
				item = list[i];
				ManagePack.useItem(item.id, item.binding, item.nums, 0);
			}
			_usingItem = false;
			checkFishes();
		}

		// 0xfff2
		private function packChangeCallback(msg : CCPackChange) : void
		{
			if (_usingItem)
				return;

			if (msg.topType | Item.EXPEND)
				checkFishes();
		}

		// 更新
		public function addItem(item : Item) : void
		{
			_itemGrid.source = (_itemGrid.source as Array).concat([item]);
		}

		private function checkFishes() : void
		{
			_itemGrid.source = ItemManager.instance.getFishes();
			if ((_itemGrid.source as Array).length > 0)
				_openButton.enabled = true;
			else
				_openButton.enabled = false;
		}

		private function itemGrid_selectCellHandler(event : ItemCellEvent) : void
		{
			if (!_operateBox)
				_operateBox = new GoodOperateBox();

			var item : Item = event.item;

			// panel.x = stage.mouseX - panel.width/2;
			// panel.y = stage.mouseY - panel.height;
			_operateBox.x = stage.mouseX + 20;
			_operateBox.y = stage.mouseY;
			_operateBox.source = item;
			_operateBox.show();
		}
	}
}