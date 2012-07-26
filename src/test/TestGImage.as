package test
{
	import flash.events.Event;
	import game.config.StaticConfig;
	import gameui.controls.GImage;
	import gameui.data.GImageData;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;





	/**
	 * @author yangyiqiang
	 */
	public class TestGImage extends Game
	{
		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf", "ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private var _img : GImage;
		private var _img2 : GImage;

		private function completeHandler(event : Event) : void
		{
			var data : GImageData = new GImageData();
			data.x = 100;
			data.y = 100;
			_img = new GImage(data);
			_img.url = StaticConfig.cdnRoot + "assets/goods/ys0001.swf";
			addChild(_img);
			var data2 : GImageData = new GImageData();
			data2.x = 400;
			data2.y = 300;
			_img2 = new GImage(data2);
			_img2.url = StaticConfig.cdnRoot + "assets/goods/ys0001.swf";
			addChild(_img2);
		}

		public function TestGImage()
		{
			super();
		}
	}
}
