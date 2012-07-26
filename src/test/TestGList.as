package test
{
	import flash.events.Event;
	import game.config.StaticConfig;
	import gameui.controls.GList;
	import gameui.data.GListData;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;




	
	/**
	 * @author yangyiqiang
	 */
	public class TestGList extends Game
	{
		public function TestGList()
		{
			super();
		}
		
		override protected function initGame():void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf", "ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}
		private var _list:GList;
		
		private function completeHandler(event:Event):void
		{
			_res.removeEventListener(Event.COMPLETE, completeHandler);
			initList();
		}
		
		private function initList():void
		{
			var listData:GListData = new GListData();
			_list = new GList(listData);
			_list.model.max = -1;
			addChild(_list);
			for (var i:int = 0; i < 10; i++)
			{
				_list.model.add(new Object());
			}
		}
	}
}
