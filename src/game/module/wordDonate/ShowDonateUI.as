package game.module.wordDonate
{
	import flash.display.Sprite;
	import game.manager.ViewManager;

	/**
	 * @author Lv
	 */
	public class ShowDonateUI extends Sprite
	{
		private static var _instance:ShowDonateUI;
		public function ShowDonateUI(control:Control):void
		{
		}
		public static function get instance():ShowDonateUI{
			if(_instance == null){
				_instance = new ShowDonateUI(new Control());
			}
			return _instance;
		}
		private var _viewManager : ViewManager;
		
		private function get viewManager() : ViewManager {
			if (_viewManager == null) {
				_viewManager = ViewManager.instance;
			}
			return _viewManager;
		}
		
		public var donatepanel:DonatePanelView;
	}
}
class Control{}
