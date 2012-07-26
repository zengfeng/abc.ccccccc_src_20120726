package game.module.quest {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import game.core.user.UserData;
	import game.manager.ViewManager;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	/**
	 * @author yangyiqiang
	 */
	public final class QuestPanel extends GComponent {
		private var _manage : QuestManager = QuestManager.getInstance();
		private var _minish : GButton;
		private var _magnify : GButton;
		private var _back : Sprite;
		private var _panel : GPanel;

		private function addButton() : void {
			var data : GButtonData = new GButtonData();
			data.width = 16;
			data.height = 16;
			data.overAsset = new AssetData("quest_less_over", "quest");
			data.upAsset = new AssetData("quest_less_up", "quest");
			data.downAsset = new AssetData("quest_less_down", "quest");
			_minish = new GButton(data);
			data = data.clone();
			data.overAsset = new AssetData("quest_add_over", "quest");
			data.upAsset = new AssetData("quest_add_up", "quest");
			data.downAsset = new AssetData("quest_add_down", "quest");
			_magnify = new GButton(data);
			addChild(_minish);
			addChild(_magnify);
			_magnify.visible = false;
			var lableData : GLabelData = new GLabelData();
			lableData.x = 20;
			lableData.text = "当前任务:";
			lableData.textFieldFilters = UIManager.getEdgeFilters(0x000000, 0.7, 17);
			var lable : GLabel = new GLabel(lableData);
			addChild(lable);
		}

		private function initViews() : void {
			_back = ASSkin.blackSkin;
			_back.alpha = 0.4;
			addChild(_back);

			var panelData : GPanelData = new GPanelData();
			panelData.bgAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			panelData.y = 16;
			panelData.x = 20;
			panelData.width = this.width - 20;
			panelData.height = 127;
			panelData.scrollBarData.visible = false;
			_panel = new GPanel(panelData);
			addChild(_panel);

			addButton();
			_back.x = -4;
			_back.y = -4;
			_back.width = this.width + 8;
			_back.height = this.height + 8;
			_back.visible = false;
		}

		private function addEvent() : void {
			addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			_magnify.addEventListener(MouseEvent.CLICK, onOpen);
			_minish.addEventListener(MouseEvent.CLICK, onClose);
		}

		private function clearEvent() : void {
			removeEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			removeEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			_magnify.removeEventListener(MouseEvent.CLICK, onOpen);
			_minish.removeEventListener(MouseEvent.CLICK, onClose);
		}

		private function onOpen(event : MouseEvent) : void {
			changeState(false);
		}

		private function onClose(event : MouseEvent) : void {
			changeState(true);
		}

		// false 全显示  true 最小化
		private var _small : Boolean = false;

		private function changeState(value : Boolean) : void {
			_small = value;
			if (_small) {
				_panel.visible = false;
				_magnify.visible = true;
				_minish.visible = false;
			} else {
				_panel.visible = true;
				_magnify.visible = false;
				_minish.visible = true;
			}
			if (_back.visible) _back.height = getHight();
		}

		private function getHight() : Number {
			if (_small || _panel.visible == false) return 22;
			if (_list.length > 0 && _list[_list.length - 1].y + _list[_list.length - 1].height + 20 < this.height) return _list[_list.length - 1].y + _list[_list.length - 1].height + 20;
			return this.height;
		}

		private function onRollOut(event : Event) : void {
			_back.alpha = 0;
			changeBack(false);
		}

		private function onRollOver(event : Event) : void {
			_back.alpha = 0.5;
			_back.height = getHight() + 8;
			changeBack(true);
		}

		private function changeBack(value : Boolean) : void {
			_back.visible = value;
			_panel.resetVScrollVisible(value);
		}

		private var _isShow : Boolean = false;
		private var _list : Vector.<questItem>=new Vector.<questItem>();

		public function traceTasks(checkFirst : Boolean = false) : void {
			var arr2 : Vector.<VoQuest> = _manage.getTastInterval(QuestManager.CAN_ACCEPT);
			var arr3 : Vector.<VoQuest> = _manage.getTastInterval(QuestManager.CURRENT);

			arr3 = arr3.concat(arr2);
			arr3.sort(sortFun);
			if (arr3.length ==0 || arr3[0].base.type != 1) {
				var next : VoQuest = _manage.findNextQuest();
				if (next)
					arr3.unshift(next);
			}
			arr3.sort(sortFun);
			var max : int = arr3.length > _list.length ? arr3.length : _list.length;
			var num : Number = 0;
			var vo : VoQuest;
			for (var i : int = 0;i < max;i++) {
				if (arr3.length < i + 1) {
					_list[i].hide();
					continue;
				}
				QuestManager.getInstance().preLoader(arr3[i]);
				if (_list.length < i + 1) {
					_list[i] = new questItem();
				}
				vo = arr3[i];
				_list[i].source = vo;
				_list[i].y = num;
				_panel.add(_list[i]);
				num += _list[i].height;
				if (vo)
					_manage.resetQuestNpcState(vo);
			}
			if (arr3.length > 0) {
				this.show();
				_panel.scrollToTop();
				changeState(false);
			} else
				this.hide();
			if (checkFirst && vo && vo.id == 100001 && UserData.instance.level == 1 && vo.state == QuestManager.CAN_ACCEPT && !_isShow) {
				QuestDisplayManager.getInstance().showMainQuest(vo);
				_isShow = true;
			}
		}

		private function sortFun(a : VoQuest, b : VoQuest) : int {
			if (a.state == 0) return  -1;
			if (b.state == 0) return  1;
			if (a.base.type == 2 && b.base.type == 3) return b.base.type - a.base.type;
			if (a.base.type == 3 && b.base.type == 2) return b.base.type - a.base.type;
			return a.base.type - b.base.type;
		}

		override protected function onShow() : void {
			super.onShow();
			addEvent();
		}

		override protected function onHide() : void {
			super.onHide();
			clearEvent();
		}

		public function QuestPanel() {
			_base = new GComponentData();
			_base.width = 200;
			_base.height = 150;
			_base.align = new GAlign(-1, 20, -1, -1, -1, 0);
			_base.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			super(_base);
			initViews();
		}
	}
}
import com.greensock.TweenLite;
import com.greensock.easing.Quint;

