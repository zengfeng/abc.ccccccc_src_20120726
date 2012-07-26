package test
{
	import flash.events.Event;
	import game.config.StaticConfig;
	import gameui.controls.GProgressBar;
	import gameui.data.GProgressBarData;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;

	/**
	 * @author yangyiqiang
	 */
	public class TestGProgress extends Game
	{
		private var _progressBar : GProgressBar;

		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf","ui")));
			_res.addEventListener(Event.COMPLETE,completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void
		{
			addGProgress();
			addProgressBar();
		}

		private function addGProgress() : void
		{
			var data : GProgressBarData = new GProgressBarData();
			data.max=100;
			_progressBar = new GProgressBar(data);
			_progressBar.setSize(500,20);
			_progressBar.text = "加载第3/4个文件";
			_progressBar.value = 100/1000*100;
			addChild(_progressBar);
		}

		private function addProgressBar() : void
		{
			var data : GProgressBarData = new GProgressBarData();
			data.x = 10;
			data.y = 70;
			data.value = 50;
			data.max = 100;
			addChild(new GProgressBar(data));
			data = data.clone();
			data.mode = GProgressBarData.POLLED;
			data.y = 90;
			addChild(new GProgressBar(data));
		}

		public function TestGProgress()
		{
			super();
		}
	}
}
