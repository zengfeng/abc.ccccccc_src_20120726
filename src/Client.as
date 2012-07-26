package {
	import com.sociodox.theminer.TheMiner;
	import game.config.StaticConfig;
	import game.manager.CommonMessageManage;
	import game.manager.ViewManager;
	import game.net.core.Common;
	import game.net.core.GA;

	import gameui.manager.UIManager;

	import net.LibData;
	import net.RESManager;

	import com.commUI.LoginPanel;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.system.Security;

	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
	public class Client extends Sprite
	{
		public function Client()
		{
			GA.instance.start();
			initConfig();
			addChild(new TheMiner());
		}

		private function init() : void
		{
			UIManager.setStage(this.stage);
			UIManager.setRoot(this);
			initializeStage(UIManager.stage);
			initContainer();
		}

		private function initializeStage(stage : Stage) : void
		{
			flash.system.Security.allowDomain("*");
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			transform.perspectiveProjection.projectionCenter = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
			initView();
		}

		private function initView() : void
		{
			ViewManager.preStageWH.x = stage.stageWidth;
			ViewManager.preStageWH.y = stage.stageHeight;
			ViewManager.instance.initializeViewsDebug();
			ViewManager.instance.setRightMenu();
			//addChild(new TheMiner());
		}

		/** 初始化配置文件 **/
		private function initConfig() : void
		{
			switch(StaticConfig.initConfig(this.loaderInfo.parameters))
			{
				case StaticConfig.ISDEBUGE:
					UIManager.appDomain = ApplicationDomain.currentDomain;
					init();
					_loginPanel = new LoginPanel(this, startLoad);
					_loginPanel.show();
					break;
				case StaticConfig.NODEBUGE:
					UIManager.appDomain = ApplicationDomain.currentDomain;
					init();
					startLoad();
					break;
				case StaticConfig.RELEASE:
					break;
			}
		}

		public function initMessage() : void
		{
			UIManager.setStage(this.stage);
			UIManager.setRoot(this);
			initView();
			UIManager.appDomain = ApplicationDomain.currentDomain;
			CommonMessageManage.instance.init();
			initContainer();
		}

		private var _loginPanel : LoginPanel;

		private function startLoad() : void
		{
			RESManager.instance.load(new LibData(StaticConfig.cdnRoot + "assets/swf/loading.swf", "loading"), initCommon);
		}

		private function initCommon() : void
		{
			CommonMessageManage.instance.init();
			Common.getInstance().init(StaticConfig.serversString, StaticConfig.userId, StaticConfig.key);
		}

		// 容器初始化
		private function initContainer() : void
		{
			ViewManager.instance.initializeContainers();
		}
	}
}