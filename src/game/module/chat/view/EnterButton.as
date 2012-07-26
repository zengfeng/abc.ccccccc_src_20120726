package game.module.chat.view
{
	import com.commUI.button.KTButtonData;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import game.module.chat.config.ChatConfig;
	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;
	import net.AssetData;
	import net.RESManager;






	public class EnterButton extends GComponent
	{
		/** 发送事名称 */
		public static const ENTER : String = "enter";
		/** 按钮 */
		public var button : GButton;
		/** CD */
		public var cd : MovieClip;

		public function EnterButton()
		{
			_base = new GComponentData();
			_base.width = 47;
			_base.height = 26;
			super(_base);
		}

		/** 初始化子组件 */
		override protected function create() : void
		{
			var buttonData : GButtonData = new KTButtonData(KTButtonData.ALERT_BUTTON);
			buttonData.width = 47;
			buttonData.height = 26;
			button = new GButton(buttonData);
			var buttonIcon : Sprite = UIManager.getUI(new AssetData("ButtonIcon_Enter"));
			buttonIcon.x = (button.width - buttonIcon.width) / 2;
			buttonIcon.y = (button.height - buttonIcon.height) / 2;
			button.addChild(buttonIcon);
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, button_clickHandler);
			// cd
			cd = RESManager.getMC(new AssetData("ItemCD"));
			if (cd)
			{
				cd.alpha = 0.8;
				cd.width = button.width;
				cd.height = button.height;
				cd.x = button.width / 2;
				cd.y = button.height / 2;
			}
			closeCD();
		}

		public var cdObj : Object = {cdFrame:1};
		private var cdTweenLite : TweenLite;

		public function openCD(time : int, startFrame : int = 1) : void
		{
			if (cd)
			{
				cdObj["cdFrame"] = startFrame > 0 ? startFrame : 1;
				addChild(cd);
				if (cdTweenLite) cdTweenLite.kill();
				cdTweenLite = TweenLite.to(cdObj, time / 1000, {cdFrame:101, onUpdate:runCD, onComplete:closeCD});
			}
		}

		private function runCD() : void
		{
			cd.gotoAndStop(int(cdObj["cdFrame"]));
		}

		public function closeCD() : void
		{
			if (cd)
			{
				if (cdTweenLite) cdTweenLite.kill();
				cd.gotoAndStop(101);
				if (cd.parent) cd.parent.removeChild(cd);
			}
		}

		private function button_clickHandler(event : MouseEvent) : void
		{
			var e : Event = new Event(EnterButton.ENTER, true);
			dispatchEvent(e);
		}
	}
}