package game.module.bossWar.bossHead {
	import game.definition.UI;
	import game.manager.RSSManager;
	import game.module.quest.VoNpc;

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
	public class BossHeadItem extends GComponent {
		private var bossIMG:GImage;
		public function BossHeadItem() {
			_base = new GComponentData();
            initData();
            super(_base);
            initView();
		}

		private function initData() : void {
			_base.width = 93;
            _base.height = 92;
		}

		private function initView() : void {
			setBgToStage();
			setImgToStage();
		}
		
		public function refreshBossIMG(id:int):void{
			bossIMG.url = UrlUtils.getBossHeadIcon(id);
		}

		private function setImgToStage() : void {
			var data:GImageData = new GImageData();
			data.width = 121;
			data.height = 145;
			data.x = -5-(93/2);
			data.y = -98;
			bossIMG = new GImage(data);
			this.addChild(bossIMG);
		}
		
		private function setBgToStage() : void {
			var bg1:Sprite = UIManager.getUI(new AssetData(UI.HEAD_ICON_BACKGROUND));
			this.addChild(bg1);
		}
	}
}
