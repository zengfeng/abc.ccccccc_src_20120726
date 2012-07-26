package game.module.gem.identify
{
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.core.item.Item;
	import game.module.gem.GemChildPanel;
	import gameui.controls.GButton;




	/**
	 * @author jian
	 */
	public class GemIdentifyPanel extends GemChildPanel
	{
		// ==============================================================
		// @属性
		// ==============================================================
		private var _masterIcons : Array = [] /* of GemMasterCell */;
		private var _identifyButton : GButton;
		private var _batchButton : GButton;
		private var _mansionButton : GButton;
		private var _masterCell : GemMasterCell;
		private var _batchMode : Boolean = false;
		private var _singlePanel : SingleIdentifyPanel;
		private var _batchPanel : BatchIdentifyPanel;
		private var _control : GemIdentifyControl;

		// ==============================================================
		// @创建
		// ==============================================================
		override protected function create() : void
		{
			super.create();
			
//			_itemGrid.filterFuncs = [itemFilterFunc];

			// 控制器
			addIdentifyControl();

			// 视图
			addMasterList();
			addIdentifyButton();
			addMansionButton();
			addSinglePanel();
			
			_singlePanel.updateItemGrid();
		}

		/*
		 * 添加强化控制器
		 */
		private function addIdentifyControl() : void
		{
			_control = new GemIdentifyControl();
		}

		/*
		 * 添加大师列表
		 */
		private function addMasterList() : void
		{
			for (var i : uint = 0; i < 3; i++)
			{
				var master : GemMasterVO = GemMasterManager.instance.masters[i];
				var icon : GemMasterCell = new GemMasterCell(master);
				icon.x = 8;
				icon.y = 12 + i * 117;
				_masterIcons.push(icon);
				_content.addChild(icon);
			}
		}

		/*
		 * 添加鉴定按钮
		 */
		private function addIdentifyButton() : void
		{
			_identifyButton = UICreateUtils.createGButton("鉴定", 0, 0, 118, 319);
			_content.addChild(_identifyButton);

			_batchButton = UICreateUtils.createGButton("批量鉴定", 0, 0, 212, 319);
			_content.addChild(_batchButton);
		}

		/*
		 * 添加聚宝府邸按钮
		 */
		private function addMansionButton() : void
		{
			_mansionButton = UICreateUtils.createGButton("前往聚宝府邸", 0, 0, 448, 329);
			_content.addChild(_mansionButton);
		}

		/*
		 * 单次鉴定面板
		 */
		private function addSinglePanel() : void
		{
			_singlePanel = new SingleIdentifyPanel(_control, _itemGrid);
			_singlePanel.x = 73;
			_singlePanel.y = 12;
			addChild(_singlePanel);
		}


		// ==============================================================
		// @更新
		// ==============================================================
		/*
		 * 更新视图
		 */
		private function updateView() : void
		{
			updateMaster();
			updatePack();
		}

		/*
		 * 更新大师信息
		 */
		private function updateMaster() : void
		{
			var master : GemMasterVO = _masterCell.master;
			_control.master = master;
			_singlePanel.master = master;
		}

		
		// ==============================================================
		// @交互
		// ==============================================================
		/*
		 * 进入面板
		 */
		override protected function onShow() : void
		{
			super.onShow();

			for each (var icon:Sprite in _masterIcons)
			{
				icon.addEventListener(MouseEvent.MOUSE_DOWN, masterSelectHandler);
			}

			if (_batchMode)
				_batchPanel.addEventListener(BatchIdentifyPanel.EXIT, batchExitHandler);
			_singlePanel.addEventListener(SingleIdentifyPanel.OPEN_BATCH, openBatchHandler);
			selectDefaultMaster();
			updateView();
		}

		/*
		 * 退出面板
		 */
		override protected function onHide() : void
		{
			for each (var icon:Sprite in _masterIcons)
			{
				icon.removeEventListener(MouseEvent.MOUSE_DOWN, masterSelectHandler);
			}

			if (_batchMode)
				_batchPanel.removeEventListener(BatchIdentifyPanel.EXIT, batchExitHandler);
			_singlePanel.removeEventListener(SingleIdentifyPanel.OPEN_BATCH, openBatchHandler);
			super.onHide();
		}

		/*
		 * 默认选择大师
		 */
		private function selectDefaultMaster() : void
		{
			if (!_masterCell)
			{
				selectMaster(_masterIcons[0]);
			}
		}

		/*
		 * 进入批量鉴定
		 */
		private function openBatchHandler(event : Event) : void
		{
			_batchMode = true;
			
			_batchPanel = new BatchIdentifyPanel(_control, _itemGrid);
			_batchPanel.x = 73;
			_batchPanel.y = 12;
			addChild(_batchPanel);
			_batchPanel.addEventListener(BatchIdentifyPanel.EXIT, batchExitHandler);
			
			removeChild(_singlePanel);
		}

		/*
		 * 退出批量鉴定
		 */
		private function batchExitHandler(event : Event) : void
		{
			_batchMode = false;
			
			_batchPanel.removeEventListener(BatchIdentifyPanel.EXIT, batchExitHandler);
			removeChild(_batchPanel);
			
			addChild(_singlePanel);
		}

		/*
		 * 响应选择大师
		 */
		private function masterSelectHandler(event : Event) : void
		{
			if (event.target is GemMasterCell)
			{
				var icon : GemMasterCell = event.target as GemMasterCell;
				selectMaster(icon);

				updateMaster();
			}
		}

		/*
		 * 选择大师
		 */
		private function selectMaster(icon : GemMasterCell) : void
		{
			if (_masterCell)
				_masterCell.selected = false;
			_masterCell = icon;
			_masterCell.selected = true;
		}

		/*
		 * 响应VIP改变
		 */
		private function vipLevelChangeHandler() : void
		{
		}

		// ==============================================================
		// @其它
		// ==============================================================
		/*
		 * 原石筛选函数
		 */
		override protected function itemFilterFunc(item : Item, index : int, arr : Array/* of Item */) : Boolean
		{
			return item.type == 65 && (_filterType == -1 || item.type == _filterType);
		}
	}
}
