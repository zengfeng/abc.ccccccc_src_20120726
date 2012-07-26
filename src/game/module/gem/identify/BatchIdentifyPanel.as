package game.module.gem.identify {
	import game.core.item.Item;
	import game.core.item.gem.Gem;
	import game.definition.UI;

	import gameui.cell.GCell;
	import gameui.controls.GButton;
	import gameui.controls.GGird;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;





	/**
	 * @author jian
	 */
	public class BatchIdentifyPanel extends AbstractorSubPanel
	{
		// =====================
		// @属性
		// =====================
		public static var EXIT : String = "exit";
		private static var MAX : uint = 10;
		private var _targetGrid : GGird;
		private var _batchButton : GButton;
		private var _exitButton : GButton;
		/*
		 * 未鉴定的列表
		 */
		private var _unidentifiedList : Array /* of Item */ 
		= [];
		/*
		 * 已鉴定的列表
		 */
		private var _identifiedList : Array /* of Item */ 
		= [];

		// =====================
		// @创建
		// =====================
		public function BatchIdentifyPanel(control : GemIdentifyControl, sourceGrid : ItemGrid)
		{
			super(control, sourceGrid);
		}

		/*
		 * 创建
		 */
		override protected function create() : void
		{
			super.create();

			addPhrase();
			addItemGrid();
			addButtons();
		}

		/*
		 * 大师对话
		 */
		private function addPhrase() : void
		{
			var board : Sprite = UIManager.getUI(new AssetData(UI.GEM_PHRASE_BOARD));
			board.x = 60;
			board.y = 5;
			_content.addChild(board);

			var _masterPhrase : TextField = UICreateUtils.createTextField("请放入10个所需鉴定的原石", null, 168, 45, 70, 10, TextFormatUtils.panelContent);
			_masterPhrase.wordWrap = true;
			_content.addChild(_masterPhrase);
		}

		/*
		 * 添加物品格
		 */
		private function addItemGrid() : void
		{
			var data : ItemGridData = new ItemGridData();
			data.rows = 3;
			data.columns = 4;
			data.hgap = 4;
			data.vgap = 0;
			data.padding = 4;
			data.x = 12;
			data.y = 74;
			data.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			data.cell = ItemGridCell;
			data.verticalScrollPolicy = GPanelData.ON;

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 54;
			cellData.height = 70;
			cellData.showName = true;
			cellData.iconData.showBg = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showToolTip = true;

			data.cellData = cellData;

			_targetGrid = new GGird(data);
			_content.addChild(_targetGrid);
		}

		/*
		 * 添加按钮
		 */
		private function addButtons() : void
		{
			_batchButton = UICreateUtils.createGButton("开始鉴定", 0, 0, 43, 330);
			_content.addChild(_batchButton);

			_exitButton = UICreateUtils.createGButton("返回", 0, 0, 135, 330);
			_content.addChild(_exitButton);
		}

		// =====================
		// @更新
		// =====================
		/*
		 * 添加待鉴定物品
		 */
		override protected function addUnidentifiedItem(item : Item) : void
		{
			if (_targetGrid.model.size < MAX)
			{
				_unidentifiedList.push(item);
				updateItemGrids();
			}
		}

		/*
		 * 添加已鉴定物品
		 */
		private function addIdentifiedItem(item : Item) : void
		{
			if (_targetGrid.model.size < MAX)
			{
				_identifiedList.push(item);
				updateItemGrids();
			}
		}

		override protected function getFilterItems() : Array /* of Item */
		{
			return _unidentifiedList.concat();
		}

		/*
		 * 刷新物品格
		 */
		private function updateItemGrids() : void
		{
			_targetGrid.model.source = _identifiedList.concat(_unidentifiedList);
			super.updateItemGrid();
		}

		/*
		 * 进入面板
		 */
		override protected function onShow() : void
		{
			super.onShow();

			_targetGrid.addEventListener(GCell.SELECT, targetSelectHandler, true);
			_batchButton.addEventListener(MouseEvent.CLICK, batchIdentifyHandler);
			_exitButton.addEventListener(MouseEvent.CLICK, exitHandler);
		}

		/*
		 * 退出面板
		 */
		override protected function onHide() : void
		{
			_targetGrid.removeEventListener(GCell.SELECT, targetSelectHandler, true);
			_batchButton.removeEventListener(MouseEvent.CLICK, batchIdentifyHandler);
			_exitButton.removeEventListener(MouseEvent.CLICK, exitHandler);
			super.onHide();
		}

		/*
		 * 响应选择物品
		 */
		private function targetSelectHandler(event : Event) : void
		{
			var item : Item = ItemGridCell(event.target).source;

			if (item is Gem)
				_identifiedList.splice(_identifiedList.indexOf(item), 1);
			else
				_unidentifiedList.splice(_unidentifiedList.indexOf(item), 1);

			updateItemGrids();
		}

		/*
		 * 响应批量鉴定
		 */
		private function batchIdentifyHandler(event : MouseEvent) : void
		{
			processOneIdentify();
		}

		private function oneIdentifyCompleteHandler(msg : Event) : void
		{
			_control.removeEventListener(Event.COMPLETE, oneIdentifyCompleteHandler);
			_unidentifiedList.shift();

			_identifiedList.push(_control.identifiedGem);
			updateItemGrids();

			// 1秒后执行下一个
			setTimeout(processOneIdentify, 1000);
		}

		private function processOneIdentify() : void
		{
			if (_unidentifiedList.length > 0)
			{
				_control.addEventListener(Event.COMPLETE, oneIdentifyCompleteHandler);
				_control.item = _unidentifiedList[0];
				_control.wantLuck = true;
				_control.identify();
			}
		}

		/*
		 * 退出
		 */
		private function exitHandler(event : MouseEvent) : void
		{
			_unidentifiedList = [];
			updateItemGrid();

			var e : Event = new Event(EXIT);
			dispatchEvent(e);
		}
	}
}
