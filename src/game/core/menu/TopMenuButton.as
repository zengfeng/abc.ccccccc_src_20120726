package game.core.menu {
	import framerate.SecondsTimer;

	import game.core.avatar.AvatarManager;
	import game.core.user.StateManager;

	import gameui.controls.BDPlayer;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.TimeUtil;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author yangyiqiang
	 */
	public class TopMenuButton extends MenuButton {
		public function TopMenuButton(data : GButtonData, vo : VoMenuButton, type : int = 0) {
			super(data, vo, type);
		}

		override protected function onClick(event : MouseEvent) : void {
			if (_timerStr) {
				if (_timer > 0) {
					StateManager.instance.checkMsg(354);
				} else {
					// Common.game_server.sendMessage(0x75);
					super.onClick(event);
				}
			} else {
				super.onClick(event);
			}
		}

		private var _num : int = 1;
		private var _numTextFile : TextField;
		private var _sprite : Sprite;

		public function updateNum(value : int = 1, isRemove : Boolean = true) : void {
			if (isRemove)
				_num -= value;
			else
				_num = value;
			_num = _num > 99 ? 99 : _num;
			if (_vo.type == 5 && _num > 1) {
				if (!_sprite) {
					_sprite = UIManager.getUI(new AssetData("numberMount"));
				}
				if (!_numTextFile)
					_numTextFile = UICreateUtils.createTextField(String(_num), null, 20, 20, 40, -1, UIManager.getTextFormat(12, 0x2f1f00, TextFormatAlign.CENTER));
				addChild(_sprite);
				addChild(_numTextFile);
				layout();
			} else if (_num <= 1) {
				if (_numTextFile)
					_numTextFile.text = "";
				if (_sprite && _sprite.parent)
					_sprite.parent.removeChild(_sprite);
			}
		}

		private var _timer : int;
		private var _timerStr : TextField;

		public function updataTime(value : int, tips : String = null) : void {
			if (!_timerStr) {
				_timerStr = UICreateUtils.createTextField(TimeUtil.toHHMMSS(_timer), null, 60, 20, -5, 58, UIManager.getTextFormat(12, 0xffffff,TextFormatAlign.CENTER));
				_timerStr.filters = UIManager.getEdgeFilters();
				addChild(_timerStr);
			}
			if (value > 1) {
				_timer = value - 1;
				SecondsTimer.addFunction(updataTimerStr);
				createEffect(false);
			} else {
				_timerStr.text = "可领取";
				SecondsTimer.removeFunction(updataTimerStr);
				createEffect();
			}
			if (tips != null) {
				this.toolTip.source = tips;
			} else {
				this.toolTip.source = _vo.tips;
			}
		}

		private var _effect : BDPlayer;

		private function createEffect(show : Boolean = true) : void {
			if (show) {
				if (!_effect) {
					_effect = AvatarManager.instance.getCommBDPlayer(AvatarManager.COMM_CIRCLEEFFECT, new GComponentData());
					_effect.x = 25;
					_effect.y = 28;
					_effect.scaleX = 0.7 ;
					_effect.scaleY = 0.7 ;
					_effect.mouseChildren = false;
					_effect.mouseEnabled = false;
				}
				_effect.play(80,null,0);
				addChildAt(_effect, 0);
			} else {
				if (_effect && _effect.parent) {
					_effect.stop();
					_effect.parent.removeChild(_effect);
				}
			}
		}

		private function updataTimerStr() : void {
			_timer--;
			if (_timer > 0) {
				_timerStr.text = TimeUtil.toHHMMSS(_timer);
			} else {
				_timerStr.text = "可领取";
				SecondsTimer.removeFunction(updataTimerStr);
				createEffect();
			}
		}

		override protected function onShow() : void {
			super.onShow();
			if (_effect) {
				_effect.play(80,null,0);
			}
		}

		override protected function onHide() : void {
			super.onHide();
		}
	}
}
