package game.module.teamFighting.headItem {
	import game.definition.UI;

	import gameui.controls.GImage;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.UrlUtils;

	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	public class HeroHeadItem extends GComponent {
		private var bossIMG:GImage;
		public function HeroHeadItem() {
			_base = new GComponentData();
            initData();
            super(_base);
            initView();
		}

		private function initData() : void {
			_base.width = 50;
            _base.height = 50;
		}

		private function initView() : void {
			setBgToStage();
			setImgToStage();
		}
		
		public function refresHeroIMG(id:int):void{
			bossIMG.url = UrlUtils.getBossHeadIcon(id);
			bossIMG.scaleX =  0.55;
			bossIMG.scaleY =  0.55;
		}

		private function setImgToStage() : void {
			var data:GImageData = new GImageData();
			data.x = -6;
			data.y = -(145 * 0.55-25)-1;
			bossIMG = new GImage(data);
			this.addChild(bossIMG);
		}
		
		private function setBgToStage() : void {
			var bg1:Sprite = UIManager.getUI(new AssetData(UI.HEAD_ICON_BACKGROUND));
			bg1.width = 50;
            bg1.height = 50;
			this.addChild(bg1);
		}
	}
}
