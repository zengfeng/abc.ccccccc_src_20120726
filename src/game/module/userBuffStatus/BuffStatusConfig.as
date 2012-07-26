package game.module.userBuffStatus {
	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-1 ����3:05:09
	 */
	public class BuffStatusConfig {
		/** ID--龟仙拜佛 */
		public static const  BUFF_ID_CONVOY_START : int = 220;
		/** ID--鼓舞 */
		public static const STATUS_ID_INSPIRE : int = 0x700;
		/** ID--国战退出再进一分钟CD */
		public static const BUFF_ID_GROUP_BATTLE_AGAIN_ENTER : int = 0;
		/**  BUFF字典 */
		public static var buffDic : Dictionary = new Dictionary();
		/** STATUS字典 */
		public static var statusDic : Dictionary = new Dictionary();

		public static function getBuff(buffId : int) : Buff {
			return buffDic[buffId];
		}

		public static function getStatus(statusId : int) : Status {
			return statusDic[statusId];
		}

		public static function parseConfig(xml : XML) : void {
			for each (var buffItem:XML in xml..buff) {
				parseBuff(buffItem);
			}

			for each (var statusItem:XML in  xml..status) {
				parseStatus(statusItem);
			}
		}

		public static function parseBuff(xml : XML) : void {
			var buff : Buff = new Buff();
			buff.id = xml.@id;
			buff.iconFile = xml.@icon;
			buff.tipConfig = xml.children()[0];
			buff.tipConfig = buff.tipConfig.replace(/\\n/g, "\n");
			buffDic[buff.id] = buff;
		}

		public static function parseStatus(xml : XML) : void {
			var status : Status = new Status();
			status.id = xml.@id;
			status.mask = xml.@mask;
			status.bits = xml.@bits;
			status.iconFile = xml.@icon;
			var tipDic : Dictionary = status.tipLevelDic;
			for each (var tipItem:XML in xml.tip) {
				var level : int = tipItem.@level;
				var tip : String = tipItem.children()[0];
				tip = tip.replace(/\\n/g, "\n");
				tipDic[level] = tip;
			}
			statusDic[status.id] = status;
		}
	}
}
