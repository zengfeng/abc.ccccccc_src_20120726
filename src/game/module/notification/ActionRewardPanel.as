package game.module.notification {
	import com.commUI.GCommonWindow;
	import com.commUI.button.KTButtonData;
	import com.utils.UICreateUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	import game.definition.UI;
	import game.manager.ViewManager;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	import net.RESManager;

	/**
	 * @author yangyiqiang
	 */
	public class ActionRewardPanel extends GCommonWindow {
		public function ActionRewardPanel() {
			_data = new GTitleWindowData();
			_data.width = 450;
			_data.height = 320;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;
			super(_data);
		}

		private var _back : Sprite;
		private var _listPanel : GPanel;
		private var _ico : MovieClip;
		private var _icoLable : TextField;

		override protected function create() : void {
			super.create();
			this.title = "奖励礼包";
			_back = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			_back.x = 5;
			_back.y = 5;
			_back.width = 436;
			_back.height = 304;
			_ico = RESManager.getMC(new AssetData("icon_hint"));
			_ico.x = 21;
			_ico.y = 17;
			_icoLable = UICreateUtils.createTextField("活动奖励最多只保留10天", null, 150, 18, 47, 15, UIManager.getTextFormat());
			this.contentPanel.add(_back);
			this.contentPanel.add(_icoLable);
			this.contentPanel.add(_ico);

			var panelData : GPanelData = new GPanelData();
			panelData.x = 0;
			panelData.y = 65;
			panelData.width = 440;
			panelData.height = 200;
			panelData.scrollBarData.wheelSpeed = 25;
			panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			_listPanel = new GPanel(panelData);
			this.contentPanel.add(_listPanel);
			addLables();
			for (var i : int = 0;i < 4;i++) {
				_list[i] = new ActionItem(i);
				_list[i]["x"] = 10;
				_list[i]["y"] = 50 * i;
				_listPanel.add(_list[i]);
			}
			addButton();
		}

		private var _acceptAll : GButton;

		private function addButton() : void {
			if (!_acceptAll) {
				var data : KTButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
				data.width = 80;
				data.height = 30;
				data.x = 187;
				data.y = 270;
				_acceptAll = new GButton(data);
				_acceptAll.text = "收取全部";
			}
			addChild(_acceptAll);
		}

		private function addLables() : void {
			var mc : MovieClip = RESManager.getMC(new AssetData("topLineBack"));
			mc.x = 10;
			mc.y = 39;
			this.contentPanel.add(mc);
			var data : GLabelData = new GLabelData();
			data.y = 80;
			data.x = 84;
			var title1 : TextField = UICreateUtils.createTextField("奖励礼包名称", null, 80, 18, 90, 43, UIManager.getTextFormat(12, 0xffffff));
			var title2 : TextField = UICreateUtils.createTextField("日期", null, 80, 18, 258, 43, UIManager.getTextFormat(12, 0xffffff));
			var title3 : TextField = UICreateUtils.createTextField("操作", null, 30, 18, 371, 43, UIManager.getTextFormat(12, 0xffffff));
			this.contentPanel.add(title1);
			this.contentPanel.add(title2);
			this.contentPanel.add(title3);
			var mc2 : MovieClip = RESManager.getMC(new AssetData("topGoldLine"));
			mc2.x = 5;
			mc2.y = 264;
			this.contentPanel.add(mc2);
		}

		override protected function onShow() : void {
			super.onShow();
			_acceptAll.addEventListener(MouseEvent.CLICK, onClick);
		}

		override protected function onHide() : void {
			super.onHide();
			_acceptAll.removeEventListener(MouseEvent.CLICK, onClick);
			clearList();
		}

		private var _list : Dictionary = new Dictionary();

		public function set data(value : *) : void {
			clearList();
			var list : Vector.<VoReward>=value;
			if (!list) return ;
			var max : int = list.length;
			// max = max > 4 ? max : 4;
			for (var i : int = 0;i < max;i++) {
				if (!_list[i]) {
					_list[i] = new ActionItem(i);
					_list[i]["x"] = 10;
					_list[i]["y"] = 50 * i;
				}
				(_list[i] as ActionItem).source = i >= list.length ? null : list[i];
				_listPanel.add(_list[i]);
			}
		}

		private function clearList() : void {
			for each (var item:ActionItem in _list) {
				if (item.parent) item.parent.removeChild(item);
			}
		}

		private function onClick(event : MouseEvent) : void {
			NotificationProxy.opNotification(0, 0);
		}
	}
}
