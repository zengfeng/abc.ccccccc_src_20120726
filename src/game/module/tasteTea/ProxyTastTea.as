package game.module.tasteTea
{
	import game.net.data.StoC.SCGuildDrinkTea;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.net.core.Common;


	/**
	 * @author Lv
	 */
	public class ProxyTastTea extends EventDispatcher {
		
		
//		public static var tastTeaTime:int = 120;
		
		public function ProxyTastTea(singleton : proxy, target : IEventDispatcher = null) {
			singleton;
			super(target);
			sToC();
		}

        /** 单例对像 */
        private static var _instance : ProxyTastTea;

        /** 获取单例对像 */
        static public function get instance() : ProxyTastTea
        {
            if (_instance == null)
            {
                _instance = new ProxyTastTea(new proxy());
            }
            return _instance;
        }

		private function sToC() : void {
			Common.game_server.addCallback(0x2D1, sCGuildDrinkTea);
		}
		
		/**
		 * 0x2D1
		 * 喝茶
		 */
		private function sCGuildDrinkTea(msg:SCGuildDrinkTea) : void {
//			MenuManager.getInstance().closeMenuView(MenuType.TASTTEA);
			TasteTeaControl.instance.tasteTeaReward( msg.sel , msg.reward );
		}
	}
}
class proxy{}