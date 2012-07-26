package com.commUI.button
{
	import gameui.controls.GRadioButton;
	import gameui.controls.GToggleBase;
	import gameui.core.GComponentData;
	import gameui.data.GRadioButtonData;
	import gameui.group.GToggleGroup;

	import com.commUI.icon.ItemIcon;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author yangyiqiang
	 */
	public class GItemRadioButton extends GToggleBase
	{
		private var _item : ItemIcon;
		private var _nameText : TextField;
		private var _button : GRadioButton;
		private var _free : Boolean;

		public function get button() : GRadioButton
		{
			return _button;
		}

		override public function set source(value : *) : void
		{
			_source = value;
			updateIcon();
			updateNameText();
		}

		override public function set group(value : GToggleGroup) : void
		{
			_button.group = value;
		}

		public function GItemRadioButton(freeBait : Boolean)
		{
			_free = freeBait;
			var data : GComponentData = new GComponentData();
			super(data);
		}

		override protected function create() : void
		{
			addIcon();
			addNameText();
			addRadioButton();
		}

		private function addIcon() : void
		{
			if (_free)
				_item = UICreateUtils.createItemIcon({x:0, y:0, showBorder:true, showBg:true, showRollOver:true, showToolTip:true});
			else
				_item = UICreateUtils.createItemIcon({x:0, y:0, showBorder:true, showBg:true, showShopping:true, showRollOver:true, showToolTip:true, showNums:true, shopMinLimit:1});
			addChild(_item);
		}

		private function addNameText() : void
		{
			_nameText = UICreateUtils.createTextField(null, null,70, 20, -9, 49, TextFormatUtils.panelContentCenter);
			addChild(_nameText);
		}

		private function addRadioButton() : void
		{
			_button = new GRadioButton(new GRadioButtonData());
			_button.x = 17;
			_button.y = 65;
			addChild(_button);
		}

		override protected function onSelect() : void
		{
			_button.selected = _selected;
		}

		private function updateIcon() : void
		{
			_item.source = _source;
		}

		private function updateNameText() : void
		{
			_nameText.htmlText = _source["htmlName"];
		}

		override protected function onShow() : void
		{
			super.onShow();
			_item.addEventListener(MouseEvent.CLICK, baitIcon_clickHandler);
		}

		override protected function onHide() : void
		{
			_item.removeEventListener(MouseEvent.CLICK, baitIcon_clickHandler);
			super.onHide();
		}

		private function baitIcon_clickHandler(event : MouseEvent) : void
		{
			_button.selected = true;
		}
	}
}
