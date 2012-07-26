package test
{
	import game.net.core.Common;
	import game.net.data.StoC.SCSellItem;

	import gameui.data.GTitleWindowData;

	import com.commUI.GCommonWindow;

	/**
	 * @author yangyiqiang
	 */
	public class TestModule extends GCommonWindow
	{
		public function TestModule()
		{
			_data = new GTitleWindowData();
			_data.width = 380;
			_data.height = 435;
			_data.allowDrag = true;
			super(_data);
			initEvents();
		}

		protected function initEvents() : void
		{
			Common.game_server.addCallback(0x202, sellCallback);
		}

		private function sellCallback(msg : SCSellItem) : void
		{
			//trace("msg.result====>" + msg.result);
		}
	}
}
