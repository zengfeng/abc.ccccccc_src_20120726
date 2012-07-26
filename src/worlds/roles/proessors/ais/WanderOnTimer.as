package worlds.roles.proessors.ais {
	import worlds.auxiliarys.TimerChannel;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-8
	 */
	public class WanderOnTimer {
		private static var callList : Vector.<Function> = new Vector.<Function>();
		private static var runing : Boolean = false;
		private static var index : int = 0;

		public static function add(fun : Function) : void {
			var index : int = callList.indexOf(fun);
			if (index == -1) {
				callList.push(fun);
				if (callList.length == 1) start();
			}
		}

		public static function remove(fun : Function) : void {
			var index : int = callList.indexOf(fun);
			if (index != -1) {
				callList.splice(index, 1);
				if (callList.length == 0) stop();
			}
		}

		private static function start() : void {
			if (runing == false) {
//				TimerChannel.add(TimerChannel.TIME_1000, onTimer);
				TimerChannel.add(TimerChannel.TIME_1000, onTimer);
				runing = true;
			}
		}

		private static function stop() : void {
			if (runing == true) {
//				TimerChannel.remove(TimerChannel.TIME_1000, onTimer);
				TimerChannel.remove(TimerChannel.TIME_1000, onTimer);
				runing = false;
			}
		}

		// private static var tempFun : Function;
		//
		// private static function onTimer() : void
		// {
		// if (index >= callList.length) index = 0;
		// tempFun = callList[index];
		// tempFun();
		// tempFun = null;
		// index++;
		// }
		private static var tempFun : Function;

		private static function onTimer() : void {
			if (callList.length > 1) {
				if (index >= callList.length) index = 0;
				var num : int = callList.length * 0.1;
				if (num == 0) num = 1;
				num = index + num;
				if (num > callList.length) num = callList.length;
				for (index; index < num; index++) {
					tempFun = callList[index];
					tempFun();
				}
			} else if (callList.length > 0) {
				tempFun = callList[0];
				tempFun();
			}
			tempFun = null;
		}
	}
}
