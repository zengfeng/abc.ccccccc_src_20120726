package game.module.daily {
	import game.core.menu.MenuManager;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.wordDonate.DonateProxy;

	import gameui.containers.GPanel;
	import gameui.containers.GTabbedPanel;
	import gameui.data.GPanelData;
	import gameui.data.GTabbedPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonWindow;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class DailyPanel extends GCommonWindow {
		private var _tabbedPanel : GTabbedPanel;
		private var _dailyActionPanel : GPanel;
		private var _specialPanel : GPanel;

		public function DailyPanel() {
			_data = new GTitleWindowData();
			_data.width = 550;
			_data.height = 380;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;
			super(_data);
		}

		override protected function initViews() : void {
			title = "日常";
			super.initViews();
			var panelData : GPanelData = new GPanelData();
			panelData.bgAsset = new AssetData(UI.PANEL_BACKGROUND);
			panelData.x = 6;
			panelData.y = 0;
			panelData.width = 535;
			panelData.height = 350;
			panelData.padding = 5;
			panelData.scrollBarData.wheelSpeed = 25;
			panelData.horizontalScrollPolicy = GPanelData.OFF;

			_dailyActionPanel = new GPanel(panelData.clone());
			_specialPanel = new GPanel(panelData);

			var data : GTabbedPanelData = new GTabbedPanelData();
			data.tabData.padding = 2;
			data.tabData.gap = 1;
			data.tabData.x = 6;
			data.viewStackData.width = 535;
			data.viewStackData.height = 355;

			_tabbedPanel = new GTabbedPanel(data);
			_tabbedPanel.addTab("每日活动", _dailyActionPanel);

			// _tabbedPanel.addTab("特定活动", _specialPanel);

			_tabbedPanel.group.selectionModel.index = 0;
			initDaily();
			initAction();
			this.contentPanel.add(_tabbedPanel);
		}

		/** 切页 */
		private function tab_changeHandler(event : Event) : void {
		}

		private var _dailyItemList : Vector.<DailyItem>=new Vector.<DailyItem>();

		private function initDaily() : void {
			var item : DailyItem;
			var arr : Vector.<VoDaily>=DailyManage.getInstance().getVos();
			for (var i : int = 0;i < arr.length;i++) {
				item = new DailyItem(arr[i], i);
				item.x = 1;
				item.y = i * 70 + 1;
				_dailyActionPanel.add(item);
				_dailyItemList.push(item);
			}
		}

		private function initAction() : void {
			var item : ActionItem;
			var _back : Sprite = UIManager.getUI(new AssetData("common_background_03"));
			_back.x = 5;
			_back.y = 135;
			_back.width = 525;
			_back.height = 210;
			_specialPanel.add(_back);
			var num : int = 0;
			var arr : Vector.<VoAction>=DailyManage.getInstance().getVos(1);
			for (var i : int = 0;i < arr.length;i++) {
				item = new ActionItem(arr[i]);
				if (arr[i].isToday) {
					item.x = 5;
					item.y = 10;
				} else {
					item.x = (num % 3) * 171 + 12;
					item.y = num < 3 ? 138 : 240;
					num++;
				}
				_specialPanel.add(item);
			}
		}

		public function refreshItems() : void {
			var num : int = 0;
			for (var i : int = 0;i < _dailyItemList.length;i++) {
				var item : DailyItem = _dailyItemList[i];
				if (MenuManager.getInstance().checkLevel(item.vo.level)) {
					item.x = 1;
					item.y = num * 70 + 1;
					item.resetId(i);
					_dailyActionPanel.add(item);
					num++;
				} else {
					if(item&&item.parent)item.parent.removeChild(item);
					continue;
				}
			}
		}

		override protected function onShow() : void {
			super.onShow();
			_tabbedPanel.group.selectionModel.addEventListener(Event.CHANGE, tab_changeHandler);
			DonateProxy.instance.applyNow();
			refreshItems();
		}

		override protected function onHide() : void {
			super.onHide();
			_tabbedPanel.group.selectionModel.removeEventListener(Event.CHANGE, tab_changeHandler);
		}
	}
}
