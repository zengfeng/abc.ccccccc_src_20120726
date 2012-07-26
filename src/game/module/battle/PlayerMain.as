package game.module.battle {
	import game.net.socket.SocketParser;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import game.config.StaticConfig;
	import game.manager.RSSManager;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.battle.view.BTSystem;
	import game.net.core.Common;
	import game.net.core.RequestData;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;
	import net.LibData;
	import net.RESLoader;
	import net.RESManager;
	import net.SWFLoader;
	
	
	

	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
	public class PlayerMain extends Sprite {
		private function initializeStage() : void {
			flash.system.Security.allowDomain("*");
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			transform.perspectiveProjection.projectionCenter = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
		}

		private var _url : String;

		/** 初始化配置文件 **/
		private function initConfig() : void {
			UIManager.setRoot(this);
			UIManager.setStage(this.stage);
			StaticConfig.initConfig(this.loaderInfo.parameters);
			_url = this.loaderInfo.parameters["url"];
			UIManager.appDomain = ApplicationDomain.currentDomain;

			ViewManager.preStageWH.x = stage.stageWidth;
			ViewManager.preStageWH.y = stage.stageHeight;
			ViewManager.instance.initializeViewsDebug();
			ViewManager.instance.setRightMenu();
		}

		private function completeHandler(event : Event) : void {
			RESManager.instance.removeEventListener(Event.COMPLETE, completeHandler);
			RSSManager.getInstance().parseConfig(RESManager.getByteArray("config.kt"), 1);
			ViewManager.instance.initializeViews();
			getBTDataFromUrl();
		}

		private function initCommon() : void {
			Common.getInstance().initConfing();
			new BattleInterface();
			RESManager.instance.add(new RESLoader(new LibData(VersionManager.instance.getUrl("config/config.kt"), "config.kt")));
			RESManager.instance.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/ui/Numbers.swf", "Numbers")));
			RESManager.instance.add(new SWFLoader(new LibData(VersionManager.instance.getUrl("assets/swf/ui.swf"), "ui")));
			RESManager.instance.addEventListener(Event.COMPLETE, completeHandler);
			Common.getInstance().loadPanel.show();
			RESManager.instance.startLoad();

			var bcData : GComponentData = new GComponentData();
			bcData.parent = UIManager.root;
			var bc : GComponent = new GComponent(bcData);
			bc.mouseEnabled = false;
			BTSystem.INSTANCE().setContainer(bc);
			BTSystem.INSTANCE().setBattleModel(1);
		}

		public function getBTDataFromUrl(str : String = "D:/server/replay/0/0/8.dat") : void {
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, parseBTData);

			var requestHeader : URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var request : URLRequest = new URLRequest(str);
			request.method = flash.net.URLRequestMethod.POST;
			request.requestHeaders.push(requestHeader);
			urlLoader.load(request);
		}

		public function parseBTData(evt : Event) : void {
			
			BTSystem.INSTANCE().SetPlayModle(1);
			var dataBuf : ByteArray = evt.target.data as ByteArray;
			dataBuf.endian = "littleEndian";
			dataBuf.readUnsignedInt();
			Common.game_server.executeCallback(SocketParser.parse(dataBuf));
		}

		public function PlayerMain() {
			initializeStage();
			initConfig();
			RESManager.instance.load(new LibData(StaticConfig.cdnRoot + "assets/swf/loading.swf", "loading"), initCommon);
		}
	}
}