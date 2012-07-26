package game.module.wordDonate {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;

	/**
	 * @author Lv
	 */
	public class DonateControl {
		private static var _instance : DonateControl;

		public function DonateControl(control : Control) : void {
		}

		public static function get instance() : DonateControl {
			if (_instance == null) {
				_instance = new DonateControl(new Control());
			}
			return _instance;
		}

		private var donate : DonatePanelView;
		private var list : ContributionList;

		// 贡献面板
		public function setupDonateUI() : void {
			donate = MenuManager.getInstance().changMenu(MenuType.DONATE).target as DonatePanelView;
		}

		// 排行列表
		public function setupListUI() : void {
			if (!list) {
				list = new ContributionList();
				MenuManager.getInstance().getMenuButton(MenuType.DONATECONTRIBUTION).target = list;
			}
			if (!donate)
				DonateProxy.instance.applyNow();
			DonateProxy.instance.applyList();
			DonateProxy.instance.applyCount();
			MenuManager.getInstance().changMenu(MenuType.DONATECONTRIBUTION);
		}

		// 刷新排名列表
		public function refershList() : void {
			if (list == null) return;
			list.setList();
		}

		// 刷新贡献面板
		public function refershDoante() : void {
			if (donate == null) return;
			donate.setPanel();
		}
		
		public function refrePage():void{
			if (list == null) return;
			list.refreshPage();
		}
	}
}
class Control {
}
