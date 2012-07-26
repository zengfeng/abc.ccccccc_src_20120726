package com.commUI.pager
{
	import com.utils.FilterUtils;
	import flash.text.TextFieldAutoSize;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.definition.UI;
	import gameui.cell.GCell;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;
	import net.AssetData;






	/**
	 * @author qiujian
	 */
	public class PagerCell extends GCell
	{
		// =====================
		// 属性
		// =====================
		private var _page : int;
		private var _textField : TextField;

		// =====================
		// 方法
		// =====================
		public function PagerCell(data : PagerCellData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			addTextField();
		}

		private function addTextField() : void
		{
			_textField = UICreateUtils.createTextField(null, null, 45.5, 20, 1, 0, TextFormatUtils.panelContent);
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.wordWrap = false;
			addChild(_textField);
		}

		public function set page(value : int) : void
		{
			_page = value;
		}

		public function set text(value : String) : void
		{
			_textField.text = value;
			layout();
		}
		
		public function get text():String
		{
			return _textField.text;
		}

		override public function set selected(value : Boolean) : void
		{
			if (type == PagerCellData.NUMBER)
			{
				super.selected = value;
				var format : TextFormat = new TextFormat();
				format.bold = value;
				_textField.setTextFormat(format);
				layout();
			}
		}

		public function get page() : int
		{
			return _page;
		}

		public function get type() : int
		{
			return (_data as PagerCellData).type;
		}

		override protected function layout() : void
		{
			_width = _textField.textWidth + 6;
			_textField.width = _width;

			super.layout();
		}
		
		override protected function onEnabled():void
		{
			super.onEnabled();
			
			if (_enabled)
			{
				filters = [];
			}
			else
			{
				filters = [FilterUtils.disableFilter()];
			}
		}
	}
}
