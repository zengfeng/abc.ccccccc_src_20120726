package com.commUI.button
{
	import flash.events.Event;

	import com.utils.UIUtil;

	import game.manager.ViewManager;

	import gameui.controls.GButton;
	import gameui.data.GButtonData;

	import flash.events.MouseEvent;

	/**
	 *  @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-4-13
	 */
	public class ExitButton extends GButton
	{
		/** 单例对像 */
		private static var _instance : ExitButton;

		/** 获取单例对像 */
		public static function get instance() : ExitButton
		{
			if (_instance == null)
			{
				_instance = new ExitButton(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var onClickCall : Function;

		function ExitButton(singleton : Singleton)
		{
			singleton;
			var data : GButtonData = new KTButtonData(KTButtonData.EXIT_BUTTON);
			super(data);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event : MouseEvent) : void
		{
			if (onClickCall != null)
			{
				onClickCall.apply();
			}
		}

		override public function get visible() : Boolean
		{
			return _visible;
		}

		private var _visible : Boolean = false;

		public function setVisible(value : Boolean, onClickCall : Function) : void
		{
			_visible = value;
			super.visible = value;
			if (value == true)
			{
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).addChild(this);
				unpteLayout();
				UIUtil.stage.addEventListener(Event.RESIZE, unpteLayout);
				this.onClickCall = onClickCall;
			}
			else
			{
				UIUtil.stage.removeEventListener(Event.RESIZE, unpteLayout);
				if (parent) parent.removeChild(this);
				this.onClickCall = null;
			}
		}

		private function unpteLayout(event : Event = null) : void
		{
			x = UIUtil.stage.stageWidth - width - 20;
			y = 20;
		}
	}
}
class Singleton
{
}
