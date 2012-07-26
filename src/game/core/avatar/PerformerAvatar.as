package game.core.avatar {
	import game.core.user.UserData;
	import game.manager.RSSManager;
	import game.module.quest.VoNpc;

	import gameui.controls.BDPlayer;
	import gameui.core.GComponentData;

	import log4a.Logger;

	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import com.greensock.TweenLite;
	import com.utils.UrlUtils;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class PerformerAvatar extends AvatarThumb {
		private var _npcVo : VoNpc;
		private var _npcId : int;

		public function setId(value : int) : void {
			if (value == 0) {
				super.initAvatar(UserData.instance.myHero.id, AvatarType.PLAYER_RUN, AvatarMySelf.instance.cloth);
				setName(UserData.instance.playerName);
				return ;
			}
			_npcId = value;
			_npcVo = RSSManager.getInstance().getNpcById(value);
			if (!_npcVo) {
				Logger.debug("PerformerAvatar中value= " + value + " 的npc或者怪物没找到!");
				return;
			}
			checkStyle();
			updateDisplays();
		}

		public function get npcId() : int {
			return _npcId;
		}

		override protected function toDirection(angle : Number, isRun : Boolean = false) : void {
			if (_type != AvatarType.PLAYER_RUN) return;
			super.toDirection(angle, isRun);
		}

		override protected function change(type : int = 1) : void {
		}

		override protected function addShodow() : void {
		}

		private var _isMc : Boolean = false;

		override public function setAction(value : int, loop : int = 0, index : int = 0, arr : Array = null, onComplete : Function = null, onCompleteParams : Array = null) : void {
			if (_isMc) {
				if (_mc)
					_mc.gotoAndPlay(1);
				return;
			}
			super.setAction(value, _isOne ? 1 : loop, index, arr, onComplete, onCompleteParams);
		}

		private function actionComplete(event : Event) : void {
			this.player.removeEventListener(Event.COMPLETE, actionComplete);
			setAction(AvatarManager.BT_STAND, 0);
		}

		override public  function addSeat(id : int) : void {
			if (!_seat) {
				_seat = AvatarManager.instance.getAvatar(id, AvatarType.SEAT_TYPE) as AvatarSeat;
			}
			_seat.avatarBd.addEventListener(Event.COMPLETE, onComplete);
			addChild(_seat);
			player.y = _seat.avatarBd.topY;
			super.addChild(player);
			updateDisplays();
		}

		private function onComplete(event : Event) : void {
			_seat.avatarBd.removeEventListener(Event.COMPLETE, onComplete);
			player.y = _seat.avatarBd.topY;
			updateDisplays();
		}

		override public  function removeSeat() : void {
			updateDisplays();
		}

		override protected function updateDisplays() : void {
			if (!_avatarBd) return;
			_lastY = _avatarBd.topY + 10;
			if (_seat) _lastY = _lastY + _seat.avatarBd.topY;
			if (_progressBar) {
				_progressBar.x = -33;
				_progressBar.y = _lastY;
				_lastY -= 20;
			}
			_nameBitMap.x = _avatarBd.topX * this.scaleX;
			if (_currentAction.action == AvatarManager.PRACTICE) {
				_nameBitMap.y = Math.abs(_avatarBd.topY) / 4 * -3 + 10;
			} else
				_nameBitMap.y = _lastY * this.scaleY;
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

		private var _mc : MovieClip;
		private var _isOne : Boolean = false;
		private var _showName : Boolean = true;

		private function checkStyle() : void {
			_isOne = false;
			this.blendMode = _npcVo.blendMode;
			if (_npcVo.id < 4000) {
				super.initAvatar(_npcVo.avatarId, AvatarType.NPC_TYPE);
				setName(_npcVo.name);
				switch((_npcVo as VoNpc).type) {
					case 3:
						_showName = false;
						setName("");
						break;
					case 4:
						_showName = false;
						setName("");
						_mc = RESManager.getLoader(String(_uuid)) ? RESManager.getLoader(String(_uuid)).getContent() as MovieClip : null;
						if (!_mc) {
							RESManager.instance.load(new LibData(UrlUtils.getAvatar(_uuid), String(_uuid)), onComplete2);
							return;
						}
						this.addChild(_mc);
						_mc.scaleX = _npcVo.flipH ? -1 : 1;
						player.hide();
						this.scaleX = 1;
						this.scaleY = 1;
						_isMc = true;
						return;
					case 5:
						_showName = false;
						setName("");
						_isOne = true;
						break;
				}
				player.flipH = _npcVo.flipH;

				this.scaleX = 1;
				this.scaleY = 1;
				return;
			} else {
				super.initAvatar(_npcVo.avatarId, AvatarType.MONSTER_TYPE);
				this.player.scaleX = 0.8;
				this.player.scaleY = 0.8;
			}
			this._nameBitMap.smoothing = true;
			setName(_npcVo.name);
		}

		private function onComplete2() : void {
			var load : SWFLoader = RESManager.getLoader(String(_uuid));
			if (!load) return;
			_mc = RESManager.getLoader(String(_uuid)).getContent() as MovieClip;
			this.addChild(_mc);
			_mc.scaleX = _npcVo.flipH ? -1 : 1;
			player.hide();
			this.scaleX = 1;
			this.scaleY = 1;
			_isMc = true;
		}

		/**
		 * 1-8   人站立时的8个面向
		 * 10    第二种动作
		 * 11 ,13(翻转) 正面战斗待机
		 * 12 ,14(翻转) 反面战斗待机
		15, 翻转
		16，不翻转
		 * 20,打坐
		 * 22,隐藏
		 * 23,出现
		 */
		public function setAvatarState(state : int) : void {
			this.visible = true;
			switch(state) {
				case 1:
					checkAvatarType();
					player.flipH = false;
					setAction(3);
					break;
				case 2:
					checkAvatarType();
					player.flipH = false;
					setAction(2);
					break;
				case 3:
					checkAvatarType();
					player.flipH = false;
					setAction(1);
					break;
				case 4:
					checkAvatarType();
					player.flipH = true;
					setAction(2);
					break;
				case 5:
					checkAvatarType();
					player.flipH = true;
					setAction(3);
					break;
				case 6:
					checkAvatarType();
					player.flipH = true;
					setAction(4);
					break;
				case 7:
					checkAvatarType();
					player.flipH = false;
					setAction(5);
					break;
				case 8:
					checkAvatarType();
					player.flipH = false;
					setAction(4);
					break;
				case 10:
					setAction(2, 1, 0);
					break;
				case 11:
					player.flipH = true;
					fontReadyBattle();
					break;
				case 12:
					player.flipH = true;
					backReadyBattle();
					break;
				case 13:
					player.flipH = false;
					fontReadyBattle();
					break;
				case 14:
					player.flipH = true;
					backReadyBattle();
					break;
				case 15:
					if (_isMc && _mc) {
						_mc.scaleX = -1;
					} else
						player.flipH = true;
					break;
				case 16:
					if (_isMc && _mc)
						_mc.scaleX = 1;
					else
						player.flipH = false;
					break;
				case 20:
					checkAvatarType();
					sitdown();
					_nameBitMap.y = Math.abs(_avatarBd.topY) / 4 * -3 + 30;
					break;
				case 21:
					die();
					break;
				case 22:
					// 隐藏
					this.visible = false;
					break;
				case 23:
					// 出现
					this.visible = true;
					this.setAction(1, 0, 0);
					break;
			}
			this.scaleX = 0.91;
			this.scaleY = 0.91;
			if (_npcId > 4000) {
				this.player.scaleX = this.player.scaleX > 0 ? 0.8 : -0.8;
				this.player.scaleY = 0.8;
			} else {
				if (_type == AvatarType.PLAYER_BATT_BACK || _type == AvatarType.PLAYER_BATT_FRONT) {
					this.player.scaleX = this.player.scaleX > 0 ? 0.91 : -0.91;
					this.player.scaleY = 0.91;
				} else {
					this.player.scaleX = this.player.scaleX > 0 ? 1 : -1;
					this.player.scaleY = 1;
				}
			}
			if (_showName) {
				this._nameBitMap.scaleX = 1;
				this._nameBitMap.scaleY = 1;
				setName(_name);
			}
		}

		private function checkAvatarType() : void {
			if (_type == AvatarType.PLAYER_BATT_BACK || _type == AvatarType.PLAYER_BATT_FRONT)
				changeType(AvatarType.PLAYER_RUN);
		}

		public function hurt() : void {
			setAction(AvatarManager.HURT, 1);
		}

		private var _diePlay : BDPlayer;

		override public function die() : void {
			_diePlay = new BDPlayer(new GComponentData());
			_diePlay.setBDData(AvatarManager.instance.getDie());
			addChild(_diePlay);
			_diePlay.addEventListener(Event.COMPLETE, dieComplete);
			_diePlay.play(30);
			player.stop();
			TweenLite.to(player, 0.6, {alpha:0, overwrite:0});
			if (_progressBar)
				TweenLite.to(_progressBar, 0.6, {alpha:0, overwrite:0});
			if (_nameBitMap)
				TweenLite.to(_nameBitMap, 0.6, {alpha:0, overwrite:0});
		}

		private function dieComplete(event : Event) : void {
			_diePlay.stop();
			_diePlay.removeEventListener(Event.COMPLETE, dieComplete);
			hide();
		}

		public function PerformerAvatar() {
			super();
			this.mouseEnabled = true;
			this.mouseChildren = true;
			this.player.addEventListener(Event.COMPLETE, actionComplete);
		}

		override internal function reset() : void {
			super.reset();
			_isMc = false;
			if (_mc) _mc.stop();
			super.addChild(player);
			for each (var obj:DisplayObject in _recoverList) {
				if (obj && obj.parent) obj.parent.removeChild(obj);
			}
			_recoverList = [];
		}

		/** 回收 */
		override internal function callback() : void {
			reset();
			dispose();
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

		public function resetTo() : void {
			reset();
		}

		override protected function onShow() : void {
			super.onShow();
		}

		override protected function onHide() : void {
			super.onHide();
		}
	}
}
