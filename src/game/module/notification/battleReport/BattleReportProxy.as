package game.module.notification.battleReport {
	import game.net.data.StoC.SCChangeNotification;
	import game.net.data.StoC.NotificationItem;
	import game.net.data.StoC.SCListNotification;
	import game.module.notification.ICOMenuManager;
	import game.net.data.StoC.SCDelSpecialNotification;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.net.core.Common;
	import game.net.data.CtoS.CSListBattleNotification;
	import game.net.data.StoC.SCListBattleNotification;
	import game.net.data.StoC.SCListBattleNotification.BattleItem;

	/**
	 * @author Lv
	 */
	public class BattleReportProxy {
		private static var _instance : BattleReportProxy;
		// 仙龟拜佛
		public static var btreprotObj : Vector.<Object> = new Vector.<Object>();

		public function BattleReportProxy(contr : Contral) : void {
			contr;
			init();
		}

		public static function get instance() : BattleReportProxy {
			if (_instance == null)
				_instance = new BattleReportProxy(new Contral());
			return _instance;
		}

		private function init() : void {
			_icoManager = ICOMenuManager.getInstance();
			Common.game_server.addCallback(0x5E, sCListBattleNotification);
			Common.game_server.addCallback(0x5A, sCDelSpecialNotification);

			Common.game_server.addCallback(0x5B, changeNotification);
		}

		private var _icoManager : ICOMenuManager;

		private function sCDelSpecialNotification(e : SCDelSpecialNotification) : void {
			var list : Vector.<uint> = e.idList;
			if (e.type == 2) {
				if (list.length == 1) {
					var item : uint = list[0];
					_icoManager.updateButtonNum(1, 2);
					for (var i : int = 0 ; i < btreprotObj.length;i++) {
						var obj : Object = btreprotObj[i];
						if (obj["id"] == item) {
							btreprotObj.splice(i, 1);
							MenuManager.getInstance().openMenuView(MenuType.BATLLEREPORT).target["addDataToList"]();
							return;
						}
					}
				}else{
					for(var j:int = 0; j< list.length; j++){
						_icoManager.updateButtonNum(j+1, 2);
					}
				}
			}
		}

		public static var openBattleRePanel : Boolean = false;

		private function sCListBattleNotification(e : SCListBattleNotification) : void {
			clearObj();
			var battleVec : Vector.<BattleItem> = e.items;
			for each (var item:BattleItem in battleVec) {
				// 仙龟拜佛
				var obj : Object = new Object();
				if (item.type == 402 || item.type == 403) {
					obj["type"] = item.type;
					obj["id"] = item.id;
					obj["name"] = item.name;
					obj["color"] = item.color;
					btreprotObj.push(obj);
				}
			}
			openBattleRePanel = true;
			// btreprotObj.reverse();
			// if (!MenuManager.getInstance().openMenuView(MenuType.BATLLEREPORT))
			MenuManager.getInstance().openMenuView(MenuType.BATLLEREPORT).target["addDataToList"]();
			// else
			// MenuManager.getInstance().closeMenuView(MenuType.BATLLEREPORT);
		}

		private function clearObj() : void {
			while (btreprotObj.length > 0) {
				btreprotObj.splice(0, 1);
			}
		}

		private function changeNotification(msg : SCChangeNotification) : void {
			if (msg.newItem.typeId == 2) {
				if (openBattleRePanel)
					RequestCtoS();
			}
		}

		// 请求战报
		public function RequestCtoS() : void {
			var cmd : CSListBattleNotification = new CSListBattleNotification();
			cmd.leastID = 0;
			Common.game_server.sendMessage(0x5E, cmd);
		}
	}
}
class Contral {
}