package com.commUI.labelButton
{
	import gameui.controls.GLabel;
	import gameui.core.GComponent;
	import gameui.core.PhaseState;
	import gameui.data.GButtonData;
	import gameui.layout.GLayout;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * Game Button
	 * 
	 */
	public class LabelButton extends GComponent
	{
		protected var _data : LabelButtonData;
		protected var _label : GLabel;
		protected var _upLabel : GLabel;
		protected var _overLabel : GLabel;
		protected var _phase : int = PhaseState.UP;
		protected var _viewRect : Rectangle = new Rectangle();

		override protected function create() : void
		{
			_data.upLabelData.width = _data.width;
			_data.overLabelData.width = _data.width;
			_upLabel = new  GLabel(_data.upLabelData);
			_overLabel = new GLabel(_data.overLabelData);
			_label = _upLabel;
			addChild(_label);

			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			tabEnabled = false;
		}

		override protected function layout() : void
		{
			GLayout.layout(_label);
		}

		override protected function onEnabled() : void
		{
			_label.enabled = _enabled;
			viewSkin();
		}

		override protected  function onShow() : void
		{
			super.onShow();
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			viewSkin();
		}

		override protected function onHide() : void
		{
			super.onHide();
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_phase = PhaseState.UP;
		}

		public function set phase(value : int) : void
		{
			_phase = value;
			viewSkin();
		}

		protected function rollOverHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = PhaseState.OVER;
			viewSkin();
		}

		protected function rollOutHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = PhaseState.UP;
			viewSkin();
		}

		protected function mouseDownHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = PhaseState.DOWN;
			viewSkin();
		}

		protected function mouseUpHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = ((event.currentTarget == this) ? PhaseState.OVER : PhaseState.UP);
			viewSkin();
		}

		protected function viewSkin() : void
		{
			if (!_enabled)
			{
			}
			else if (_phase == PhaseState.UP)
			{
				_label = swap(_label, _upLabel) as GLabel;
			}
			else if (_phase == PhaseState.OVER)
			{
				_label = swap(_label, _overLabel) as GLabel;
			}
			else if (_phase == PhaseState.DOWN)
			{
			}
			layout();
		}

		public function LabelButton(data : LabelButtonData)
		{
			_data = data;
			super(data);
		}

		public function set text(value : String) : void
		{
			_upLabel.text = value;
			_overLabel.text = value;
			layout();
		}

		public function set htmlText(value : String) : void
		{
			_upLabel.htmlText = value;
			_overLabel.htmlText = value;
			layout();
		}

		public function get label() : GLabel
		{
			return _label;
		}
	}
}
