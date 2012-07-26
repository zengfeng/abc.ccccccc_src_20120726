package test
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import game.config.StaticConfig;
	import net.AssetData;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;
	import project.Game;

	/**
	 * @author yangyiqiang
	 */
	public class TestBD extends Game
	{
		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/dadaonan_front.swf","Numbers")));
			_res.addEventListener(Event.COMPLETE,completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event:Event) : void
		{
			_res.removeEventListener(Event.COMPLETE,completeHandler);
			var bit:MovieClip=RESManager.getMC(new AssetData("text","Numbers"));
			//trace(bit.getChildAt(0)["text"]);
			addChild(bit);
		}

		public function TestBD()
		{
			super();
		}
	}
}
