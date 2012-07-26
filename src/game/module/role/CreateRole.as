package game.module.role
{
	import game.config.StaticConfig;
	import game.net.core.Common;
	import game.net.core.GASignals;
	import game.net.core.RequestData;
	import game.net.data.CtoS.CSUserRegister;
	import game.net.data.StoC.SCUserLogin;
	import game.net.data.StoC.SCUserRegister;

	import gameui.manager.UIManager;

	import log4a.Logger;

	import com.greensock.TweenLite;

	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @author yangyiqiang
	 */
	public class CreateRole extends Sprite
	{
		// --- Vars --------------------------------------------------------------------------------------------------------------------------- //
		// Element Loader
		private var ElementLoader : Loader = new Loader();
		// User Interface
		private var UISprite : Sprite = new Sprite();
		private var RegTitle : MovieClip;
		private var RegPanel : MovieClip;
		private var Button1 : MovieClip;
		private var Button2 : MovieClip;
		private var Button3 : MovieClip;
		private var Button4 : MovieClip;
		private var Button5 : MovieClip;
		private var Button6 : MovieClip;
		private var RandomNameButton : MovieClip;
		private var RegTextBG : MovieClip;
		private var RegError : MovieClip;
		private var PlayButton : MovieClip;
		private var Tips : Sprite;
		private var TipsBG : Shape;
		private var TipsText : TextField;
		private var RegText : TextField;
		private var OldString : String;
		private var onComplete_func : Function;
		private var _playButtonSprite : Sprite;
		private var _waitingReplay : Boolean = false;

		// --- Functions --------------------------------------------------------------------------------------------------------------------- //
		// 构造函数
		public function CreateRole(onComplete : Function) : void
		{
			onComplete_func = onComplete;
			initSocket();
			// 载入资源
			ElementLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, ElementLoader_func);
			ElementLoader.load(new URLRequest(StaticConfig.cdnRoot + "assets/createRole/createRoleSkin.swf"));
		}

		private function initSocket() : void
		{
			Common.game_server.addCallback(0x01, registerCallBack);
		}

		/**
		 * 销毁socket相关偵聽
		 * 注：添加此方法，代表对后台发过来的相关协议不再关心!
		 */
		private function destroySocket() : void
		{
			Common.game_server.removeCallback(0x01);
		}

		// 载入资源
		private function ElementLoader_func(evt : Event) : void
		{
			// 完成资源加载
			GASignals.gaCreateRoleEnterPage.dispatch();
			ElementLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, ElementLoader_func);

			// 绘制UI
			UISprite.x = (UIManager.stage.stageWidth - 380) / 2;
			UISprite.y = (UIManager.stage.stageHeight - 540) / 2;

			UISprite.filters = [new GlowFilter(0xf0d58b, 1, 3, 3)];

			var M : Matrix = new Matrix();
			M.createGradientBox(380, 540, Math.PI / 2);
			UISprite.graphics.beginGradientFill(GradientType.LINEAR, [0xf0d58b, 0x725e38], [1, 1], [0, 255], M);
			UISprite.graphics.drawRoundRect(0, 0, 380, 540, 10, 10);

			UISprite.graphics.beginFill(0x000000);
			UISprite.graphics.drawRoundRect(2, 2, 376, 536, 10, 10);

			M.createGradientBox(500, 70, Math.PI / 2, -65, -30);
			UISprite.graphics.beginGradientFill(GradientType.RADIAL, [0x555555, 0x000000], [1, 1], [0, 255], M);
			UISprite.graphics.drawRoundRect(4, 4, 372, 60, 8, 8);

			M.createGradientBox(372, 1, Math.PI);
			UISprite.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0, 1, 0], [0, 128, 255], M);
			UISprite.graphics.drawRect(4, 4, 372, 1);

			UISprite.graphics.endFill();
			this.addChild(UISprite);

			var UIclass : Class;

			// Title
			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("RegTitle") as Class;
			RegTitle = new UIclass();
			RegTitle.x = 120;
			RegTitle.y = 10;
			RegTitle.filters = [new GlowFilter(0x000000, 1, 5, 5, 3, 3)];
			UISprite.addChild(RegTitle);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("RegPanel") as Class;
			RegPanel = new UIclass();
			RegPanel.x = 16;
			RegPanel.y = 160;
			UISprite.addChild(RegPanel);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("Button1") as Class;
			Button1 = new UIclass();
			Button1.x = 13;
			Button1.y = 40;
			RegPanel.addChild(Button1);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("Button2") as Class;
			Button2 = new UIclass();
			Button2.x = 13;
			Button2.y = 137;
			RegPanel.addChild(Button2);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("Button3") as Class;
			Button3 = new UIclass();
			Button3.x = 133;
			Button3.y = 40;
			RegPanel.addChild(Button3);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("Button4") as Class;
			Button4 = new UIclass();
			Button4.x = 133;
			Button4.y = 137;
			RegPanel.addChild(Button4);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("Button5") as Class;
			Button5 = new UIclass();
			Button5.x = 253;
			Button5.y = 40;
			RegPanel.addChild(Button5);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("Button6") as Class;
			Button6 = new UIclass();
			Button6.x = 253;
			Button6.y = 137;
			RegPanel.addChild(Button6);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("RegTextBG") as Class;
			RegTextBG = new UIclass();
			RegTextBG.x = 10;
			RegTextBG.y = 400;
			UISprite.addChild(RegTextBG);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("RandomNameButton") as Class;
			RandomNameButton = new UIclass();
			RandomNameButton.x = 238;
			RandomNameButton.y = 8;
			RandomNameButton.addEventListener(MouseEvent.CLICK, getName);
			// TODO: 暂时不开放随即名字
			// RegTextBG.addChild(RandomNameButton);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("RegError") as Class;
			RegError = new UIclass();
			RegError.x = 58;
			RegError.y = 355;
			RegError.alpha = 0;
			RegError.mouseChildren = false;
			RegError.mouseEnabled = false;
			UISprite.addChild(RegError);

			for (var i : int = 1; i <= 6; i++)
			{
				MovieClip(this["Button" + String(i)]).addEventListener(MouseEvent.CLICK, ButtonClick_func);
				MovieClip(this["Button" + String(i)]).addEventListener(MouseEvent.ROLL_OVER, TipsEvent_func);
				MovieClip(this["Button" + String(i)]).addEventListener(MouseEvent.ROLL_OUT, TipsEvent_func);
			}

			RandomNameButton.addEventListener(MouseEvent.ROLL_OVER, TipsEvent_func);
			RandomNameButton.addEventListener(MouseEvent.ROLL_OUT, TipsEvent_func);

			// 角色名称输入框f39700
			RegText = new TextField();
			RegText.antiAliasType = AntiAliasType.NORMAL;
			RegText.type = TextFieldType.INPUT;
			RegText.width = 100;
			RegText.height = 30;
			RegText.x = 130;
			RegText.y = 407;
			RegText.defaultTextFormat = new TextFormat("宋体,SimSun", 14, 0xf39700);

			RegText.addEventListener(Event.CHANGE, TextFormat_func);
			UISprite.addChild(RegText);

			// Tips
			Tips = new Sprite();
			TipsBG = new Shape();
			TipsBG.graphics.beginFill(0x7b5432);
			TipsBG.graphics.drawRoundRect(0, 0, 60, 28, 6, 6);
			TipsBG.graphics.beginFill(0x111111);
			TipsBG.graphics.drawRoundRect(1, 1, 58, 26, 6, 6);
			TipsBG.graphics.endFill();
			TipsBG.scale9Grid = new Rectangle(10, 10, 40, 8);
			TipsBG.alpha = 0;
			Tips.mouseEnabled = false;
			Tips.mouseChildren = false;
			Tips.addChild(TipsBG);

			TipsText = new TextField();
			TipsText.antiAliasType = AntiAliasType.NORMAL;
			TipsText.autoSize = TextFieldAutoSize.LEFT;
			TipsText.multiline = true;
			TipsText.x = 6;
			TipsText.y = 6;
			TipsText.defaultTextFormat = new TextFormat("宋体,SimSun", 12, 0xFFFFFF, null, null, null, null, null, null, null, null, null, 6);
			TipsText.mouseEnabled = false;

			Tips.addChild(TipsText);
			this.addChild(Tips);

			UIclass = ElementLoader.contentLoaderInfo.applicationDomain.getDefinition("PlayButton") as Class;
			PlayButton = new UIclass();
			PlayButton.x = 110;
			PlayButton.y = 464;
			PlayButton.addEventListener(MouseEvent.CLICK, pushValue);
			_playButtonSprite = new Sprite();
			with(_playButtonSprite.graphics)
			{
				beginFill(0xffffff, 0);
				drawRect(PlayButton.x, PlayButton.y, PlayButton.width, PlayButton.height);
				endFill();
			}

			UISprite.addChild(PlayButton);
			UISprite.addChild(_playButtonSprite);
			_playButtonSprite.addEventListener(MouseEvent.CLICK, pushValue);

			stage.addEventListener(MouseEvent.MOUSE_MOVE, Tips_func);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyEvent_func);
			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			// 端口连接
			SocketInit();
		}

		private function ErrorOpen(a : int) : void
		{
			RegError.gotoAndStop(a);
			TweenLite.to(RegError, 0.3, {alpha:1});
			TweenLite.to(this, 4, {onComplete:ErrorClose, overwrite:5});
		}

		private function ErrorClose() : void
		{
			TweenLite.to(RegError, 0.3, {alpha:0});
		}

		private function TextFormat_func(evt : Event) : void
		{
			var _str : String = RegText.text;
			var _length : uint = _str.length;
			var _re : RegExp = /[\u4e00-\u9fa5]{1,}/g;
			_length += _str.match(_re).join("").length;
			if (_length > 10)
			{
				ErrorOpen(2);
				RegText.text = OldString;
			}
			else
			{
				OldString = RegText.text;
			}
			var filterRegExp : RegExp = FilterWords.getFilterRegExp();
			if (filterRegExp.test(RegText.text))
			{
				ErrorOpen(1);
				RegText.text = "";
			}
			var TmpArray : Array = RegText.text.split("");
			var TmpString : String = "";
			for (var i : int = 0; i < TmpArray.length; i++)
			{
				if (TmpArray[i] == " ")
				{
					TmpArray[i] = "";
				}
				TmpString += TmpArray[i];
			}
			RegText.text = TmpString;
		}

		private function Tips_func(evt : MouseEvent) : void
		{
			TweenLite.to(Tips, 0.17, {x:mouseX + 17, y:mouseY + 12});
		}

		private function TipsEvent_func(evt : MouseEvent) : void
		{
			var _Height : int = 29;

			if (evt.target == Button1)
			{
				TipsText.htmlText = "金刚（男）：擅长防御肉搏<br><font color='#FFCC00'>拥有最高的体力成长，使用苍玄巨剑。</font>";
				_Height = 46;
			}
			else if (evt.target == Button2)
			{
				TipsText.htmlText = "金刚（女）：擅长防御肉搏<br><font color='#FFCC00'>拥有最高的体力成长，使用苍玄巨剑。</font>";
				_Height = 46;
			}
			else if (evt.target == Button3)
			{
				TipsText.htmlText = "修罗（男）：擅长攻击速度<br><font color='#FFCC00'>拥有最高的敏捷成长，使用湮月轮。</font>";
				_Height = 46;
			}
			else if (evt.target == Button4)
			{
				TipsText.htmlText = "修罗（女）：擅长攻击速度<br><font color='#FFCC00'>拥有最高的敏捷成长，使用湮月轮。</font>";
				_Height = 46;
			}
			else if (evt.target == Button5)
			{
				TipsText.htmlText = "天师（男）：擅长仙术攻击<br><font color='#FFCC00'>拥有最高的仙攻成长，使用天禅宝杖。</font>";
				_Height = 46;
			}
			else if (evt.target == Button6)
			{
				TipsText.htmlText = "天师（女）：擅长仙术攻击<br><font color='#FFCC00'>拥有最高的仙攻成长，使用天禅宝杖。</font>";
				_Height = 46;
			}
			else if (evt.target == RandomNameButton)
			{
				TipsText.htmlText = "随机选择名称";
			}
			if (evt.type == MouseEvent.ROLL_OVER)
			{
				TweenLite.to(TipsBG, 0.3, {alpha:1, width:TipsText.width + 10, height:_Height, overwrite:0});
				TweenLite.to(TipsText, 0.3, {alpha:1, overwrite:0});
			}
			else if (evt.type == MouseEvent.ROLL_OUT)
			{
				TweenLite.to(TipsBG, 0.3, {alpha:0, width:TipsText.width + 10, height:_Height, overwrite:0});
				TweenLite.to(TipsText, 0.3, {alpha:0, overwrite:0});
			}
		}

		private function ButtonClick_func(evt : MouseEvent) : void
		{
			for (var i : int = 1; i <= 6; i++)
			{
				if (MovieClip(this["Button" + String(i)]).currentFrame == 25)
				{
					MovieClip(this["Button" + String(i)]).play();
				}
			}
			if (Number(MovieClip(evt.currentTarget).y) == 40)
			{
				sex = true;
			}
			else if (Number(MovieClip(evt.currentTarget).y) == 137)
			{
				sex = false;
			}
			if (Number(MovieClip(evt.currentTarget).x) == 13)
			{
				job = 1;
			}
			else if (Number(MovieClip(evt.currentTarget).x) == 133)
			{
				job = 2;
			}
			else if (Number(MovieClip(evt.currentTarget).x) == 253)
			{
				job = 3;
			}
			MovieClip(evt.target).gotoAndStop(25);
		}

		// Socket
		private function SocketInit(event : Event = null) : void
		{
		}

		// 获得 group(0天族,1魔族) sex( true:男  false:女) job(1:猛  2:刺  3:谋),name(姓名)
		private var sex : Boolean = true;
		private var job : uint = 1;

		private function getValue() : Object
		{
			var b : Boolean;
			// sex
			var c : int;

			// 职业和性别
			b = sex;
			c = job;

			var obj : Object = {sex:b, job:c, name:RegText.text};
			return obj;
		}

		// 发送
		private function pushValue(evt : MouseEvent) : void
		{
			if (RegText.text != "")
			{
				var obj : Object = getValue();
				createRole(obj["name"], obj["sex"], obj["job"]);
			}
			else
			{
				ErrorOpen(3);
			}
		}

		// 键盘
		private function KeyEvent_func(evt : KeyboardEvent) : void
		{
			if (evt.keyCode == 13)
			{
				if (RegText.text != "")
				{
					var obj : Object = getValue();
					createRole(obj["name"], obj["sex"], obj["job"]);
				}
				else
				{
					ErrorOpen(3);
				}
			}
		}

		public function gc_func() : void
		{
			RandomNameButton.removeEventListener(MouseEvent.CLICK, getName);
			for (var i : int = 1; i <= 6; i++)
			{
				MovieClip(this["Button" + String(i)]).removeEventListener(MouseEvent.CLICK, ButtonClick_func);
				MovieClip(this["Button" + String(i)]).removeEventListener(MouseEvent.ROLL_OVER, TipsEvent_func);
				MovieClip(this["Button" + String(i)]).removeEventListener(MouseEvent.ROLL_OUT, TipsEvent_func);
			}

			RandomNameButton.removeEventListener(MouseEvent.ROLL_OVER, TipsEvent_func);
			RandomNameButton.removeEventListener(MouseEvent.ROLL_OUT, TipsEvent_func);
			RegText.removeEventListener(Event.CHANGE, TextFormat_func);

			PlayButton.removeEventListener(MouseEvent.CLICK, pushValue);
			_playButtonSprite.removeEventListener(MouseEvent.CLICK, pushValue);

			destroySocket();
		}

		private function onRemoveFromStage(event : Event) : void
		{
			if (stage)
			{
				stage.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, Tips_func);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyEvent_func);
				stage.removeEventListener(Event.RESIZE, onStageResize);
			}
		}

		private function onStageResize(event : Event) : void
		{
			// 绘制UI
			UISprite.x = (UIManager.stage.stageWidth - 380) / 2;
			UISprite.y = (UIManager.stage.stageHeight - 540) / 2;
		}

		private function createRole(_name : String = "", _sex : Boolean = true, _job : int = 1) : void
		{
			if (_waitingReplay)
				return;
				
			GASignals.gaCreateRoleComplete.dispatch(_job);

			var message : CSUserRegister = new CSUserRegister();
			message.id = StaticConfig.userId;
			message.isMale = _sex;
			message.job = _job;
			message.name = _name;
			if (StaticConfig.fcm != -1)
				message.wallow = StaticConfig.fcm;
			Common.game_server.sendMessage(0x01, message);
			registerName = _name;
			
			_waitingReplay = true;
		}

		private var registerName : String;

		private function registerCallBack(mesage : SCUserRegister) : void
		{
			_waitingReplay = false;
			// 0 - 成功  1 - 名字重复  2 - 名字含有非法字符
			Logger.debug("SCUserRegister===> mesage.result=" + mesage.result);
			switch(mesage.result)
			{
				case 0:
					var msg : SCUserLogin = new SCUserLogin();
					msg.playerId = mesage.playerId;
					msg.name = registerName;
					Common.game_server.executeCallback(new RequestData(0x02, msg));
					gc_func();
					if (parent)
						parent.removeChild(this);
					break;
				case 1:
					ErrorOpen(4);
					break;
				case 2:
					ErrorOpen(3);
					break;
			}
		}

		// 请求随机名称 sex(true男，false女),language("zh_CN"简体,"zh_TW"繁体);
		private function getName(event : Event) : void
		{
		}
	}
}
