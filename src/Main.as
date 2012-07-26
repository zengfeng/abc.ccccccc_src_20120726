package {
	import game.config.StaticConfig;
	import game.manager.VersionManager;
	import game.module.role.RoleSystem;
	import game.net.core.Common;
	import game.net.core.RequestData;
	import game.net.data.StoC.SCUserLogin;

	import gameui.manager.UIManager;

	import net.AssetData;
	import net.LibData;
	import net.RESLoader;
	import net.RESManager;
	import net.SWFLoader;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
	public class Main extends Sprite
	{
		public function Main()
		{
			initializeStage(this.stage);
			UIManager.setStage(this.stage);
			UIManager.setRoot(this);
			initConfig();
		}

		private function initializeStage(stage : Stage) : void
		{
			flash.system.Security.allowDomain("*");
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_mc = new swfClass();
			_mc.x = stage.stageWidth / 2;
			_mc.y = stage.stageHeight / 2;
			addChild(_mc);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}


		private function removeFromStageHandler(event : Event) : void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			Common.game_server.removeCallback(0x02, loginCallBack);
			Common.game_server.removeEventListener(Event.CLOSE, socketClose);
			UIManager.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			cleanUpMc();
			if (_text && _text.parent) {
				_text.parent.removeChild(_text);
			}
		}

		[Embed(source='../assets/ui/mc.swf')]
		private var swfClass : Class;
		private var _mc : MovieClip;

		private function initConfig() : void
		{
			UIManager.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			StaticConfig.initConfig(this.loaderInfo.parameters);
			startLoad();
		}

		private function startLoad() : void
		{
			RESManager.instance.load(new LibData(StaticConfig.cdnRoot + "version.kt", "version", true, false, StaticConfig.vlist_hash), initVersion, null, RESLoader);
			showAlert("加载 version.kt中！url=" + StaticConfig.cdnRoot + "version.kt?v= " + StaticConfig.vlist_hash);
		}

		private function initVersion() : void
		{
			VersionManager.instance.initVersion(RESManager.getByteArray("version"));
			RESManager.instance.remove("version");
			RESManager.instance.load(VersionManager.instance.getLib("assets/swf/loading.swf", "loading"), initCommon);
			showAlert("加载 loading中！url=" + StaticConfig.cdnRoot + "assets/swf/loading.swf?v= " + UIManager.version);
		}

		private function initCommon() : void
		{
			UIManager.appDomain = ApplicationDomain.currentDomain;
			Common.game_server.addCallback(0x02, loginCallBack);
			Common.game_server.addEventListener(Event.CLOSE, socketClose);
			Common.game_server.addEventListener("ioError", ioError);
			Common.game_server.addEventListener("securityError", securityError);
			Common.getInstance().init(StaticConfig.serversString, StaticConfig.userId, StaticConfig.key);
			showAlert("请求登录 StaticConfig.serversString" + StaticConfig.serversString);
		}

		private var _mssage : SCUserLogin;

		/**
		 * 登录返回
		 */
		private function loginCallBack(message : SCUserLogin) : void
		{
			_mssage = message;
			switch(message.result)
			{
				case 0:
					/** 登录成功 **/
					RoleSystem.dispose();
					RESManager.instance.add(new SWFLoader(new LibData((StaticConfig.cdnRoot == "../" ? "" : StaticConfig.cdnRoot) + "Client.swf", "client", true, false, VersionManager.instance.getVersion("Client.swf"))));
					RESManager.instance.addEventListener(Event.COMPLETE, loadComplete);
					Common.getInstance().loadPanel.model = RESManager.instance.model;
					Common.getInstance().loadPanel.startShow(false);
					RESManager.instance.startLoad();
					Common.game_server.removeCallback(0x02, loginCallBack);
					showAlert("登录成功！type=" + message.result);
					break;
				case 1:
					/** 新用户 **/
					RoleSystem.initCreateRole();
					preLoad();
					cleanUpMc();
					showAlert("新用户！type=" + message.result);
					break;
				default:
					showAlert("登录出错！type=" + message.result);
					break;
			}
		}

		private function cleanUpMc() : void
		{
			if (_mc)
				_mc.stop();
			if (_mc && _mc.parent)
				_mc.parent.removeChild(_mc);
			_mc = null;
		}

		private function socketClose(event : Event) : void
		{
			showAlert("你已经断开了连接！");
		}

		private function ioError(event:Event) : void {
			showAlert("ioError！");
		}
		
		private function securityError(event:Event) : void {
			showAlert("securityError！");
		}

		private var _text : TextField;

		private function showAlert(text : String) : void
		{
			if (!_text)
			{
				_text = UIManager.getTextField();
				_text.autoSize = TextFieldAutoSize.CENTER;
				_text.wordWrap = true;
				_text.height = 300;
				_text.width = 500;
			}
			_text.textColor = 0xff0000;
			_text.appendText(text);
			_text.x = (UIManager.stage.stageWidth - 500) / 2;
			_text.y = UIManager.stage.stageHeight * 2 / 3;
		}

		private function keyUpHandler(event : KeyboardEvent) : void
		{
			if (event.ctrlKey)
				if (event.keyCode == 191)
					addChild(_text);
		}

		private function loadComplete(event : Event) : void
		{
			cleanUpMc();
			RESManager.instance.removeEventListener(Event.COMPLETE, loadComplete);
			this.parent.removeChild(this);
			var cls : Class = RESManager.getClass(new AssetData("Client", "client"));
			var game : * = new cls();
			UIManager.stage.addChild(game);
			game["initMessage"]();
			Common.game_server.executeCallback(new RequestData(0x02, _mssage));
		}

		private function preLoad() : void
		{
			var _res : RESManager = RESManager.instance;
			_res.preLoad(VersionManager.instance.getUrl("Client.swf"), VersionManager.instance.getVersion("Client.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/swf/ui.swf"), VersionManager.instance.getVersion("assets/swf/ui.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/avatar/shadow.png"));
			_res.preLoad(VersionManager.instance.getUrl("assets/avatar/shadow1.png"));
			_res.preLoad(VersionManager.instance.getUrl("assets/quest/quest.swf"), VersionManager.instance.getVersion("assets/quest/quest.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/swf/embedFont_" + StaticConfig.langString + ".swf"), VersionManager.instance.getVersion("assets/swf/embedFont_" + StaticConfig.langString + ".swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/swf/commonAction_" + StaticConfig.langString + ".swf"), VersionManager.instance.getVersion("assets/swf/commonAction_" + StaticConfig.langString + ".swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/swf/smallLoader.swf"), VersionManager.instance.getVersion("assets/swf/smallLoader.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/swf/titleFont.swf"), VersionManager.instance.getVersion("assets/swf/titleFont.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/avatar/1677721602.swf"), VersionManager.instance.getVersion("assets/avatar/1677721602.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/avatar/1.swf"), VersionManager.instance.getVersion("assets/avatar/1.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/avatar/2.swf"), VersionManager.instance.getVersion("assets/avatar/2.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/avatar/3.swf"), VersionManager.instance.getVersion("assets/avatar/3.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/avatar/4.swf"), VersionManager.instance.getVersion("assets/avatar/4.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/avatar/5.swf"), VersionManager.instance.getVersion("assets/avatar/5.swf"));
			_res.preLoad(VersionManager.instance.getUrl("assets/avatar/6.swf"), VersionManager.instance.getVersion("assets/avatar/6.swf"));
		}
	}
}
