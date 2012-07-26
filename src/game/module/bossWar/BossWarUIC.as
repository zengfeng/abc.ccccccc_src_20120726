package game.module.bossWar {
	import com.commUI.toggleButton.KTToggleButtonData;
	import com.commUI.button.KTButtonData;

	import gameui.data.GButtonData;
	import gameui.controls.GButton;

	import com.commUI.SwfEmbedFont;

	import game.module.mapBossWar.BOOSControll;

	import flash.events.MouseEvent;

	import game.definition.UI;

	import net.AssetData;
	import net.RESManager;

	import flash.display.MovieClip;

	import game.module.mapDuplUI.NextDoButton;
	import game.manager.ViewManager;
	// import game.module.map.ui.NextDoButton;
	import gameui.manager.UIManager;

	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * @author 1
	 */
	public class BossWarUIC extends Sprite {
		function BossWarUIC(singleton : Singleton) : void {
			singleton;
			initViews();
		}

		/** 单例对像 */
		private static var _instance : BossWarUIC;

		/** 获取单例对像 */
		public static function get instance() : BossWarUIC {
			if (_instance == null) {
				_instance = new BossWarUIC(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var bloodBox : BossBloodBoxPanel;
		public var harmRanking : BossHarmRanking;
		private var _viewManager : ViewManager;
		// public var nextDoButton:NextDoButton;
		public var nextDoButton : MovieClip;
		public var quitBtn : GButton;
		private var maskSP : Sprite;

		private function get viewManager() : ViewManager {
			if (_viewManager == null) {
				_viewManager = ViewManager.instance;
			}
			return _viewManager;
		}

		private var _stage : Stage;

		override public function get stage() : Stage {
			if (_stage == null) {
				_stage = UIManager.stage;
			}
			return _stage;
		}

		public function clear() : void {
			ViewManager.removeStageResizeCallFun(stageResize);
			hide();
		}

		private function stageResize(stage : Stage = null, preStageWidth : Number = 0, preStageHeight : Number = 0) : void {
			if (!bloodBox) return;
			bloodBox.x = (stage.stageWidth - bloodBox.width) / 2 + 70;
			bloodBox.y = 15;
			harmRanking.x = stage.stageWidth - harmRanking.width - 10;
			harmRanking.y = 200;
			nextDoButton.x = (stage.stageWidth - nextDoButton.width) / 2;
			// maskSP.x = (stage.stageWidth - maskSP.width) / 2;
			quitBtn.x = stage.stageWidth - quitBtn.width - 20;
			quitBtn.y = 20;
		}

		public function initViews() : void {
			bloodBox = new BossBloodBoxPanel();
			bloodBox.x = (stage.stageWidth - bloodBox.width) / 2 + 70;
			bloodBox.y = 15;
			addChild(bloodBox);
			bloodBox.mouseEnabled = false;
			bloodBox.mouseChildren = false;

			harmRanking = new BossHarmRanking();
			harmRanking.x = stage.stageWidth - harmRanking.width - 10;
			harmRanking.y = 200;
			addChild(harmRanking);
			ViewManager.addStageResizeCallFun(stageResize);

			harmRanking.mouseEnabled = false;
			harmRanking.mouseChildren = false;

			nextDoButton = RESManager.getMC(new AssetData(UI.BOSS_WAR_BTN,"lang_menu"));
			nextDoButton.x = (stage.stageWidth - nextDoButton.width) / 2;
			nextDoButton.y = 110;
			addChild(nextDoButton);
			nextDoButton.mouseEnabled = true;
			nextDoButton.mouseChildren = true;

			maskSP = new Sprite();
			maskSP.graphics.beginFill(0x555555);
			maskSP.graphics.drawRect((stage.stageWidth - nextDoButton.width) / 2, 110, nextDoButton.width, nextDoButton.height);
			maskSP.graphics.endFill();
			addChild(maskSP);
			maskSP.alpha = 0;
			maskSP.visible = false;
			maskSP.mouseEnabled = true;
			maskSP.mouseChildren = true;

			var data : GButtonData = new KTButtonData(KTButtonData.EXIT_BUTTON);
			quitBtn = new GButton(data);
			addChild(quitBtn);
			quitBtn.mouseEnabled = true;
			quitBtn.mouseChildren = true;
			quitBtn.x = stage.stageWidth - quitBtn.width - 20;
			quitBtn.y = 20;
			viewManager.addToStage(this,ViewManager.AUTO_CONTAINER);

			nextDoButton.addEventListener(MouseEvent.MOUSE_DOWN, onclickDown);
			this.parent.stage.addEventListener(MouseEvent.CLICK, onclickclick);
			quitBtn.addEventListener(MouseEvent.CLICK, onquitBtn);
			maskSP.addEventListener(MouseEvent.CLICK, onclickMask);
		}

		private var isMask : Boolean = false;

		private function onclickMask(event : MouseEvent) : void {
			isMask = true;
		}

		private function onquitBtn(event : MouseEvent) : void {
			ProxyBossWar.instance.quickBossWar();
		}

		private function onclickclick(event : MouseEvent) : void {
			if (isMask) {
				isMask = false;
			} else {
				nextDoButton.gotoAndStop(1);
				maskSP.visible = false;
			}
		}

		private function onclickDown(event : MouseEvent) : void {
			
			if (!BOOSControll.instance.IsSelfDie && (!BOOSControll.instance.isWayPass)) return;
			nextDoButton.gotoAndStop(2);
			BOOSControll.instance.findWay();
			maskSP.visible = true;
		}

		// Boss按钮转换
		public function myHeroDie() : void {
			nextDoButton.gotoAndStop(1);
			nextDoButton.visible = false;
			maskSP.visible = true;
		}

		public function myHeroRive() : void {
			nextDoButton.visible = true;
			maskSP.visible = false;
		}

		public function show() : void {
			if (this.parent == null) viewManager.addToStage(this);
			if (nextDoButton.parent == null) viewManager.addToStage(nextDoButton);
		}

		public function hide() : void {
			if (this.parent) this.parent.removeChild(this);
			if (nextDoButton.parent) nextDoButton.parent.removeChild(nextDoButton);
		}
	}
}
class Singleton {
}
