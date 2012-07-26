package game.module.userBuffStatus {
	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-1 ����2:08:27
	 */
	public class BuffStatusManager {
		function BuffStatusManager(singleton : Singleton) : void {
			singleton;
		}

		/** 单例对像 */
		private static var _instance : BuffStatusManager;

		/** 获取单例对像 */
		public static function get instance() : BuffStatusManager {
			if (_instance == null) {
				_instance = new BuffStatusManager(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 获取指定STATUS */
		public function getStatus(statusId : int) : Status {
			return BuffStatusConfig.getStatus(statusId);
		}

		/** 获取指定BUFF */
		public function getBuff(buffId : int) : Buff {
			return BuffStatusConfig.getBuff(buffId);
		}
		/** 更新STATUS */
		public function updateStatus(value:int) : void {
			for each(var status:Status in BuffStatusConfig.statusDic)
			{
				status.level = (value >> status.bits) & status.mask;
			}
		}

		/** 更新STATUS等级 */
		public function updateStatusLevel(statusId : int, level : int) : void {
			var status : Status = getStatus(statusId);
			if (status == null) return;
			status.level = level;
		}

		/** 更新BUFF时间 */
		public function updateBuffTime(buffId : int, time : int) : void {
			var buff : Buff = getBuff(buffId);
			if (buff == null) return;
			buff.time = time;
		}

		/** 添加指定BUFF回调 */
		public function addStatusCall(statusId : int, fun : Function) : void {
			var status : Status = getStatus(statusId);
			if (status == null) return;
			status.addLevelChangeCall(fun);
		}

		/** 移除指定BUFF回调 */
		public function removeStatusCall(statusId : int, fun : Function) : void {
			var status : Status = getStatus(statusId);
			if (status == null) return;
			status.addLevelChangeCall(fun);
		}

		/** 添加指定BUFF回调 */
		public function addBuffCall(buffId : int, fun : Function) : void {
			var buff : Buff = getBuff(buffId);
			if (buff == null) return;
			buff.addVisibleChangeCall(fun);
		}

		/** 移除指定BUFF回调 */
		public function removeBuffCall(buffId : int, fun : Function) : void {
			var buff : Buff = getBuff(buffId);
			if (buff == null) return;
			buff.removeVisibleChangeCall(fun);
		}
	}
}
class Singleton {
}
