package game.core.avatar {
	import game.core.user.UserData;
	import game.module.bossWar.BossWarSystem;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarPlayer extends AvatarThumb {
		override protected function changeType(value : int) : Boolean {
			if (super.changeType(value)) {
				if (value == 0) {
					this.scaleX = 1;
					this.scaleY = 1;
				} else {
					this.scaleX = 0.9;
					this.scaleY = 0.9;
				}
				if (_name!=""&&_name!=null)
					setName(_name, _color);
				return true;
			}
			return false;
		}

		override protected function updateDisplays() : void {
			if (!_avatarBd) return;
			if (_currentAction.action == AvatarManager.PRACTICE) {
				_nameBitMap.x = _avatarBd.topX;
				return;
			}
			_lastY = _avatarBd.topY + 10;
			if (_seat) _lastY = _lastY + _seat.avatarBd.topY;
			if (_progressBar) {
				_progressBar.x = -33;
				_progressBar.y = _lastY;
				_lastY -= 20;
			}
			_nameBitMap.x = _avatarBd.topX;
			_nameBitMap.y = _lastY;
			_lastY -= 20;
			if (_clanBitMap) {
				_clanBitMap.x = _avatarBd.topX;
				_clanBitMap.y = _lastY;
				_lastY -= 20;
			}
			if (_stateObj) {
				_stateObj.x = -_stateObj.width / 2;
				_stateObj.y = _lastY ;
				_lastY -= 20;
			}
		}

		override protected function toDirection(angle : Number, isRun : Boolean = false) : void {
			changeType(AvatarType.PLAYER_RUN);
			super.toDirection(angle, isRun);
		}

		override public function addSeat(seatId : int) : void {
			if (_seat) AvatarManager.instance.removeAvatar(_seat);
			_seat = AvatarManager.instance.getAvatar(seatId, AvatarType.SEAT_TYPE) as AvatarSeat;
			_seat.avatarBd.addEventListener(Event.COMPLETE, onComplete);
			addChild(_seat);
			player.y = _seat.avatarBd.topY;
			super.addChild(player);
			updateDisplays();
		}

		private function onComplete(event : Event) : void {
			if (_seat) {
				_seat.avatarBd.removeEventListener(Event.COMPLETE, onComplete);
				player.y = _seat.avatarBd.topY;
			}
			updateDisplays();
		}

		override public function removeSeat() : void {
			if (_seat) {
				AvatarManager.instance.removeAvatar(_seat);
				if (_seat.parent) _seat.parent.removeChild(_seat);
			}
			_seat = null;
			player.x = 0;
			player.y = 0;
			updateDisplays();
		}

		private var _color : String = "#ffee00";

		override public function setName(name : String, color : String = "#ffee00") : void {
			_color = color;
			super.setName(name, color);
		}

		/** 站立 */
		override  public function stand() : void {
			changeType(AvatarType.PLAYER_RUN);
			setAction(_direction);
		}

		override public function setAction(value : int, loop : int = 0, index : int = -1, arr : Array = null, onComplete : Function = null, onCompleteParams : Array = null) : void {
			if (value == AvatarManager.PRACTICE && _avatarBd) {
				_nameBitMap.y = Math.abs(_avatarBd.topY) / 4 * -3 + 10;
			} else if (_currentAction.action == AvatarManager.PRACTICE) {
				super.setAction(value, loop, index, arr);
				updateDisplays();
				return;
			}
			super.setAction(value, loop, index, arr, onComplete, onCompleteParams);
		}

		override protected function onMouseClick(event : MouseEvent) : void {
			if (_name == UserData.instance.playerName)
				return;
			if (isBody(event.localX, event.localY)) {
				// dispatchEvent(new Event("clickPlayer", true));
				event.stopPropagation();
			}
		}

		public function isBody(x : int, y : int) : Boolean {
			return  (player.getBitMap().bitmapData && player.getBitMap().bitmapData.hitTest(new Point(player.getBitMap().x, player.getBitMap().y), 255, AvatarManager.hitTest, new Point(x, y)));
		}

		override protected function addShodow() : void {
			super.addShodow();
			_shodow.scaleX = 0.5;
			_shodow.scaleY = 0.5;
			_shodow.x = -29;
			_shodow.y = -12;
		}

		override protected function change(type : int = 1) : void {
			super.change(type);
			if (type == 0) {
				_shodow.scaleX = 1;
				_shodow.scaleY = 1;
				_shodow.x = -_shodow.width ;
				_shodow.y = -_shodow.height ;
			} else {
				_shodow.scaleX = 0.5;
				_shodow.scaleY = 0.5;
				_shodow.x = -29;
				_shodow.y = -12;
			}
		}

		private var _recoverList : Array = [];

		override public function addChild(obj : DisplayObject) : DisplayObject {
			_recoverList.push(obj);
			return super.addChild(obj);
		}

		override public function addChildAt(obj : DisplayObject, index : int) : DisplayObject {
			_recoverList.push(obj);
			return super.addChildAt(obj, index);
		}

		override internal function reset() : void {
			super.reset();
			for each (var obj:DisplayObject in _recoverList) {
				if (obj && obj.parent) obj.parent.removeChild(obj);
			}
			_recoverList = [];
		}

		public function AvatarPlayer() {
			super();
		}
	}
}
