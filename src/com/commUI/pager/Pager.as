package com.commUI.pager {
	import gameui.cell.LabelSource;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author zheng
	 */
	public class Pager extends GPanel
	{
		// =====================
		// @属性
		// =====================
		private var _model : PagerModel;
		private var _labelFirstPage : PagerCell;
		private var _labelNextPage : PagerCell;
		private var _labelPrePage : PagerCell;
		private var _labelNumPages : Array /* of PagerLabel */;
		private var _labelList : Array /* of PagerLabel */;
		private var _passive : Boolean;

		// =====================
		// @公共
		// =====================
		public function Pager(size : int, passive : Boolean = false)
		{
			_model = new PagerModel(size);
			_passive = passive;

			_data = new GPanelData();
			_data.height = 20;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(_data);
		}

		public function setPage(page : int, total : int = -1) : void
		{
			if (total != -1 && page > total)
				page = total;
			_model.page = page;
			if (total != -1) _model.total = total;

			updateView();
		}

		public function get model() : PagerModel
		{
			return _model;
		}

		// =====================
		// @创建
		// =====================
		override protected function create() : void
		{
			super.create();

			var dataFirst : PagerCellData = new PagerCellData();
			dataFirst.type = PagerCellData.FIRST;
			_labelFirstPage = new PagerCell(dataFirst);
			_labelFirstPage.text = "首页";
			_content.addChild(_labelFirstPage);

			var dataNext : PagerCellData = new PagerCellData();
			dataNext.type = PagerCellData.NEXT;
			_labelNextPage = new PagerCell(dataNext);
			_labelNextPage.text = "下一页";
			_content.addChild(_labelNextPage);

			var dataPre : PagerCellData = new PagerCellData();
			dataPre.type = PagerCellData.PREVIOUS;
			_labelPrePage = new PagerCell(dataPre);
			_labelPrePage.text = "上一页";
			_content.addChild(_labelPrePage);

			_labelNumPages = [];
			for (var i : uint = 0;i < _model.size;i++)
			{
				var dataNum : PagerCellData = new PagerCellData();
				dataNum.type = PagerCellData.NUMBER;
				var labelNumPage : PagerCell = new PagerCell(dataNum);
				_labelNumPages.push(labelNumPage);
				_content.addChild(labelNumPage);
			}
		}

		// =====================
		// @更新
		// =====================
		private function updateView() : void
		{
			_model.updateModel();
			
			_labelList = [];
			if (_model.moreLeft)
			{
				_labelFirstPage.visible = true;
				_labelList.push(_labelFirstPage);
			}
			else
			{
				_labelFirstPage.visible = false;
			}

			if (!_model.hitLeft)
			{
				_labelPrePage.visible = true;
				_labelList.push(_labelPrePage);
			}
			else
			{
				_labelPrePage.visible = false;
			}

			var i : uint = 0;
			for each (var labelSource:LabelSource in _model.labels)
			{
				var labelNumPage : PagerCell = _labelNumPages[i] as PagerCell;
				labelNumPage.text = labelSource.text;
				labelNumPage.page = labelSource.value;
				labelNumPage.visible = true;
				labelNumPage.selected = labelSource.value == _model.page;
				_labelList.push(labelNumPage);
				i++;
			}

			for (;i < _model.size;i++)
			{
				var unUsedPage : PagerCell = _labelNumPages[i] as PagerCell;
				unUsedPage.visible = false;
			}

			if (!_model.hitRight)
			{
				_labelNextPage.visible = true;
				_labelList.push(_labelNextPage);
			}
			else
			{
				_labelNextPage.visible = false;
			}

			layout();
		}

		public function get labelList() : Array
		{
			return _labelList;
		}

		public function selectPage(page : uint) : void
		{
			_model.page = page;
			if (!_passive) updateView();

			var event : Event = new Event(Event.CHANGE);
			dispatchEvent(event);
		}

		override protected function layout() : void
		{
//			_labelFirstPage.x = 0;
//			_labelPrePage.x = _labelFirstPage.x + _labelFirstPage.width + 2;
//			
			var posX : Number = 0;//_labelPrePage.width + 2;

			for each (var pagerLabel:PagerCell in _labelList)
			{
				pagerLabel.x = posX;
				posX += pagerLabel.width + 2;
			}
		}
		
		override public function get width():Number
		{
			var width:Number = 0;
			for each (var pagerLabel:PagerCell  in _labelList)
			{
				width += pagerLabel.width + 2;
			}
			return width;
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		override protected function onHide() : void
		{
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			super.onHide();
		}

		private function onMouseClick(event : MouseEvent) : void
		{
			if (!(event.target is PagerCell)) return;

			var pagerLabel : PagerCell = event.target as PagerCell;
			switch(pagerLabel.type)
			{
				case PagerCellData.FIRST:
					selectPage(_model.first);
					break;
				case PagerCellData.PREVIOUS:
					selectPage(_model.previous);
					break;
				case PagerCellData.NEXT:
					selectPage(_model.next);
					break;
				case PagerCellData.NUMBER:
					selectPage(pagerLabel.page);
					break;
			}

			event.stopPropagation();
		}
	}
}
