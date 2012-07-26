package game.module.notification {
	import game.manager.ViewManager;

	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import com.commUI.labelButton.LabelButton;
	import com.commUI.labelButton.LabelButtonData;
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.utils.UICreateUtils;

	import flash.events.MouseEvent;

	/**
	 * @author yangyiqiang
	 * 底部的活动菜单
	 */
	public class ActionIcoMenu extends GComponent {
		// ===============================================================
		// 属性
		// ===============================================================
		public const MAX : int = 10;
		private var _lootButton : LabelButton;
		private var _list : Vector.<ActionIcoButton>=new Vector.<ActionIcoButton>();
		private var _wait : Vector.<ActionIcoButton>=new Vector.<ActionIcoButton>();
		private var _transforming : Vector.<Struct>=new Vector.<Struct>();
		private var _waitForTrans : Vector.<Struct>=new Vector.<Struct>();

		// ===============================================================
		// 方法
		// ===============================================================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function ActionIcoMenu() {
			_base = new GComponentData();
			_base.parent = ViewManager.instance.getContainer(ViewManager.UIC_CONTAINER);
			_base.width = 500;
			_base.height = 71;
			_base.align = new GAlign(-1, -1, -1, 100, 0);
			super(_base);
		}

		private function addLable() : void {
			if (!_lootButton) {
				var data : LabelButtonData = UICreateUtils.labelButtonData.clone();
				data.width = 56;
				data.align = new GAlign(-1, -1, -20, -1, 0);
				_lootButton = new LabelButton(data);
				_lootButton.y = -60;
				_lootButton.htmlText = "<a>快速查看</a>";
				_lootButton.addEventListener(MouseEvent.CLICK, onClickAll);
			}
			addChild(_lootButton);
			GLayout.layout(_lootButton);
		}

		public function addButton(item : VoNotification) : void {
			if ((_list.length + _transforming.length + _waitForTrans.length) < 10) {
				showButton(createButton(item));
			} else _wait.push(createButton(item));
		}

		private function createButton(item : VoNotification) : ActionIcoButton {
			var data : GComponentData = new GComponentData();
			data.parent = this;
			return new ActionIcoButton(data, item);
		}

		private var _removes : Array = [];

		public function removeButton(uuid : int) : void {
			var isFind : Boolean = false;
			for (var i : int;i < _wait.length;i++) {
				if (_wait[i].uuid == uuid) {
					_wait.splice(i, 1);
					if (_list.length < 5 && _lootButton)
						_lootButton.hide();
					if (_wait.length == 0 && _list.length == 0 && _waitForTrans.length == 0)
						this.hide();
					isFind = true;
					break;
				}
			}
			for (i = 0;i < _list.length;i++) {
				if (_list[i].uuid == uuid) {
					_list[i].hide();
					_list.splice(i, 1);
					if (_wait.length == 0)
						refreshList();
					else
						showButton(_wait.pop(), i);
					if (_list.length < 5 && _lootButton)
						_lootButton.hide();
					if (_wait.length == 0 && _list.length == 0 && _waitForTrans.length == 0)
						this.hide();
					isFind = true;
					break;
				}
			}
			if (!isFind) _removes.push(uuid);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		public function updateButtonNum(num : int = 1, type : int = 0) : void {
			// if (type != 0) return;
			for (var i : int;i < _wait.length;i++) {
				if (_wait[i].typeId == type) {
					_wait[i].updateNum(num);
					return;
				}
			}
			for (i = 0;i < _list.length;i++) {
				if (_list[i].typeId == type) {
					_list[i].updateNum(num);
				}
			}
		}

		private function refreshList() : void {
			var max : int = _list.length;
			var startX : int = (this.width - _list.length * 50) / 2;
			for (var i : int = 0;i < _list.length;i++) {
				// _list[i].x = startX + i * 50;
				TweenLite.to(_list[i], 0.5, {x:startX + (max - i) * 50, overwrite:0});
			}
		}

		private function showButton(value : ActionIcoButton, index : int = 0) : void {
			if (!value) return;
			_waitForTrans.push(new Struct(value, index));
			if (_transforming.length == 0)
				execute(_waitForTrans.pop());
		}

		private function execute(struct : Struct) : void {
			if (!struct || !struct.value) {
				refreshList();
				return;
			}
			var max : int = _list.length;
			var ioc : ActionIcoButton;
			var startX : int = (this.width - _list.length * 50) / 2;
			for (var i : int = struct.index;i < max;i++) {
				ioc = _list[i];
				TweenLite.to(ioc, 0.5, {x:startX + (max - i) * 50, overwrite:0});
			}
			struct.index = _transforming.push(struct) - 1;
			struct.value.x = -200;
			struct.value.alpha = 0;
			addChild(struct.value);
			TweenLite.to(struct.value, 2, {alpha:1, x:startX, overwrite:0, onComplete:addToStage, onCompleteParams:[struct], ease:Bounce.easeOut});
		}

		private function addToStage(struct : Struct) : void {
			var index : int = _removes.indexOf(struct.value.uuid);
			if (index >= 0) {
				_removes.splice(index, 1);
				if(struct.value)struct.value.parent.removeChild(struct.value);
			} else {
				_transforming.splice(struct.index, 1);
				_list.push(struct.value);
				struct.value.enabled = true;
			}
			execute(_waitForTrans.pop());
			if (_list.length > 3)
				addLable();
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void {
			super.onShow();
			GLayout.update(UIManager.root, this);
		}

		override protected function onHide() : void {
			super.onHide();
			if (_lootButton)
				_lootButton.removeEventListener(MouseEvent.CLICK, onClickAll);
		}

		private function onClickAll(event : MouseEvent) : void {
			var list : Vector.<uint>=new Vector.<uint>();
			for each (var value:ActionIcoButton in _list) {
				if (value.typeId == 0) {
					NotificationProxy.opNotification(0, 0);
					continue;
				} else if (value.typeId == 1) {
					NotificationProxy.opNotification(1, 0);
					continue;
				}
				list.push(value.uuid);
			}
			NotificationProxy.delNotifications(list);
		}

		override public function show() : void {
			_base.parent.addChildAt(this, 0);
		}
	}
}
import game.module.notification.ActionIcoButton;

class Struct {
	public var value : ActionIcoButton;
	public var index : int = 0;

	public function Struct(_value : ActionIcoButton, _index : int = 0) {
		value = _value;
		index = _index;
		if (value)
			value.enabled = false;
	}
}