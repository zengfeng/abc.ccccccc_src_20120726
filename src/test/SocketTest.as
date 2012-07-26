package test
{
	import flash.events.Event;
	import game.manager.VersionManager;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;




	/**
	 * @author yangyiqiang
	 */
	[SWF(width=1000,height=570,backgroundColor=0x003399,frameRate=30)]
	public class SocketTest extends Game
	{
		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(VersionManager.instance.getUrl("assets/swf/forge.swf"), "forge")));
			_res.addEventListener(Event.COMPLETE, loadComplete);
			_res.startLoad();
		}

		private function loadComplete(event:Event) : void
		{
		}

		public function SocketTest()
		{
		}
	}
}