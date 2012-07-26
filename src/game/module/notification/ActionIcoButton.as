package game.module.notification {
	import game.module.notification.battleReport.BattleReportProxy;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.module.guild.GuildProxy;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GToolTipData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.RESManager;

	import com.commUI.alert.Alert;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class ActionIcoButton extends GComponent {
		private var _assetData : AssetData;

		public function ActionIcoButton(_base : GComponentData, item : VoNotification) {
			_base.toolTipData = new GToolTipData();
			setNotification(item);
			super(_base);
		}

		private var _item : VoNotification;
		private var _vo : VoICOButton;

		public function setNotification(item : VoNotification) : void {
			_vo = ICOMenuManager.getInstance().getIcoVo(item.typeId);
			_assetData = new AssetData(_vo.ioc);
			_item = item;
			if ((_item.typeId == 0 || _item.typeId == 1 || _item.typeId == 2) && _item.value.paramNum.length > 0)
				updateNum(_item.value.paramNum[0], false);
		}

		public function get uuid() : int {
			return _item ? _item.id : -1;
		}

		public function get typeId() : int {
			return _item ? _item.typeId : -1;
		}

		private var _num : int = 1;
		private var _numTextFile : TextField;

		public function updateNum(value : int = 1, isRemove : Boolean = true) : void {
			if (isRemove)
				_num -= value;
			else
				_num = value;
			_num = _num > 99 ? 99 : _num;
			if (_vo && _vo.type == 5 && _num > 1) {
				if (!_sprite)
					_sprite = UIManager.getUI(new AssetData("numberMount"));
				if (!_numTextFile) {
					_numTextFile = new TextField();
					var format : TextFormat = UIManager.getTextFormat(12, 0xffffff);
					format.align = TextFormatAlign.CENTER;
					_numTextFile.defaultTextFormat = format;
					_numTextFile.width = 20;
					_numTextFile.wordWrap = false;
					_numTextFile.selectable = false;
				}
				_numTextFile.text = String(_num);
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

		private var _back : Bitmap;
		private var _backData : BitmapData;
		private var _sprite : Sprite;

		override protected function create() : void {
			if (!_backData)
				_backData = RESManager.getBitmapData(_assetData);
			if (!_backData) return ;
			_back = new Bitmap(_backData);
			addChildAt(_back, 0);
			toolTip.source = _vo.getTips(_item.value.paramStr, _item.value.paramNum);
		}

		override protected function layout() : void {
			if (_sprite && _back) {
				_sprite.x = _back.width - _sprite.width;
				_sprite.y = -3;
			}
			if (_numTextFile) {
				_numTextFile.x = 18;
				_numTextFile.y = -1;
			}
		}

		private function initEvent() : void {
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function clearEvent() : void {
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private var timer : int = getTimer();

		private function onClick(event : MouseEvent) : void {
			if (getTimer() - timer < 500) return;
			timer = getTimer();
			openTarget();
			event.stopPropagation();
		}

		private function onRollOver(event : MouseEvent) : void {
			this.filters = [new GlowFilter(0xffff00)];
		}

		private function onRollOut(event : MouseEvent) : void {
			this.filters = [];
		}

		private function onMouseDown(event : MouseEvent) : void {
			this.filters = [];
		}

		/**
		 * 1:弹邮件面板
		 * 2:弹出知己申请面板
		 * 3:战斗类提示
		 * 4:弹询问框   有是否
		 * 5:文字类		无是否
		 * 6:弹出活动奖励面板
		 * 7:弹出礼包奖励面板
		 **/
		private function openTarget() : void {
			if (!_vo) return;
			switch(_vo.openType) {
				case 1:
					NotificationProxy.delNotification(_item.id);
					break;
				case 2: {
						MenuManager.getInstance().openMenuView(MenuType.FRIENDAPPLY);
						NotificationProxy.reqFriend();
					}
					break;
				case 3:
					Alert.show(_vo.getTips(_item.value.paramStr, _item.value.paramNum));
					NotificationProxy.delNotification(_item.id);
					break;
				case 4:
					Alert.show(_vo.getTips(_item.value.paramStr, _item.value.paramNum), "", Alert.OK | Alert.CANCEL, okFun);
					break;
				case 5:
					Alert.show(_vo.getTips(_item.value.paramStr, _item.value.paramNum));
					NotificationProxy.delNotification(_item.id);
					break;
				case 6:
					NotificationProxy.reqReward();
					break;
				case 7:
					break;
				case 8:
					BattleReportProxy.instance.RequestCtoS();
					break;
				case 9: {
						Alert.show(_vo.getTips(_item.value.paramStr, _item.value.paramNum), "", Alert.OK | Alert.CANCEL, function(type : String) : Boolean {
							if ( type == Alert.OK_EVENT ) {
								if (!MenuManager.getInstance().checkOpen(MenuType.TRADE, true)) return true;
								MenuManager.getInstance().changMenu(MenuType.TRADE).target["switchPanel"](1);
							}
							return true ;
						});
						NotificationProxy.delNotification(_item.id);
					}
					break ;
				case 10: {
						Alert.show(_vo.getTips(_item.value.paramStr, _item.value.paramNum), "", Alert.OK | Alert.CANCEL, function(type : String) : Boolean {
							if ( type == Alert.OK_EVENT ) {
								if (!MenuManager.getInstance().checkOpen(MenuType.TRADE, true)) return true;
								MenuManager.getInstance().changMenu(MenuType.TRADE).target["switchPanel"](2);
							}
							return true ;
						});
						NotificationProxy.delNotification(_item.id);
					}
					break;
				case 11: {
						Alert.show(_vo.getTips(_item.value.paramStr, _item.value.paramNum), null, Alert.OK | Alert.CANCEL, function(type : String) : Boolean {
							if ( type == Alert.OK_EVENT ) {
								GuildProxy.cs_guildrequest(_item.value.paramNum[1]);
							}
							NotificationProxy.delNotification(_item.id);
							return true ;
						});
					}
					break ;
				case 12:
					break;
				default :
					NotificationProxy.delNotification(_item.id);
					break;
			}
		}

		private function okFun(type : String) : Boolean {
			switch(type) {
				case Alert.OK_EVENT:
				case Alert.YES_EVENT:
					NotificationProxy.delNotification(_item.id);
					break;
				default :
					break;
			}
			return true;
		}

		override protected function onShow() : void {
			super.onShow();
			initEvent();
		}

		override protected function onHide() : void {
			super.onHide();
			clearEvent();
		}

		public function get vo() : VoICOButton {
			return _vo;
		}

		private var _target : GComponent;

		public function set target(value : GComponent) : void {
			_target = value;
		}

		public function get target() : GComponent {
			return _target;
		}
	}
}
