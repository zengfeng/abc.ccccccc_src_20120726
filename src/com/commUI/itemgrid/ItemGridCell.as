package com.commUI.itemgrid
{
	import com.commUI.icon.ItemIcon;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.TextFormatUtils;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.core.item.Item;



	/**
	 * @author jian
	 */
	public class ItemGridCell extends GridCell
	{
		// =====================
		// Attribute
		// =====================
		private var _data : ItemGridCellData;
		protected var _source : Item;
		private var _nameText : TextField;

		// =====================
		// getter/setter
		// =====================
		public function get source() : Item
		{
			return _source;
		}

		public function set source(value : Item) : void
		{
			if (value)
			{
				(itemDO as ItemIcon).source = value;
				mouseEnabled = true;
				if (_data.showName)
					_nameText.htmlText = value.htmlName;
			}
			else
			{
				(itemDO as ItemIcon).source = null;
				mouseEnabled = false;
				if (_data.showName)
					_nameText.htmlText = "";
			}

			if (_data.fakeRollOut)
				ToolTipManager.instance.refreshToolTip(itemDO as ItemIcon);

			_source = value;
		}

		public function get position() : int
		{
			return row * col;
		}

		// =====================
		// Method
		// =====================
		public function ItemGridCell(data : ItemGridCellData)
		{
			_data = data;

			itemDO = new ItemIcon(data.iconData);

			if (_data.showName)
				addNameText();
		}

		private function addNameText() : void
		{
			_nameText = new TextField();
			_nameText.defaultTextFormat = TextFormatUtils.panelContentCenter;
			_nameText.x = 0;
			_nameText.y = 55;
			_nameText.width = width;
			addChild(_nameText);
		}
		
		public function selectCell():void
		{
			if (_source)
			{
				var e : ItemCellEvent = new ItemCellEvent(ItemCellEvent.SELECT);
				e.item = _source;
				dispatchEvent(e);
			}			
		}

		// ------------------------------------------------
		// Events
		// ------------------------------------------------
		override protected function onShow() : void
		{
			if (_data.allowSelect)
				addEventListener(MouseEvent.CLICK, clickHandler);
		}

		override protected function onHide() : void
		{
			if (_data.allowSelect)
				removeEventListener(MouseEvent.CLICK, clickHandler);
		}

		private function clickHandler(event : MouseEvent) : void
		{
			event.stopPropagation();

			selectCell();
		}
	}
}
