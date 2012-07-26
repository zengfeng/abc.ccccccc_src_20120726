package game.module.heroPanel
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.definition.UI;
	import gameui.controls.GProgressBar;
	import gameui.data.GProgressBarData;
	import gameui.manager.UIManager;
	import net.AssetData;






	/**
	 * @author ME
	 */
	public class HeroExperienceBar extends GProgressBar
	{
		private static const NUM_CUTS : uint = 4;
		private var _cutsLayer : Sprite;

		public function HeroExperienceBar(data : GProgressBarData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			addCuts();
			setChildIndex(_label, numChildren - 1);
			_label.alpha = 0;
		}

		private function addCuts() : void
		{
			_cutsLayer = new Sprite();
			for (var i : uint = 0; i < NUM_CUTS; i++)
			{
				var cut : Sprite = UIManager.getUI(new AssetData(UI.HERO_EXPERIENCE_BAR_CUT));

				cut.x = this.width / (NUM_CUTS + 1) * (i + 1) - 4;
				cut.y = 1;
				cut.height = this.height - 2;
				_cutsLayer.addChild(cut);
			}
			addChild(_cutsLayer);
		}

		override protected function onShow() : void
		{
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}

		override protected function onHide() : void
		{
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}

		private function rollOverHandler(event : MouseEvent) : void
		{
			TweenLite.to(_label, 0.17, {alpha:1});
			TweenLite.to(_cutsLayer, 0.17, {alpha:0});
		}

		private function rollOutHandler(event : MouseEvent) : void
		{
			TweenLite.to(_label, 0.17, {alpha:0});
			TweenLite.to(_cutsLayer, 0.17, {alpha:1});
		}
	}
}
