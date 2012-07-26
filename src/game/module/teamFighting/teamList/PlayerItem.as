package game.module.teamFighting.teamList {

	import game.module.teamFighting.headItem.HeroHeadItem;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	public class PlayerItem extends GComponent {
		
		private var playerItem:HeroHeadItem;
		
		public function PlayerItem() {
			_base = new GComponentData();
            initData();
            super(_base);
            initView();
			initEvent();
		}

		private function initData() : void {
			_base.width = 167;
            _base.height = 50;
		}

		private function initEvent() : void {
		}

		private function initView() : void {
			setBg();
			setPlayerHead();
		}

		private function setPlayerHead() : void {
			playerItem = new HeroHeadItem();
			this.addChild(playerItem);
		}

		private function setBg() : void {
			var bg1:Sprite = UIManager.getUI(new AssetData("headItem","teamFighting"));
			bg1.x = 167 - bg1.width;
			this.addChild(bg1);
		}
	}
}
