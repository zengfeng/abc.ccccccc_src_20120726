package  game.module.mapDuplUI
{
	import game.manager.ViewManager;

	import com.commUI.button.ExitButton;
	import com.utils.UIUtil;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;


	/**
	 *  @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-4-17
	 */
	public class DuplMapUIC
	{
		function DuplMapUIC():void
		{
			initViews();
		}
		
		/** 单例对像 */
		private static var _instance : DuplMapUIC;
		/** 获取单例对像 */
		public static function get instance() : DuplMapUIC {
			if (_instance == null) {
				_instance = new DuplMapUIC();
			}
			return _instance;
		}
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var exitButton:ExitButton;
		public var nextDoButton:NextDoButton;
		public function initViews():void
		{
			exitButton = ExitButton.instance;
			nextDoButton = new NextDoButton();
		}
		
		public var onClickExitCall:Function;
		public function onClickExit():void
		{
			if(onClickExitCall != null) onClickExitCall.apply();
		}
		
		public function layout(event:Event = null):void
		{
			nextDoButton.x = (stage.stageWidth - nextDoButton.width) / 2;
			nextDoButton.y = 70;
		}
		
		private var _visible:Boolean = false;
		public function get visible():Boolean
		{
			return _visible;
		}
		public function set visible(value:Boolean):void
		{
			_visible = value;
			if(value == true)
			{
				layout();
				exitButton.setVisible(true, onClickExit);
				if(nextDoButton.parent == null ) parent.addChild(nextDoButton);
				stage.addEventListener(Event.RESIZE, layout);
			}
			else
			{
				stage.removeEventListener(Event.RESIZE, layout);
				exitButton.setVisible(false, null);
				if(nextDoButton.parent != null ) nextDoButton.parent.removeChild(nextDoButton);
			}
		}
		
		// ===================
		// 常用Getter
		// ===================
		private var _stage : Stage;
		public function get stage() : Stage
		{
			if (_stage) return _stage;
			_stage = UIUtil.stage;
			return _stage;
		}
		
		private  var _parent:DisplayObjectContainer;
		public function get parent():DisplayObjectContainer
		{
			if (_parent) return _parent;
			_parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			return _parent;
		}
	}
}

