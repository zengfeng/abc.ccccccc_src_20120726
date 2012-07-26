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
	 * @author jian
	 */
	public class TestResLoader extends Game
	{
		override protected function initGame():void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/test.swf", "ui")));
//			_res.add(new SWFLoader(new LibData(VersionManager.instance.getUrl("module/chat/chat.swf"), "chat")));
			_res.addEventListener(Event.COMPLETE, loadComplete);
			_res.startLoad();
		}
		private var _mc:MovieClip;
		private function loadComplete(evt : Event) : void {
			_res.removeEventListener(Event.COMPLETE, loadComplete);
			_mc=RESManager.getMC(new AssetData("abyss_gold_summon_button_over","ui"));
			_mc.addEventListener("oooo", listener);
		}

		private function listener(event:Event) : void
		{
			//trace("00000000000000");
		}
	}
}
