package game.manager {
	import gameui.manager.UIManager;

	import net.RESManager;

	import com.commUI.ModuleLoader;

	/**
	 * @author yangyiqiang
	 */
	public class PreLoadManager {
		private static var _instance : PreLoadManager;
		private var _res : RESManager;

		public function PreLoadManager() {
			if (_instance) {
				throw Error("---PreLoadManager--is--a--single--model---");
			}
			init();
		}

		private function init() : void {
			_res = RESManager.instance;
//			Common.game_server.addCallback(0xFFF4, teamChange);
		}

//		private function teamChange(msg : CCTeamChange) : void {
//			var hero : VoHero = HeroManager.instance.getTeamHeroById(msg.uuid);
//			if (hero)
//				hero.preLoad();
//		}

		public static function get instance() : PreLoadManager {
			if (_instance == null) {
				_instance = new PreLoadManager();
			}
			return _instance;
		}
		
		private var _moduleLoader:ModuleLoader;
		public function get moduleLoader() : ModuleLoader {
			if (_moduleLoader == null) {
				_moduleLoader = new ModuleLoader(UIManager.root);
				_moduleLoader.model = RESManager.instance.model;
			}
			return _moduleLoader;
		}
	}
}
