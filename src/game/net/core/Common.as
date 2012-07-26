package game.net.core {
	import game.config.StaticConfig;
	import game.net.data.CtoS.CSUserLogin;
	import game.net.socket.SocketClient;
	import game.net.socket.SocketData;

	import log4a.Logger;

	import model.LocalSO;

	import com.commUI.CommonLoading;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public final class Common {
		/** socket接口 **/
		public static var game_server : SocketClient = new SocketClient();
		/**
		 * LocalSO 本地存储
		 */
		public static var los : LocalSO = new LocalSO("ktpd");
		// /** 只对本包可见**/
		public static var messageDic : Dictionary = new Dictionary(true);
		private static var _instance : Common;
		private var _load_lm : CommonLoading;

		public function get loadPanel() : CommonLoading {
			if (_load_lm == null) {
				_load_lm = new CommonLoading();
			}
			return _load_lm;
		}

		public function Common() : void {
			loadPanel;
		}

		public static function getInstance() : Common {
			if ( _instance == null) {
				_instance = new Common();
			}
			return _instance as Common;
		}

		public function init(str : String, id : String, key : String) : void {
			initConfing();
			initSocketData(str, id, key);
		}

		public function initConfing() : void {
			ProtoConfig.initConfing();
		}

		private function initSocketData(str : String, id : String, key : String) : void {
			var _arr : Array = str.split("|");
			for (var i : int = 0;i < _arr.length;i++) {
				var _servers : Array = String(_arr[i]).split(":");
				game_server.connect(new SocketData(i.toString(), _servers[0], Number(_servers[1])));
			}
			game_server.addEventListener(Event.CONNECT, function(event : Event) : void {
				var loginCmd : CSUserLogin = new CSUserLogin();
				loginCmd.id = id;
				loginCmd.key = key;
				if (StaticConfig.fcm != -1)
					loginCmd.wallow = StaticConfig.fcm;
				game_server.sendMessage(0x02, loginCmd);
				Logger.debug("sendMessage===>" + 0x02);
			});
		}
	}
}
