package game.module.chatwhisper
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����2:35:00 
	 */
	public class ManagerWhisper extends EventDispatcher
	{
		private static var _instance : ManagerWhisper;

		public function ManagerWhisper(target : IEventDispatcher = null)
		{
			super(target);
			ProtoStoCWhisper.instance;
		}

		public static function get instance() : ManagerWhisper
		{
			if (_instance == null)
			{
				_instance = new ManagerWhisper();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 控制器 */
		private var controller : ControllerWhisper = ControllerWhisper.instance;

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 显示某某玩家的私聊窗口 */
		public function showWindowByPlayerName(playerName : String) : void
		{
			controller.showWindowByPlayerName(playerName);
		}

		/** 是否显示窗口 */
		public function set isShowWindow(value : Boolean) : void
		{
			controller.isShowWindow = value;
		}

		public function get isShowWindow() : Boolean
		{
			return controller.isShowWindow;
		}
	}
}
