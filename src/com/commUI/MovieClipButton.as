package com.commUI
{
	import gameui.core.GComponent;
	import gameui.core.PhaseState;
	import gameui.core.ScaleMode;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.RESManager;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jian
	 */
	public class MovieClipButton extends GComponent
	{
		// =====================
		// 属性
		// =====================
		protected var _data : GButtonData;
		protected var _upSkin : Sprite;
		protected var _overSkin : Sprite;
		protected var _downSkin : Sprite;
		protected var _disabledSkin : Sprite;
		protected var _current : Sprite;
		protected var _phase : int = PhaseState.UP;
		protected var _playingPhase : int = PhaseState.UP;
		protected var _playing : Boolean = false;

		// =====================
		// 方法
		// =====================
		public function MovieClipButton(data : GButtonData)
		{
			_data = data;
			super(data);
		}

		override protected function create() : void
		{
			_upSkin = UIManager.getUI(_data.upAsset);
			_overSkin = UIManager.getUI(_data.overAsset);
			_downSkin = UIManager.getUI(_data.downAsset);
			_disabledSkin = UIManager.getUI(_data.disabledAsset);
			_current = _overSkin;
			addChild(_current);

			switch(_data.scaleMode)
			{
				case ScaleMode.SCALE_WIDTH:
					_height = _upSkin.height;
					break;
				case ScaleMode.SCALE_NONE:
					_width = _upSkin.width;
					_height = _upSkin.height;
					break;
			}
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			tabEnabled = false;
		}

//		override protected function layout() : void
//		{
//			_upSkin.width = _width;
//			_upSkin.height = _height;
//			if (_overSkin != null)
//			{
//				_overSkin.width = _width;
//				_overSkin.height = _height;
//			}
//			if (_downSkin != null)
//			{
//				_downSkin.width = _width;
//				_downSkin.height = _height;
//			}
//		}

		override protected function onEnabled() : void
		{
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
			_playing = false;
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
			if (_playing)
				return;

			if (!_enabled)
			{
				_current = swap(_current, _disabledSkin);
			}
			else if (_phase == PhaseState.UP)
			{
				_current = swap(_current, _upSkin);
			}
			else if (_phase == PhaseState.OVER)
			{
				_current = swap(_current, _overSkin);
			}
			else if (_phase == PhaseState.DOWN)
			{
				_current = swap(_current, _downSkin);
			}
			
			if (_current is MovieClip)
			{
//				//trace("Playing start " + _phase);
				_playingPhase = _phase;
				_current.addEventListener(Event.COMPLETE, currentMC_completeHandler);
				_playing = true;
				(_current as MovieClip).gotoAndPlay(1);
			}
		}

		private function currentMC_completeHandler(event : Event) : void
		{
			_playing = false;
			
			var target:MovieClip = event.target as MovieClip;
			target.removeEventListener(Event.COMPLETE, currentMC_completeHandler);
			target.stop();
			
//			//trace("Playing end " + _playingPhase);
			if (_playingPhase != _phase)
			{
//				//trace("Pending phase " + _playingPhase);
				viewSkin();
			}
		}
	}
}
