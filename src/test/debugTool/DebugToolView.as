package test.debugTool
{
	import log4a.Logger;
	import avmplus.getQualifiedClassName;

	import game.definition.UI;

	import gameui.cell.GCellData;
	import gameui.controls.GButton;
	import gameui.controls.GList;
	import gameui.data.GListData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.utils.UICreateUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author zhengyuhang
	 */
	public class DebugToolView extends GCommonWindow
	{
		private var _text : TextField = new TextField();
		private var _itemList : GList;
		private var _backBtn : GButton;
		private var _openBtn : GButton;
		private var _drawBtn : GButton;
		private var _clearBtn : GButton;
		private var _refreshBtn : GButton;
		private var _detailBtn : GButton;
		private var _root : DisplayObjectContainer;
		private var _num : int = 0;
		private var _selectVO : DebugToolVO;
		private var _refreshVO : DebugToolVO;
		private var _drawSelArea : Sprite;

		public function DebugToolView()
		{
			_data = new GTitleWindowData();
			_data.width = 410;
			_data.height = 500;
			_data.x = UIManager.stage.x + 80;
			_data.y = UIManager.stage.y + 130;
			_data.parent = UIManager.root;
			// _data.modal = true;
			_data.panelData.bgAsset = new AssetData(UI.COMMON_BACKGROUND05);
			_data.parent = UIManager.root;
			super(_data);

			// initViews();
		}

		override protected function create() : void
		{
			super.create();
			addLabels();
			addChildList();
			addButton();
			addItem();
			addDrawLayer();
		}

		private function addDrawLayer() : void
		{
			_drawSelArea = new Sprite();
			_drawSelArea.mouseEnabled = false;
			_drawSelArea.mouseChildren = false;
		}

		private function addButton() : void
		{
			_backBtn = UICreateUtils.createGButton("后退", 45, 25, 10, 15);
			addChild(_backBtn);

			_openBtn = UICreateUtils.createGButton("打开", 45, 25, 70, 15);
			addChild(_openBtn);

			_drawBtn = UICreateUtils.createGButton("选中", 45, 25, 130, 15);
			addChild(_drawBtn);

			_refreshBtn = UICreateUtils.createGButton("刷新", 45, 25, 190, 15);
			addChild(_refreshBtn);

			_clearBtn = UICreateUtils.createGButton("清空", 45, 25, 250, 15);
			addChild(_clearBtn);
			
			_detailBtn = UICreateUtils.createGButton("详情", 45, 25, 310, 15);
			addChild(_detailBtn);
		}

		private function addChildList() : void
		{
			var listData : GListData = new GListData();
			listData.x = 5;
			listData.y = 100;
			listData.width = 400;
			listData.height = 400;
			listData.allowDrag = false;
			listData.bgAsset = new AssetData(SkinStyle.emptySkin);
			listData.rows = 0;
			listData.padding = 2;
			listData.hGap = 5;
			listData.enabled = true;
			listData.scrollBarData.wheelSpeed = 9;

			listData.cell = DebugChildListCell;

			var cellData : GCellData = new GCellData();
			cellData.width = 200;
			cellData.height = 20;
			cellData.enabled = true;
			cellData.selected_upAsset = null;

			listData.cellData = cellData;
			_itemList = new GList(listData);
			_itemList.model.max = -1;
			addChild(_itemList);
		}

		private function addLabels() : void
		{
			_text = UICreateUtils.createTextField("当前子对象列表", null, 100, 25, 5, 80, UIManager.getTextFormat(12, 0xffff12, TextFormatAlign.CENTER));
			addChild(_text);
		}

		private function addItem() : void
		{
			refreshItemList(UIManager.root);
		}

		// // //////////////////////////////////////////////
		// 刷新
		// // /////////////////////////////////////////////
		private function refreshItemList(root : DisplayObjectContainer) : void
		{
			_root = root;
			_itemList.model.source = [];
			_num = 0;
			insertTargetName(root);
		}

		private function onItemSelect(event : DebugToolEvent) : void
		{
			_selectVO = event.vo;
			drawContainerBorder();
		}

		private function onBackBtnClick(event : MouseEvent) : void
		{
			if (_root.parent)
			{
				refreshItemList(_root.parent);
			}
		}

		private function onOpenBtnClick(event : MouseEvent) : void
		{
			if (_selectVO.objectContainer is DisplayObjectContainer)
				refreshItemList(_selectVO.objectContainer);
			_refreshVO = _selectVO;
		}

		private function onDrawBtnClick(event : MouseEvent) : void
		{
			drawContainerBorder();
		}

		private function onRefreshBtnClick(event : MouseEvent) : void
		{
			if (_refreshVO)
			{
				if (_refreshVO.objectContainer is DisplayObjectContainer)
					refreshItemList(_refreshVO.objectContainer);
			}
		}

		private function onClearClick(event : MouseEvent) : void
		{
			_drawSelArea.graphics.clear();
			if (_drawSelArea.parent)
				_drawSelArea.parent.removeChild(_drawSelArea);
			for (var i : int = 0;i < _itemList.content.numChildren;i++)
				(_itemList.content.getChildAt(i) as DebugChildListCell).clearSel();
		}

		private function onDetailBtnClick(event : MouseEvent) : void
		{
			if (_selectVO.objectContainer)
			{
				Logger.debug("numChildren: " + _selectVO.objectContainer.numChildren);
			}
				
		}

		override protected function onShow() : void
		{
			super.onShow();
			_itemList.addEventListener(DebugToolEvent.ITEMSELECT, onItemSelect);
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
			_openBtn.addEventListener(MouseEvent.CLICK, onOpenBtnClick);
			_drawBtn.addEventListener(MouseEvent.CLICK, onDrawBtnClick);
			_refreshBtn.addEventListener(MouseEvent.CLICK, onRefreshBtnClick);
			_clearBtn.addEventListener(MouseEvent.CLICK, onClearClick);
			_detailBtn.addEventListener(MouseEvent.CLICK, onDetailBtnClick);
		}

		override protected function onHide() : void
		{
			_itemList.removeEventListener(DebugToolEvent.ITEMSELECT, onItemSelect);
			_backBtn.removeEventListener(MouseEvent.CLICK, onBackBtnClick);
			_openBtn.removeEventListener(MouseEvent.CLICK, onOpenBtnClick);
			_drawBtn.removeEventListener(MouseEvent.CLICK, onDrawBtnClick);
			_refreshBtn.removeEventListener(MouseEvent.CLICK, onRefreshBtnClick);
			_clearBtn.removeEventListener(MouseEvent.CLICK, onClearClick);
			_detailBtn.addEventListener(MouseEvent.CLICK, onDetailBtnClick);
			super.onHide();
		}

		// // /////////////////////////////////////////////////////////
		// // //////方法
		// // ////////////////////////////////////////////////////
		private function drawContainerBorder() : void
		{
			if (!UIManager.root.stage.contains(_drawSelArea))
			{
				UIManager.root.stage.addChild(_drawSelArea);
			}

			// _drawSelArea.graphics.clear();
			_drawSelArea.graphics.lineStyle(4, 0xfff215);

			if (_selectVO.isContainer)
			{
				var object : DisplayObjectContainer = _selectVO.objectContainer;

				var pt : Point = new Point(object.x, object.y);
				pt = object.parent.localToGlobal(pt);

				_drawSelArea.graphics.drawRect(pt.x, pt.y, object.width, object.height);
			}
			else
			{
				var object1 : DisplayObject = _selectVO.displayObject;

				var pt1 : Point = new Point(object1.x, object1.y);
				pt = object1.parent.localToGlobal(pt1);

				_drawSelArea.graphics.drawRect(pt.x, pt.y, object1.width, object1.height);
			}
			_drawSelArea.graphics.endFill();
		}

		public function insertTargetName(target : DisplayObjectContainer) : void
		{
			forEachChildIn(target, insertTargetNameFunc, 0);
		}

		public function insertTargetNameFunc(target : DisplayObject, currentDepth : int) : Boolean
		{
			var vo : DebugToolVO = new DebugToolVO();
			_num = 0;
			if (target is DisplayObjectContainer)
			{
				vo.objectContainer = target as DisplayObjectContainer;
				vo.isContainer = true;
			}
			else if (target is DisplayObject)
			{
				vo.displayObject = target as DisplayObject;
				vo.isContainer = false;
			}

			vo.objectClass = getQualifiedClassName(target);
			vo.objectName = target.name;
			_itemList.model.insert(_num, vo);
			_num++;
			return true;
		}

		public function forEachChildIn(root : DisplayObjectContainer, func : Function, depth : int = 0, currentDepth : int = 0) : void
		{
			if (depth >= 0 && currentDepth > depth)
				return;

			var num : int = root.numChildren;

			for (var i : int = 0; i < num; i++)
			{
				var child : DisplayObject = root.getChildAt(i);
				if (func is Function)
				{
					if (!func(child, currentDepth))
						return;
				}

				if (child is DisplayObjectContainer)
				{
					forEachChildIn(child as DisplayObjectContainer, func, depth, currentDepth + 1);
				}
			}
		}
	}
}
