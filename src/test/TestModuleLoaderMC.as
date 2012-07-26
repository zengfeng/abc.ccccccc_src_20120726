package test
{
	import game.config.StaticConfig;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import project.Game;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jian
	 */
	public class TestModuleLoaderMC extends Game
	{
		public function TestModuleLoaderMC()
		{
			super();
		}
		
		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf", "ui")));
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/smallLoader.swf", "smallLoader")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event:Event) : void
		{
			var loaderMC:MovieClip = RESManager.getMC(new AssetData("smallLoading", "smallLoader"));
//			loaderMC.gotoAndStop(1);
			loaderMC.update("测试", 80);
			addChild(loaderMC);
		}
	}
}
