package game.module.formation {
	import game.config.StaticConfig;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.formation.centralPanel.CentralPanel;
	import game.module.formation.headPanel.HeadPanel;
	import game.module.formation.upgrade.UpgradePanel;

	import gameui.core.GAlign;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.LibData;

	import com.commUI.GCommonWindow;

	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	public class FormationView extends GCommonWindow  implements IModuleInferfaces ,IAssets {
		private var headView : HeadPanel;
		private var upgrade : UpgradePanel;
		private var central : CentralPanel;

		public function FormationView() {
			_data = new GTitleWindowData();
			super(_data);
			initEvents();
		}

		override protected function initData() : void {
			_data.width = 715;
			_data.height = 368;
			_data.allowDrag = true;
			_data.parent = ViewManager.instance.uiContainer;
			super.initData();
		}

		private function initEvents() : void {
		}

		public function initModule() : void {
			title = "阵型";
			super.initViews();
			addBG();
			addPanel();
		}

		private function addPanel() : void {
			headView = FMControler.instance.headMC();
			headView.x = 11;
			headView.y = 30;
			_contentPanel.addChild(headView);
			upgrade = FMControler.instance.upgrade();
			upgrade.x = 519;
			upgrade.y = 30;
			_contentPanel.addChild(upgrade);
			central = FMControler.instance.centralMC();
			central.y = 30;
			central.x = 163;
			_contentPanel.addChild(central);
			FMControlPoxy.isOpender = true;
			FMControler.instance.changeFmToCenMC(FMControlPoxy.startFmK);
		}

		// ---------------------------------------------------------------
		private function addBG() : void {
			var bg : Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			bg.x = 5;
			bg.y = 5;
			bg.width = 700;
			bg.height = 355;
			_contentPanel.addChild(bg);
		}

		override protected function onShow() : void {
			super.onShow();
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2, -1, (UIManager.stage.stageHeight - this.height) / 2, -1);
		}

		override protected function onHide() : void {
			super.onHide();
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2, -1, (UIManager.stage.stageHeight - this.height) / 2, -1);
		}

		public function getResList() : Array {
			return [new LibData(StaticConfig.cdnRoot + "assets/ui/formation.swf", "FMSwf")];
		}
	}
}
