package game.module.userPanel {
	import game.core.user.UserData;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.net.core.Common;
	import game.net.data.CtoC.CCUserDataChangeUp;
	import game.net.data.StoC.SCItemList;

	/**
	 * @author yangyiqiang
	 */
	public class GiftManager {
		private static var __instance : GiftManager;

		public static function get instance() : GiftManager {
			if (!__instance)
				return new GiftManager();

			return __instance;
		}

		public function GiftManager() {
			if (__instance)
				throw(Error("单例错误！"));
			initiate();
		}

		private var _giftPanel : GiftPanel;

		private function initiate() : void {
			Common.game_server.addCallback(0xFFF1, levelUp);
			Common.game_server.addCallback(0x200, itemList);
		}

		private function levelUp(msg : CCUserDataChangeUp) : void {
			if ((msg.level >= msg.oldLevel) && (msg.level % 10 == 0)) checkGift();
		}

		private function get panel() : GiftPanel {
			if (!_giftPanel) _giftPanel = new GiftPanel();
			return _giftPanel;
		}

		private var _giftList : Array = [3201, 3202, 3203, 3204, 3205, 3206, 3207, 3208, 3209, 3210, 3211, 3212, 3213, 3214, 3215, 3216, 3217, 3219, 3220];

		private function itemList(msg : SCItemList) : void {
			var itemId : int;
			for each (var id:int in msg.items) {
				itemId = id & 0x7FFF;
				if (_giftList.indexOf(itemId) >= 0) {
					var item : Item = ItemManager.instance.newItem(itemId);
					if (!item) continue;
					item.binding = true;
					var num : int = ItemManager.instance.getPileItemNums(id);
					if (num <= 0) continue;
					if (item.config.level <= UserData.instance.level) {
						panel.source = item;
						panel.show();
					}
					return;
				}
			}
		}

		private function checkGift() : void {
			for each (var id:int in _giftList) {
				var num : int = ItemManager.instance.getPileItemNums(id);
				if (!num) continue;
				var item : Item = ItemManager.instance.newItem(id);
				if (!item) continue;
				item.binding = true;
				if (item.config.level <= UserData.instance.level) {
					panel.source = item;
					panel.show();
				}
				return;
			}
		}
	}
}