import flash.events.TextEvent;
import flash.text.AntiAliasType;
import flash.utils.getTimer;

import game.module.quest.QuestUtil;
import game.module.quest.VoQuest;

import gameui.controls.GTextArea;
import gameui.core.GComponent;
import gameui.core.GComponentData;
import gameui.data.GTextAreaData;
import gameui.manager.UIManager;
import gameui.skin.SkinStyle;

import net.AssetData;

class questItem extends GComponent {
	private var _vo : VoQuest;
	private var _text : GTextArea;

	public function questItem() {
		super(new GComponentData());
	}

	private function addEvent() : void {
		_text.addEventListener(TextEvent.LINK, linkHandler);
	}

	private function clearEvent() : void {
		_text.removeEventListener(TextEvent.LINK, linkHandler);
	}

	private var _lastTime : int;

	private function linkHandler(event : TextEvent) : void {
		if (getTimer() - _lastTime < 1000) return;
		_lastTime = getTimer();
		QuestUtil.questAction(Number(event.text));
	}
	
	private var _str : String = "";

	override public function set source(value : *) : void {
		_vo = value;
		if (!_vo) return;
		if (_vo.getQuestString() == _str) return;
		_str = _vo.getQuestString();
		_text.alpha = 0;
		_text.htmlText = _vo.getQuestString();
		_text.x = -300;
		TweenLite.to(_text, 0.8, {alpha:1, x:0, overwrite:0, ease:Quint.easeOut});
		layout();
	}

	override protected function create() : void {
		var data : GTextAreaData = new GTextAreaData();
		data.width = this.width - 16;
		data.height = 100;
		data.selectable = false;
		data.editable = false;
		data.textFieldFilters = UIManager.getEdgeFilters(0x000000, 0.7, 17);
		data.backgroundAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
		_text = new GTextArea(data);
		_text.textField.antiAliasType = AntiAliasType.ADVANCED;
		addChild(_text);
	}

	override public function get height() : Number {
		return _text.textField.textHeight + 6;
	}

	override protected function layout() : void {
		_text.width = 178;
	}

	override protected function onShow() : void {
		super.onShow();
		addEvent();
	}

	override protected function onHide() : void {
		super.onHide();
		clearEvent();
	}
}
