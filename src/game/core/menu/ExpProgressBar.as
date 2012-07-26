package game.core.menu
{
	import gameui.data.GToolTipData;
	import net.AssetData;
	import gameui.manager.UIManager;
	import flash.display.Sprite;
	import gameui.controls.GProgressBar;
	import gameui.data.GProgressBarData;

	/**
	 * @author yangyiqiang
	 */
	public class ExpProgressBar extends GProgressBar
	{
		private var _modeSkin : Sprite;

		public function ExpProgressBar()
		{
			var data : GProgressBarData = new GProgressBarData();
			data.trackAsset = new AssetData("ProgressBar_Exp_Bg");
			data.barAsset = new AssetData("ProgressBar_Exp_Value");
			data.toolTipData=new GToolTipData();
			data.height=8;
			data.width=643;
			super(data);
		}

		override protected function create() : void
		{
			_modeSkin=UIManager.getUI(new AssetData("ProgressBar_Exp_Fg"));
			super.create();
			_trackSkin.addChild(_barSkin);
			_trackSkin.addChild(_modeSkin);
		}
	}
}
