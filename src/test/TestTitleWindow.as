package test
{
	import flash.events.Event;
	import game.config.StaticConfig;
	import gameui.containers.GTitleWindow;
	import gameui.data.GButtonData;
	import gameui.data.GTitleWindowData;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;

	/**
	 * @author Administrator
	 */
	public class TestTitleWindow extends Game
	{
		
		private var window:GTitleWindow;
		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf","ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void
		{
			addTitleWindow();
		}

		private function addTitleWindow() : void
		{
			var tempData:GTitleWindowData=new GTitleWindowData();
			var close:GButtonData=new GButtonData();
			tempData.parent=this;
			close.width=20;
			close.height=20;
			tempData.closeButtonData=close;
			tempData.allowDrag=true;
			tempData.width=300;
			tempData.height=300;
			window=new GTitleWindow(tempData);
			addChild(window);
		}

		public function TestTitleWindow()
		{
			super();
		}
	}
}
