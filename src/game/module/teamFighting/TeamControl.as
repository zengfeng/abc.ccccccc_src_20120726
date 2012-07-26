package game.module.teamFighting {
	import game.config.StaticConfig;
	import game.net.core.Common;
	import game.net.data.CtoS.CSEnterCode;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Lv
	 */
	public class TeamControl {
		private static var _instance : TeamControl;

		public function TeamControl(control : Control) : void {
			control;
		}

		public static function get instance() : TeamControl {
			if (_instance == null)
				_instance = new  TeamControl(new Control());
			return _instance;
		}

		var url : URLLoader;
		var arr : Array;

		public function loader() : void {
			url = new URLLoader();
			url.load(new URLRequest(StaticConfig.cdnRoot + ("assets/ui/text.txt")));
			url.addEventListener(Event.COMPLETE, onloader);
		}

		private function onloader(event : Event) : void {
			var str : String = url.data;
			arr = str.split("\r\n");
			var index : int = arr.length;
			for each (var s:String in arr) {
				if (s != "") {
					var cmd : CSEnterCode = new CSEnterCode();
					cmd.code = s;
					Common.game_server.sendMessage(0x0D, cmd);
				}
			}
		}
	}
}
class Control {
}
