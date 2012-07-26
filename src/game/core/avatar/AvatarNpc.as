package game.core.avatar {
	import framerate.SecondsTimer;

	import game.manager.MouseManager;
	import game.manager.RSSManager;
	import game.module.quest.VoNpc;

	import gameui.controls.BDPlayer;
	import gameui.controls.GTextArea;
	import gameui.core.GComponentData;
	import gameui.data.GTextAreaData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import com.utils.StringUtils;
	import com.utils.UrlUtils;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarNpc extends AvatarThumb implements IAvatarBase {
		/** 可接 */
		public static const CAN_ACCEPT : int = 1;
		/** 无状态 */
		public static const NOTHING : int = 0;
		/** 任务状态 */
		private var _questState : int;
		private var _statePlayer : BDPlayer;
		public static const NPC_STAND : int = 1;
		public static const NPC_ACTION : int = 2;

		public function set questState(value : int) : void {
			if (_questState == value) return;
			_questState = value;
			// Logger.info("avatar id===>" + id, "_questState===>" + _questState, "_npcVo.id===>" + _npcVo.id);
			if (!_statePlayer) createStatePlayer();
			_statePlayer.show();
			switch(_questState) {
				case NOTHING:
					_statePlayer.hide();
					return;
				default :
					_statePlayer.setBDData(AvatarManager.instance.getAvatarBD(1677721602).bds);
			}
			_statePlayer.play(80, null, 0, 0);
			_statePlayer.mouseEnabled = false;
			_statePlayer.mouseChildren = false;
		}

		private var _dialogTop : GTextArea;
		private var _dialogOffX : int = 50;
		private var _dialogOffY : int = -50;
		private var _stateOffX : int = 61;
		private var _stateOffY : int = 0;

		private function addTextArea() : void {
			var data : GTextAreaData = new GTextAreaData();
			data.width = 200;
			data.height = 80;
			data.hideBackgroundAsset = false;
			data.selectable = true;
			data.editable = false;
			data.backgroundAsset = new AssetData("dialogue_Top");
			data.textFormat = UIManager.getTextFormat(14);
			data.padding = 10;
			data.selectable = false;
			data.x = _nameBitMap.x + _dialogOffX + this.x;
			data.y = _nameBitMap.y + _dialogOffY + this.y;
			data.parent = this.parent;
			_dialogTop = new GTextArea(data);
			_dialogTop.textField.autoSize = TextFieldAutoSize.CENTER;
			_dialogTop.textField.textColor = 0x000000;
			_dialogTop.hideEdge();
		}

		private function changeAction() : void {
			if (!_npcVo || !(_npcVo is VoNpc)) return;
			if (!this.avatarBd) return;
			if (this.avatarBd.getAvatarFrame(NPC_STAND) && this.avatarBd.getAvatarFrame(NPC_ACTION) == null) return;
			if (_currentAction.action == NPC_ACTION) return;
			if (!AvatarManager.instance.getAvatarFrame(_uuid, _currentAction.action)) return;
			this.setAction(NPC_ACTION, 1, 0);
			this.player.addEventListener(Event.COMPLETE, onComplete);
		}

		private function onComplete(event : Event) : void {
			this.player.removeEventListener(Event.COMPLETE, onComplete);
			this.setAction(NPC_STAND, 0);
		}

		public function showDialog(str : String) : void {
			if (!str || str == "" || StringUtils.trim(str) == "") return;
			if (!this.visible) return;
			if (!_dialogTop) addTextArea();
			_dialogTop.show();
			_dialogTop.htmlText = str;
			_timeNum = 3;
			_dialogTop.visible = true;
			SecondsTimer.addFunction(hideDialog);
		}

		private function createStatePlayer() : void {
			var base : GComponentData = new GComponentData();
			base.parent = this;
			_statePlayer = new BDPlayer(base);
			_statePlayer.x = _nameBitMap.x + _stateOffX;
			_statePlayer.y = _nameBitMap.y + _stateOffY;
		}

		override protected function updateDisplays() : void {
			super.updateDisplays();
			if (!_statePlayer || !_avatarBd) return;
			_statePlayer.x = _avatarBd.topX + _stateOffX;
			_statePlayer.y = _avatarBd.topY + _stateOffY;
			if (!_dialogTop) return;
			_dialogTop.x = _avatarBd.topX + _dialogOffX + this.x;
			_dialogTop.y = _avatarBd.topY + _dialogOffY + this.y;
		}

		override protected function onMouseClick(event : MouseEvent) : void {
			super.onMouseClick(event);
			if (_npcVo && _npcVo is VoNpc && _npcVo.id != 3001) changeAction();
		}

		private var _timeNum : int = 3;

		private function hideDialog() : void {
			if (--_timeNum <= 0) {
				SecondsTimer.removeFunction(hideDialog);
				_dialogTop.hide();
			}
		}

		private function mouse_func(evt : MouseEvent) : void {
			if (!_npcVo) return;
			if (evt.type == MouseEvent.ROLL_OVER) {
				if (_npcVo.customCursor)
					MouseManager.cursor = _npcVo.customCursor;
				else {
					if (_npcVo.type != 1) return;
					MouseManager.cursor = (_npcVo is VoNpc) ? MouseManager.DIALO : MouseManager.BATTLE;
					player.filters = [new GlowFilter(0xFFFF00, 1, 16, 16, 2, 1)];
				}
			} else if (evt.type == MouseEvent.ROLL_OUT) {
				Mouse.cursor = MouseCursor.ARROW;
				player.filters = [];
			}
		}

		private function initEvent() : void {
			this.addEventListener(MouseEvent.ROLL_OVER, mouse_func);
			this.addEventListener(MouseEvent.ROLL_OUT, mouse_func);
			if (_npcVo) _npcVo.addEventListener("refresh", refreshQuestState);
		}

		private function clearEvent() : void {
			this.removeEventListener(MouseEvent.ROLL_OVER, mouse_func);
			this.removeEventListener(MouseEvent.ROLL_OUT, mouse_func);
			if (_npcVo) _npcVo.removeEventListener("refresh", refreshQuestState);
		}
		
		private var _mc : MovieClip;
		private var _isOne : Boolean = false;
		private var _isMc : Boolean = false;
		private function checkNpcStyle() : void {
			AvatarManager.instance.getAvatarBD(1677721602).bds.list();

			this.mouseEnabled = true;
			this.mouseChildren = true;
			questState = _npcVo.questState;
			this.blendMode = _npcVo.blendMode;
			if (_npcVo.id < 4000) {
				switch((_npcVo as VoNpc).type) {
					case 1:
						setName(_npcVo.name);
						break;
					case 2:
						with(this.graphics) {
							beginFill(0xfff00);
							drawRect(-100, -100, 200, 200);
							endFill();
						}
						clearEvent();
						Mouse.cursor = MouseCursor.ARROW;
						this.alpha = 0;
						this.mouseEnabled = false;
						this.mouseChildren = false;
						return;
					case 3:
						setName("");
						break;
					case 4:
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
					case 6:
						Mouse.cursor = MouseCursor.ARROW;
						this.mouseChildren = false;
						this.mouseEnabled = false;
						hideShodow();
						break;
				}
				initAvatar(_npcVo.avatarId, AvatarType.NPC_TYPE);
				player.flipH = _npcVo.flipH;
			} else {
				setName(_npcVo.name);
				initAvatar(_npcVo.avatarId, AvatarType.MONSTER_TYPE);
			}
		}
		
		override public function setAction(value : int, loop : int = 0, index : int = 0, arr : Array = null, onComplete : Function = null, onCompleteParams : Array = null) : void {
			if (_isMc) {
				if (_mc)
					_mc.gotoAndPlay(1);
				return;
			}
			super.setAction(value, _isOne ? 1 : loop, index, arr, onComplete, onCompleteParams);
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

		private var _npcVo : VoNpc;

		public function setId(value : int) : void {
			_npcVo = RSSManager.getInstance().getNpcById(value);
			if (!_npcVo) {
				Logger.error("没找到  id= " + value + " 的npc或者monster");
				return;
			}
			_npcVo.addEventListener("refresh", refreshQuestState);
			checkNpcStyle();
			updateDisplays();
		}

		private function refreshQuestState(event : Event) : void {
			if (_npcVo)
				questState = _npcVo.questState;
		}

		override public function stand() : void {
			setAction(NPC_STAND);
			_questState = NPC_STAND;
		}

		override internal function reset() : void {
			super.reset();
			_npcVo = null;
			_questState = 0;
			this.graphics.clear();
			player.scaleX = 1;
			player.scaleY = 1;
			alpha = 1;
			if (_statePlayer) {
				_statePlayer.hide();
				_statePlayer = null;
			}
		}

		override public function moveTo(x : int, y : int) : void {
			if (!avatarBd) return;
			this.x = x + avatarBd.bottomX;
			this.y = y + avatarBd.bottomY;
		}

		override protected function onShow() : void {
			super.onShow();
			initEvent();
		}

		override protected function onHide() : void {
			super.onHide();
			clearEvent();
			if (_dialogTop)
				_dialogTop.hide();
		}

		override public function set visible(value : Boolean) : void {
			super.visible = value;
			if (!value && _dialogTop)
				_dialogTop.hide();
		}

		public function AvatarNpc() {
			super();
			initEvent();
		}
	}
}
