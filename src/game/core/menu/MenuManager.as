package game.core.menu {
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.module.practice.PracticeProxy;
	import game.module.quest.QuestManager;

	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.data.GButtonData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class MenuManager {
		public static const MAIN_STACK : int = 10;
		public static const TOP_MENU : int = 0;
		public static const BOTTOM_MENU : int = 1;
		public static const MAP_MENU : int = 2;
		private  var bottomMenu : Vector.<VoMenuButton>=new Vector.<VoMenuButton>();
		private  var rightMenu : Vector.<VoMenuButton>=new Vector.<VoMenuButton>();
		private  var topMenu : Vector.<VoMenuButton>=new Vector.<VoMenuButton>();
		private var otherMenu : Vector.<VoMenuButton>=new Vector.<VoMenuButton>();
		private var menuButton : Dictionary = new Dictionary();
		private var _showIngView : Vector.<MenuButton>=new Vector.<MenuButton>();
		private static var __instance : MenuManager;

		public function MenuManager() {
			if (__instance) {
				throw Error("MenuManager 是单类，不能多次初始化!");
			}
		}

		public static function getInstance() : MenuManager {
			if (__instance == null) {
				__instance = new MenuManager();
			}
			return __instance;
		}

		/**  
		 *从配置文件中读入一些菜单属性 
		 */
		public function initMenuVo(value : VoMenuButton) : void {
			if (!value) return;
			switch(value.type) {
				case 1:
					bottomMenu.push(value);
					break;
				case 2:
					rightMenu.push(value);
					break;
				case 3:
					topMenu.push(value);
					break;
				default :
					otherMenu.push(value);
					break;
			}
		}

		private var _bottomMenu : MenuView;
		private var _topMenu : TopMenu;
		private var _mapMenu : MapMenu;

		public function initialize() : void {
			_bottomMenu = new MenuView();
			_mapMenu = new MapMenu();
			_topMenu = new TopMenu();
			var max : int = bottomMenu.length;
			for (var i : int = 0;i < max;i++) {
				var button : MenuButton = addButton(bottomMenu[i]);
				if (button.vo.id == MenuType.PRACTICE) {
					button.target = PracticeProxy.getInstance().getView();
					if (button.target) button.target.source = button.vo;
				}
				_bottomMenu.add(button);
			}
			_bottomMenu.refresh();
			_bottomMenu.show();
			max = rightMenu.length;
			for (i = 0;i < max;i++) {
				button = addButton(rightMenu[i]);
				button.align = new GAlign(rightMenu[i].offX, -1, rightMenu[i].offY);
				button.setSize(rightMenu[i].w, rightMenu[i].h);
				_mapMenu.addChild(button);
				GLayout.layout(button);
			}
			_mapMenu.show();
			GLayout.update(UIManager.root, _mapMenu);
			max = topMenu.length;
			for (i = 0;i < max;i++) {
				button = addButton(topMenu[i], 3);
				_topMenu.add(button);
			}
			_topMenu.refresh();
			_topMenu.show();

			max = otherMenu.length;
			for (i = 0;i < max;i++) {
				addButton(otherMenu[i], 10);
			}

			SignalBusManager.changeNewExchangeCount.dispatch();
		}

		public function setShowList(list : Array = null) : void {
			_bottomMenu.refreshList(list);
		}

		public function refresh() : Boolean {
			var num : int = 0;
			if(!_bottomMenu||!_topMenu)return num > 0;
			num = _bottomMenu.refreshToAction() ? num + 1 : num;
			num = _topMenu.refreshToAction() ? num + 1 : num;
			return num > 0;
		}

		public function getMenu(index : int = 1, refresh : Boolean = false) : GComponent {
			switch(index) {
				case 0:
					if (refresh) _topMenu.refresh();
					return _topMenu;
					break;
				case 1:
					if (_bottomMenu) _topMenu.refresh();
					return _bottomMenu;
					break;
				case 2:
					return _mapMenu;
					break;
			}
			return _bottomMenu;
		}

		public function openMenuView(index : int) : IMenuButton {
			var tempButton : MenuButton = menuButton[index];
			if (!tempButton) return null;
			if (!checkOpenByVo(tempButton)) return tempButton;
			var n : int = _showIngView.indexOf(tempButton);
			if (tempButton.showTargetView() && n < 0) {
				resetShowing(tempButton);
				_showIngView.push(tempButton);
			}
			refreshShowingView();
			SignalBusManager.enterSceneModePanel.dispatch(tempButton.vo.id);
			return tempButton;
		}

		public function visible(value : Boolean, index : int = 0) : void {
			switch(index) {
				case 0:
					_topMenu.visible = value;
					break;
				case 1:
					_bottomMenu.visible = value;
					break;
				case 2:
					_mapMenu.visible = value;
					break;
			}
		}

		/*
		 * 功能是否开启
		 */
		public function checkOpen(index : int,scroll : Boolean = false) : Boolean {
			var tempButton : MenuButton = menuButton[index];
			if (!tempButton) return false;
			return checkOpenByVo(tempButton, scroll);
		}

		// private
		internal function checkButton(button : MenuButton) : Boolean {
			return checkLevel(button.vo.level);
		}
		
		public function checkLevel(level:int):Boolean
		{
			if (level < 1000 && UserData.instance.level >= level) return true;
			if (level > 1000 && QuestManager.getInstance().isSubmit(level)) return true;
			return false;
		}

		public function closeMenuView(index : int, refresh : Boolean = true) : IMenuButton {
			var tempButton : MenuButton = menuButton[index];
			if (!tempButton) return null;
			var n : int = _showIngView.indexOf(tempButton);
			if (n >= 0)
				_showIngView.splice(n, 1);
			tempButton.hideTargetView();
			if (refresh)
				refreshShowingView();
			SignalBusManager.exitSceneModePanel.dispatch(tempButton.vo.id);
			return tempButton;
		}

		/**
		 * true   open
		 * false  close
		 */
		public function getMenuState(index : int) : Boolean {
			for each (var button:MenuButton in _showIngView) {
				if (button.vo.id == index) return true;
			}
			return false;
		}

		public function getMenuButton(index : int) : IMenuButton {
			for each (var button:MenuButton in menuButton) {
				if (button && button.vo.id == index) return button;
			}
			return null;
		}

		public function getMenuTarget(index : int) : Sprite {
			for each (var button:MenuButton in menuButton) {
				if (button && button.vo.id == index) return button.target;
			}
			return null;
		}

		/**
		 * index 面板编号
		 * 如果当前是开的，刚关掉，如果是关的，则打开
		 */
		public function changMenu(index : int) : IMenuButton {
			var tempButton : MenuButton = menuButton[index];
			if (!tempButton) return null;
			if (!checkOpenByVo(tempButton)) return tempButton;
			if (getMenuState(index)) {
				closeMenuView(index);
			} else {
				openMenuView(index);
			}
			return tempButton;
		}

		public function sortFun(a : MenuButton, b : MenuButton) : int {
			return a.vo.sortIndex - b.vo.sortIndex;
		}

		/**检查开启条件*/
		private function checkOpenByVo(button : MenuButton, scroll : Boolean = true) : Boolean {
			if (checkButton(button))
				return true;
			else if (scroll)
				StateManager.instance.checkMsg(105);
			return false;
		}

		private function resetShowing(tempButton : IMenuButton) : void {
			var max : int = _showIngView.length;
			var view : MenuButton;
			for (var i : int = 0;i < max;i++) {
				view = _showIngView.length > i ? _showIngView[i] : null;
				if (view && view.vo.coexist.indexOf(String(tempButton.vo.id)) < 0) {
					if (tempButton.vo.stack != view.vo.stack) continue;
					view.hideTargetView();
					_showIngView.splice(_showIngView.indexOf(view), 1);
					i--;
				}
			}
		}

		private function refreshShowingView() : void {
			var w : int = 0;
			_showIngView.sort(sortFunB);
			var num : int = 0;
			for (var i : int = _showIngView.length - 1; i >= 0; i--) {
				var button : MenuButton = _showIngView[i];
				if (button.vo.stack != MAIN_STACK) continue;
				w += (button.target is GCommonWindow) ? button.target["outWidth"] : button.target.width;
				button.target.y = (UIManager.stage.stageHeight - button.target.height) / 2;
				button.target.x = (UIManager.stage.stageWidth - button.target.width) / 2;
				num++;
			}
			if (num <= 1) return;
			w = (UIManager.stage.stageWidth - w) / 2 + 20;
			for each (button in _showIngView) {
				if (button.vo.stack != MAIN_STACK) continue;
				TweenLite.to(button.target, 0.5, {x:w, overwrite:0, onComplete:resetXY, onCompleteParams:[button.target, w]});
				w += (button.target is GCommonWindow) ? button.target["outWidth"] : button.target.width;
			}
		}

		private function resetXY(target : Sprite, x : int) : void {
			target.x = x;
		}

		private function sortFunB(a : IMenuButton, b : IMenuButton) : int {
			return a.vo.sortId - b.vo.sortId;
		}

		private function addButton(vo : VoMenuButton, type : int = 0) : MenuButton {
			var _data : GButtonData = new GButtonData();
			var button : MenuButton;
			if (type == 3) {
				button = new TopMenuButton(_data, vo, type);
			} else {
				if (type == 0) {
					_data.downAsset = new AssetData(vo.ioc + "Click", "lang_menu");
					_data.overAsset = new AssetData(vo.ioc + "Over", "lang_menu");
					_data.upAsset = new AssetData(vo.ioc, "lang_menu");
					_data.parent = _bottomMenu;
					button = new MenuButton(_data, vo, type);
				}
				button = new MenuButton(_data, vo, type);
			}
			menuButton[vo.id] = button;
			return button;
		}
	}
}
