package com.commUI
{
	import flash.display.DisplayObject;

	import gameui.controls.GLabel;
	import gameui.data.GLabelData;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jian
	 */
	public class IconLabel extends Sprite
	{
		// =====================
		// 属性
		// =====================
		protected var _data : GLabelData;
		protected var _icon : DisplayObject;
		protected var _label : GLabel;
		protected var _hgap : Number = 0;
		protected var _iconX : Number = 0;
		protected var _iconY : Number = 0;
		protected var _showIcon : Boolean = true;

		// =====================
		// setter/getter
		// =====================
		public function set icon(value : DisplayObject) : void
		{
			if (_icon == value)
				return;

			if (_icon && contains(_icon))
				removeChild(_icon);

			_icon = value;

			updateIcon();
		}

		public function set hgap(value : Number) : void
		{
			if (_hgap == value)
				return;

			_hgap = value;

			layout();
		}

		public function set iconY(value : Number) : void
		{
			if (_iconY == value)
				return;

			_iconY = value;

			layout();
		}

		public function set iconX(value : Number) : void
		{
			if (_iconX == value)
				return;
			_iconX = value;
			layout();
		}

		public function set text(value : String) : void
		{
			_label.text = value;
		}

		public function set htmlText(value : String) : void
		{
			_label.htmlText = value;
		}

		public function set showIcon(value : Boolean) : void
		{
			_showIcon = value;

			updateIcon();
		}

		// =====================
		// 方法
		// =====================
		public function IconLabel(data : GLabelData)
		{
			_data = data;

			create();
			layout();

			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromeStageHandler);
		}

		protected function create() : void
		{
			_label = new GLabel(_data);
			addChild(_label);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateIcon() : void
		{
			if (!_icon)
				return;

			if (_showIcon && !contains(_icon))
			{
				addChild(_icon);
			}
			else if (!_showIcon && contains(_icon))
			{
				removeChild(_icon);
			}

			layout();
		}

		protected function layout() : void
		{
			if (_showIcon && _icon)
			{
				_icon.x = _iconX;
				_icon.y = _iconY;
				_label.x = _icon.x + _icon.width + _hgap;
			}
			else
			{
				_label.x = 0;
			}
		}

		private function addedToStageHandler(event : Event) : void
		{
			onShow();
		}

		protected function onShow() : void
		{
		}

		private function removedFromeStageHandler(event : Event) : void
		{
			onHide();
		}

		protected function onHide() : void
		{
		}
	}
}
