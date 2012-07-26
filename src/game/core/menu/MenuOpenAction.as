package game.core.menu
{
	import flash.geom.Point;

	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	import game.manager.ViewManager;
	import game.module.quest.QuestDisplayManager;
	import game.module.quest.guide.GuideMange;

	import gameui.controls.GButton;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;

	import net.AssetData;
	import net.RESManager;

	/**
	 * @author yangyiqiang
	 */
	public class MenuOpenAction extends GComponent
	{
		private var _back : MovieClip;

		private var _button : GButton;

		private var _textFild : TextField;

		private var _img : DisplayObject;

		private var _list : Vector.<ActionData>=new Vector.<ActionData>();

		private var _isRun : Boolean = false;

		private var _current : ActionData;

		private var _openMc : MovieClip;

		public function getOpenMc() : MovieClip
		{
			if (!_openMc)
			{
				if (!_openMc)
					_openMc = RESManager.getMC(new AssetData("menuAction", "quest"));
			}
			_openMc.gotoAndStop(1);
			return _openMc;
		}

		public function showFlash(vo : VoMenuButton, _x : Number, _y : Number, fun : Function, endFun : Function, container : Sprite) : void
		{
			if (_list.length > 0 || _isRun)
				_list.push(new ActionData(vo, _x, _y, fun, endFun, container));
			else
			{
				execute(new ActionData(vo, _x, _y, fun, endFun, container));
			}
		}

		private static var modalSkin : Sprite = ASSkin.emptySkin;

		private function execute(data : ActionData) : void
		{
			_isRun = true;
			if (data == null)
			{
				QuestDisplayManager.getInstance().showWait();
				_isRun = false;
				return;
			}
			_current = data;
			addMode();
			ViewManager.instance.getContainer(ViewManager.IOC_CONTAINER).addChild(this);
			//trace("UIManager.root.addChild(this)");
			this.alpha = 0;
			TweenLite.to(this, 0.5, {alpha:1, overwrite:0});
			if (_img && _img.parent) _img.parent.removeChild(_img);
			_img = _current.vo.disObj;
			_img.x = (UIManager.stage.stageWidth - _img.width) / 2;
			_img.y = (UIManager.stage.stageHeight - _img.height) / 2 - 30;
			_img.filters = [new GlowFilter(0xFFCC00, 1, 15, 15, 1)];
			UIManager.root.addChild(_img);
			//trace("UIManager.root.addChild(_img)");
			_textFild.htmlText = StringUtils.addBold(data.vo.description);
			addChild(_textFild);
			this.x=(UIManager.stage.stageWidth - this.width) / 2;
			this.y=(UIManager.stage.stageHeight - this.height) / 2;
			GuideMange.getInstance().moveTo(110, 135, "点击", this);
			ViewManager.addStageResizeCallFun(onResize);
		}

		private function onResize(...args) : void
		{
			if (!_img) return;
			_img.x = (UIManager.stage.stageWidth - _img.width) / 2;
			_img.y = (UIManager.stage.stageHeight - _img.height) / 2 - 30;
		}

		private function onClick(event : MouseEvent) : void
		{
			_button.removeEventListener(MouseEvent.CLICK, onClick);
			TweenLite.to(this, 1, {alpha:0, overwrite:0, onComplete:hide});
			TweenLite.to(_img, 1.5, {x:_current.x, y:_current.y, ease:Circ.easeIn, overwrite:0, onComplete:complete, onCompleteParams:[_img, _current.fun]});
		}

		private function complete(mc : DisplayObject, fun : Function) : void
		{
			if (mc && mc.parent) mc.parent.removeChild(mc);
			if (_img && _img.parent) _img.parent.removeChild(_img);
			this.hide();
			if (fun != null) fun();
			getOpenMc();
			_openMc.gotoAndPlay(1);
			_openMc.addEventListener("endFlash", onEnd);
			_openMc.x = _current.mcPointX;
			_openMc.y = _current.mcPointY;
			_current.container.addChild(_openMc);
		}

		public function playComplete(mc : DisplayObject, fun : Function, point : Point, view : Sprite) : void
		{
			if (mc && mc.parent) mc.parent.removeChild(mc);
			if (fun != null) fun();
			getOpenMc();
			_openMc.gotoAndPlay(1);
			_openMc.addEventListener("endFlash", playEnd);
			_openMc.x = point.x;
			_openMc.y = point.y;
			view.addChild(_openMc);
		}

		private function playEnd(event : Event) : void
		{
			if (_openMc)
			{
				if (  _openMc.parent)
					_openMc.parent.removeChild(_openMc);
				_openMc.removeEventListener("endFlash", onEnd);
			}
		}

		private function onEnd(event : Event) : void
		{
			if (_current.endFun != null) _current.endFun();
			_openMc.removeEventListener("endFlash", onEnd);
			if (_openMc && _openMc.parent) _openMc.parent.removeChild(_openMc);
			execute(_list.pop());
		}

		override protected function layout() : void
		{
			GLayout.layout(_button);
		}

		override protected function create() : void
		{
			_back = RESManager.getMC(new AssetData("openAction", "quest"));
			addChild(_back);
			var data : GButtonData = new GButtonData();
			data.align = new GAlign(-1, -1, -1, 20, 0);
			data.width = 80;
			data.height = 30;
			_button = new GButton(data);
			_button.text = "确定";
			addChild(_button);
			_textFild = UICreateUtils.createTextField("", null, this.width, 20, 0, 110, UIManager.getTextFormat(14, 0xFFE400, TextFormatAlign.CENTER));
			_textFild.filters = [new DropShadowFilter(0, 45, 0x000000, 1, 3, 3, 5)];
		}

		override protected function onShow() : void
		{
			_button.addEventListener(MouseEvent.CLICK, onClick);
			//trace("UIManager.root.onShow");
			if (_img)
			{
				UIManager.root.addChild(_img);
			}
		}

		override protected function onHide() : void
		{
			removeMode();
			_button.removeEventListener(MouseEvent.CLICK, onClick);
			ViewManager.removeStageResizeCallFun(onResize);
		}

		private  function addMode() : Sprite
		{
			if (!modalSkin)
				modalSkin = ASSkin.emptySkin;
			modalSkin.width = UIManager.stage.stageWidth;
			modalSkin.height = UIManager.stage.stageHeight;
			if (!ViewManager.instance.getContainer(ViewManager.IOC_CONTAINER).contains(modalSkin))
				ViewManager.instance.getContainer(ViewManager.IOC_CONTAINER).addChild(modalSkin);
			return modalSkin;
		}

		private  function removeMode() : Sprite
		{
			if (modalSkin && modalSkin.parent)
			{
				modalSkin.parent.removeChild(modalSkin);
			}
			return modalSkin;
		}

		private static var _instance : MenuOpenAction;

		public static function get instance() : MenuOpenAction
		{
			if (_instance == null)
			{
				_instance = new MenuOpenAction(new Singleton());
			}
			return _instance;
		}

		public function MenuOpenAction(sing : Singleton)
		{
			sing;
			_base = new GComponentData();
			_base.width = 620;
			_base.height = 200;
			_base.align = new GAlign(-1, -1, -1, -1, 0, 0);
			super(base);
		}
	}
}
import flash.display.Sprite;

import game.core.menu.MenuView;
import game.core.menu.TopMenu;
import game.core.menu.VoMenuButton;

class Singleton
{
}
class ActionData
{
	public var x : Number;

	public var y : Number;

	public var vo : VoMenuButton;

	public var fun : Function;

	public var endFun : Function;

	public var container : Sprite;

	public function ActionData(vo : VoMenuButton, x : Number, y : Number, fun : Function, endFun : Function, container : Sprite)
	{
		this.vo = vo;
		this.x = x;
		this.y = y;
		this.fun = fun;
		this.container = container;
		this.endFun = endFun;
	}

	public function get mcPointX() : Number
	{
		if (container is MenuView)
		{
			return x - 72 - this.container.x;
		}
		else if (container is TopMenu)
		{
			return x - 72 - this.container.x;
		}
		return x - this.container.x;
	}

	public function get mcPointY() : Number
	{
		if (container is MenuView)
		{
			return -45;
		}
		else if (container is TopMenu)
		{
			return y - 45;
		}
		return y - this.y;
	}
}

