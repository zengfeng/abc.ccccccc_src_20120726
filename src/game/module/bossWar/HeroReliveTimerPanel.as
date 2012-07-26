package game.module.bossWar {
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.controls.GLabel;
	import gameui.controls.GButton;
	import gameui.skin.SkinStyle;
	import net.AssetData;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;

	/**
	 * @author Lv
	 */
	public class HeroReliveTimerPanel extends GPanel {
		
		private var speedBtn:GButton;
		private var overTiemrStr:GLabel;
		
		public function HeroReliveTimerPanel() {
			_data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 75;
			_data.height = 15;
			_data.bgAsset=new AssetData(SkinStyle.emptySkin);   //取消背景
		}

		private function initEvent() : void {
		}

		private function initView() : void {
			addPanel();
		}

		private function addPanel() : void {
			var data:GLabelData = new GLabelData();
			data.text = "等待99秒复活……";
			data.textFormat.size = 10;
			overTiemrStr = new GLabel(data);
			_content.addChild(overTiemrStr);
			
			var dataBtn:GButtonData = new GButtonData();
			dataBtn.labelData.text = "加速";
			dataBtn.labelData.textFormat.size = 11;
			dataBtn.height = 14;
			dataBtn.x = 75 - dataBtn.width-1;
			speedBtn = new GButton(dataBtn);
			_content.addChild(speedBtn);
		}
		
	}
}
