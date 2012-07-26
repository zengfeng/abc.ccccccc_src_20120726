package game.module.daily {
	import game.manager.DailyInfoManager;
	import game.manager.SignalBusManager;
	import game.net.core.Common;

	/**
	 * @author yangyiqiang
	 */
	public class DailyManage {
		// =====================
		public static const ID_QUEST : uint = 1;
		public static const ID_CONVOY : uint = 2;
		public static const ID_FISHING : uint = 3;
		public static const ID_AXE : uint = 4;
		public static const ID_COMPETE : uint = 5;
		public static const ID_GROUP_BATTLE : uint = 7;
		public static const ID_MINING : uint = 10;
		public static const ID_FEAST : uint = 9 ;
		public static const STATE_UNOPEN : uint = 1;
		public static const STATE_OPENED : uint = 2;
		public static const STATE_ENDED : uint = 3;
		public static const BOSS_WAR : uint = 6;
		// =====================
		private static var _instance : DailyManage;

		public function DailyManage() {
			if (_instance)
				throw Error("DailyInfoManager 是单类，不能多次初始化!");
			initiate();
		}

		private function initiate() : void {
			SignalBusManager.updateDaily.add(refreshDailyVars);
			Common.game_server.addCallback(0xFFF7, refresh);
		}

		public static var WEEKDAY : Array = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
		private var _dailyDic : Vector.<VoDaily> = new Vector.<VoDaily>();
		private var _actionDic : Vector.<VoAction> = new Vector.<VoAction>();
		private var _noticeDic : Vector.<VoNotice> = new Vector.<VoNotice>() ;
		private var _array : Array = [_dailyDic, _actionDic, _noticeDic];

		public static function getInstance() : DailyManage {
			if (_instance == null)
				_instance = new DailyManage();
			return _instance;
		}

		public function initDailyVo(vo : VoDaily) : void {
			_dailyDic.push(vo);
		}

		public function initActionVo(vo : VoAction) : void {
			_actionDic.push(vo);
		}

		public function initNoticeVo(vo : VoNotice) : void {
			_noticeDic.push(vo);
		}

		public function refresh(...arg) : void {
			for each (var vo:VoDaily in _dailyDic) {
				vo.refresh();
			}
		}

		public function refreshVo() : void {
			var arr : Array;
			for each (var vo:VoDaily in _dailyDic) {
				arr = initData(vo.id);
				refreshDailyVars(vo.id, arr[2], arr[0], arr[1]);
			}
		}

		public function getVos(type : int = 0) : * {
			return _array[type];
		}

		public function getDailyVo(id : int) : VoDaily {
			for each (var vo:VoDaily in _dailyDic) {
				if (vo.id == id) return vo;
			}
			return vo;
		}

		private function refreshDailyVars(id : int, state : int, var1 : int, var2 : int = 0) : void {
			for each (var vo:VoDaily in _dailyDic) {
				if (vo.id == id) {
					vo.refreshVars(var1, var2, state);
					break;
				}
			}
		}

		/*
		 * <item id="6" name="BOSS战" description="开启时间：12:30-13:30" description2="挑战boss可获得经验、银币和修为奖励"
		<item id="7" name="蜀山论剑" description="开启时间：20:00-20:30" description2="参加可获得大量的修为、千年玄铁和银币奖励"
		<!--item id="8" name="守卫唐僧" description="开启时间：19:00-19:30" description2="成功保护唐僧，可获得经验、银币和修为奖励"
		<item id="9" name="蓬莱仙会" description="开启时间：周二与周五20:45-21:15" description2="变身后找寻与之最佳派对的角色，获得大量经验和修为"
		 */
		private function initData(id : int) : Array {
			var _vars : Array = [0, 0, 2];
			var vo : VoDaily = getDailyVo(id);
			if (!vo) return _vars;
			switch(id) {
				case 1:
					_vars[0] = (DailyInfoManager.dailyValue & 0xff000000) >> 24;
					if (_vars[0] == 0) _vars[2] = 2;
					break;
				case 2:
					_vars[0] = (DailyInfoManager.dailyValue & 0xf0) >> 4;
					_vars[1] = (DailyInfoManager.dailyValue & 0xf00) >> 8;
					break;
				case 3:
					_vars[0] = (DailyInfoManager.dailyValue & 0xf000) >> 12;
					break;
				case 4:
					// _vars[0] = (DailyInfoManager.dailyValue & 0xf0000) >> 16;
					break;
				case 5:
					_vars[0] = (DailyInfoManager.dailyValue & 0xff0000) >> 16;
					break;
				case 6:
					if (vo.state == -1)
						_vars[2] = DailyInfoManager.dailyStatus & 0x3;
					break;
				case 7:
					if (vo.state == -1)
						_vars[2] = (DailyInfoManager.dailyStatus & 0x30) >> 4;
					break;
				case 8:
					if (vo.state == -1)
						_vars[2] = (DailyInfoManager.dailyStatus & 0xC0) >> 6;
					break;
				case 9:
					if (vo.state == -1)
						_vars[2] = (DailyInfoManager.dailyStatus & 0xC) >> 2;
					break;
				case 10:
					_vars[0] = DailyInfoManager.dailyValue & 0xf;
					break;
			}
			return _vars;
		}
	}
}
