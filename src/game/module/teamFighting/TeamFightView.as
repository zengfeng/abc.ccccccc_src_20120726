package game.module.teamFighting {
	import game.module.teamFighting.teamList.PlayerItem;
	import game.config.StaticConfig;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.definition.UI;
	import game.manager.ViewManager;

	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.LibData;

	import com.commUI.GCommonWindow;

	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	public class TeamFightView extends GCommonWindow implements IModuleInferfaces ,IAssets {
		public function TeamFightView() {
			_data = new GTitleWindowData();
			super(_data);
			initEvents();
			
		}
		
		override protected function initData() : void {
			_data.width = 428;
			_data.height = 450;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;
			super.initData();
		}

		private function initEvents() : void {
		}
		
		public function initModule() : void {
			title = "组队炼妖";
			setBg();
			var item:PlayerItem = new PlayerItem();
			item.x = 50;
			item.y = 50;
			this.addChild(item);
			
		}

		private function setBg() : void {
			var bg : Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			bg.x = 5;
			bg.y = 5;
			bg.width = 413;
			bg.height = 440;
			_contentPanel.addChild(bg);
		}
		
		public function getResList() : Array {
			return [new LibData(StaticConfig.cdnRoot + ("assets/ui/teamFighting.swf"), "teamFighting")];
		}
	}
}
