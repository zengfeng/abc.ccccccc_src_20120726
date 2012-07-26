package game.manager {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.module.daily.DailyManage;
	import game.module.quest.QuestDisplayManager;
	import game.module.quest.QuestManager;
	import game.net.core.Common;
	import game.net.data.StoC.SCDailyInfo;

	/**
	 * @author yangyiqiang
	 */
	public class DailyInfoManager {
		private static var _instance : DailyInfoManager;

		public function DailyInfoManager() {
			if (_instance) {
				throw Error("---DailyInfoManager--is--a--single--model---");
			}
			Common.game_server.addCallback(0x13, dailyInfo);
			Common.game_server.addCallback(0xFFF7, vipchange);
		}

		public static function get instance() : DailyInfoManager {
			if (_instance == null) {
				_instance = new DailyInfoManager();
			}
			return _instance;
		}

		public static var dailyValue : uint;
		public static var dailyStatus : uint;
		public var stampoff : Number = 0 ;

		// 日常面板值   A + (B << 4) + (C << 8) + (D << 12) + (E << 16) + (F << 20) + (G << 24)
		// A - 挖矿剩余次数
		// B - 仙龟拜佛烧香剩余次数
		// C - 仙龟拜佛打劫剩余次数
		// D - 钓鱼剩余次数
		// E - 保留
		// F - 竞技场剩余次数
		// G - 悬榜令剩余次数
		// 日常状态 A + (B << 2) + (C << 4) + (D << 6)
		// A - boss战
		// B - 派对
		// C - 阵营战
		// D - 守卫唐僧
		// 0 - 今日无活动  1 - 未开启  2 - 已开启  3 - 已结束
		private function dailyInfo(info : SCDailyInfo) : void {
			dailyValue = info.dailyValue;
			dailyStatus = info.dailyStatus;
			stampoff = (info.timestamp - (new Date()).time / 1000) * 1000 ;
			DailyManage.getInstance().refreshVo();
			SignalBusManager.onUpdateDaily.dispatch();
			QuestManager.getInstance().refreshDaily();
			QuestDisplayManager.getInstance().questView.traceTasks(true);
		}

		private function vipchange(...arg) : void {
			if(MenuManager.getInstance().checkOpen(MenuType.DAILY)){
				requestDaily();
			}
		}
		
		public function getDailyVar(id : int, index : int = 0) : int {
			return DailyManage.getInstance().getDailyVo(id).getVars()[index];
		}

		public function get weekday() : int {
			var date : Date = new Date() ;
			date.time = date.time + stampoff ;
			return date.day ;
		}
		
		public function requestDaily():void
		{
			Common.game_server.sendMessage(0x13);
		}
	}
}
