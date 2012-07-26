package game.module.notification {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.net.data.StoC.NotificationItem;
	import game.net.data.StoC.SCListRewardNotification.RewardItem;

	import gameui.manager.UIManager;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class ICOMenuManager {
		private static var _instance : ICOMenuManager;
		private var _iocDic : Dictionary = new Dictionary();

		public function ICOMenuManager() : void {
			if (_instance) {
				throw Error("IOCMenuManager 是单类，不能多次初始化!");
			}
			_menu = new ActionIcoMenu();
//			UIManager.root.addEventListener(MouseEvent.CLICK, onClick);
		}

		public static function getInstance() : ICOMenuManager {
			if (_instance == null) {
				_instance = new ICOMenuManager();
			}
			return _instance;
		}

		public  function show() : void {
			if (_menu) _menu.show();
		}

		public function hide() : void {
			if (_menu) _menu.hide();
		}

		private var _menu : ActionIcoMenu;

		public function addIoc(item : VoNotification) : void {
			if (!_menu.parent) {
				_menu.show();
			}
			_menu.addButton(item);
		}

		public function removeIoc(uuid : int) : void {
			_menu.removeButton(uuid);
		}

		public function getIcoVo(id : int) : VoICOButton {
			return _iocDic[id];
		}

		public function initIocVo(vo : VoICOButton) : void {
			_iocDic[vo.id] = vo;
		}

		public function updateButtonNum(num : int = 1, type : int = 0) : void {
			_menu.updateButtonNum(num, type);
		}

		private var _rewardList : Vector.<VoReward>=new Vector.<VoReward>();

		public function showRewardList(items : Vector.<RewardItem>) : void {
			ActionRewardPanel;
			_rewardList = new Vector.<VoReward>();
			for each (var item:RewardItem in items)
				_rewardList.push(new VoReward(item));
			MenuManager.getInstance().openMenuView(MenuType.REWARD).target["data"] = _rewardList;
		}

		public function changeRewardList(items : Vector.<uint>) : void {
			for each (var item:uint in items) {
				for each (var vo:VoReward in _rewardList) {
					if (vo.getId() == item)
						_rewardList.splice(_rewardList.indexOf(vo), 1);
				}
			}
			if (_rewardList.length > 0) {
				MenuManager.getInstance().openMenuView(MenuType.REWARD).target["data"] = _rewardList;
			} else {
				MenuManager.getInstance().closeMenuView(MenuType.REWARD);
			}
		}

//		private var _arr : Array = [201, 301, 401, 402, 403, 413, 414, 415, 420, 421, 422, 423];
//		private var _arr : Array = [301, 302, 303];
//		private var _timer : int = 0;
//
//		private function onClick(event : MouseEvent) : void {
//			if ((getTimer() - _timer) < 3000) return ;
//			_timer = getTimer();
//			var value : NotificationItem = new NotificationItem();
//			value.id = getTimer();
//			// value.typeId = _arr[MathUtil.random(0, 3)];
//			value.typeId = 303;
//			var item1 : VoNotification = new VoNotification(value);
//			addIoc(item1);
//			var list : Vector.<RewardItem>=new Vector.<RewardItem>();
//			for (var i : int = 0;i < 5;i++) {
//				var item : RewardItem = new RewardItem();
//				item.items.push(10001 << 16);
//				list.push(item);
//			}
//			showRewardList(list);
//		}
	}
}
