package game.module.artifact {
	import game.core.menu.IMenu;
	import net.BDSWFLoader;
	import game.config.StaticConfig;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.manager.ViewManager;
	import game.module.battle.view.BTSystem;
	import game.module.quest.QuestDisplayManager;
	import game.module.quest.guide.GuideMange;
	import game.net.core.Common;
	import game.net.data.CtoS.CSArtifactsState;
	import game.net.data.StoC.SCActivateArtifactsRes;
	import game.net.data.StoC.SCArtifactsState;
	import game.net.data.StoC.SCChallengeArtifactsRes;
	import game.net.data.StoC.SCTrainArtifactsRes;

	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;

	import com.commUI.MoneyBoard;
	import com.commUI.button.KTButtonData;
	import com.commUI.tooltip.ToolTipManager;
	import com.commUI.tooltip.WordWrapToolTip;
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author yangyiqiang
	 */
	public class ArtifactView extends GComponent implements IModuleInferfaces ,IAssets,IMenu {
		public function ArtifactView() {
			_base = new GComponentData();
			_base.parent = ViewManager.instance.getContainer(ViewManager.FULL_SCREEN_UI);
			super(_base);
		}

		private var _panel : ArtifactMainPanel;
		private var _menu : ArtifactIcoMenu;

		public function initModule() : void {
			with(this.graphics) {
				beginFill(0x0000000);
				drawRect(0, 0, UIManager.stage.stageWidth, UIManager.stage.stageHeight);
				endFill();
			}
			_panel = new ArtifactMainPanel();
			_panel.x = (UIManager.stage.stageWidth - _panel.width) / 2;
			_panel.y = (UIManager.stage.stageHeight - _panel.height) / 2;
			addChild(_panel);
			_money = new MoneyBoard();
			addChild(_money);
			Common.game_server.addCallback(0xE0, artifactList);
			Common.game_server.addCallback(0xE1, challengeArtifacts);
			Common.game_server.addCallback(0xE2, trainArtifactsRes);
			Common.game_server.addCallback(0xE3, openArtifact);
			initDieFrame();
			addExitButton();
			_menu = new ArtifactIcoMenu();
			_menu.x = 150;
			_menu.y = 10;
			_menu.addEventListener(ArtifactEvent.ARTIFACT_CLICK, onChange);
			addChild(_menu);
		}

		private function onChange(event : ArtifactEvent) : void {
			var selectVo : VoArtifact = event.data as VoArtifact;
			_panel.refresh(selectVo, false);
			if (selectVo.state == 1 && selectVo.type != 3)
				_panel.playerCorona(selectVo.getPre(), true);
		}

		private var _exitButton : GButton;
		private var _money : MoneyBoard;
		private var _infoText : TextField;
		private var _stateW : Number;
		private var _stateH : Number;

		private function addExitButton() : void {
			_exitButton = new GButton(new KTButtonData(KTButtonData.EXIT_BUTTON));
			_stateW = UIManager.stage.stageWidth;
			_stateH = UIManager.stage.stageHeight;
			_exitButton.x = _stateW - 70;
			_exitButton.y = 10;
			addChild(_exitButton);
			_infoText = UICreateUtils.createTextField("", "", 130, 25, _stateW - 200, 20, UIManager.getTextFormat(12, 0xffffff, TextFormatAlign.CENTER));
			_infoText.htmlText = StringUtils.addLine("神器属性只对PK有效");
			_infoText.mouseEnabled = true;
			addChild(_infoText);
		}

		private function artifactList(msg : SCArtifactsState) : void {
			var vo : VoArtifact = ArtifactManage.instance().getVo((msg.level & 0xffff0000) >> 16);
			if (!vo) return;
			vo.level = (msg.level & 0xff00) >> 8;
			vo.state = msg.level & 0xff;
			vo.exp = msg.currentExp;
			ArtifactManage.instance().critNum = msg.critNum;
			ArtifactManage.instance().lastExp = msg.lastGetExp;
			ArtifactManage.instance().battleCount = (msg.challengeCount & 0xffff0000) >> 16;
			ArtifactManage.instance().caseCount = (msg.trainCount & 0xffff0000) >> 16;
			ArtifactManage.instance().caseMax = msg.trainCount & 0xffff;
			_panel.refresh(vo);
			if (vo.state == 1 && vo.type != 3)
				_panel.playerCorona(vo.getPre(), true);
			_menu.initCurrnVo(vo.id);
		}

		// 挑战返回    0 - 成功      1 - 失败　　　2 - 今日挑战次数已满　3 - 神器升级中 或　已有神器未激活 　４- 开启神器系统的主线任务未完成
		private function challengeArtifacts(msg : SCChallengeArtifactsRes) : void {
			if (BTSystem.INSTANCE().isInBattle) {
				BTSystem.INSTANCE().addClickEndCall({fun:challenge, arg:[msg]});
			}
		}

		private function challenge(msg : SCChallengeArtifactsRes) : void {
			ArtifactManage.instance().battleCount = (msg.challengeCount & 0xffff0000) >> 16;
			if (msg.result == 0) {
				var vo : VoArtifact = ArtifactManage.instance().getVo((msg.level & 0xffff0000) >> 16);
				if (!vo) return;
				vo.level = (msg.level & 0xff00) >> 8;
				vo.state = msg.level & 0xff;
				_panel.refresh(vo);
				_panel.playerCorona(vo.getPre(), true);
				QuestDisplayManager.getInstance().playAchieve(vo.introdunction);
				_menu.initCurrnVo(vo.id);
			} else {
				_panel.refresh(null);
			}
		}

		// 铸魂返回   0 - 暴击   1 - 无暴击  　　2 - 今日铸魂次数已满     3 - 元宝不够   4 - 神器未获得　5　- 神器已激活
		private function trainArtifactsRes(msg : SCTrainArtifactsRes) : void {
			ArtifactManage.instance().caseCount = (msg.trainCount & 0xffff0000) >> 16;
			ArtifactManage.instance().caseMax = msg.trainCount & 0xffff;
			var vo : VoArtifact = ArtifactManage.instance().getVo((msg.level & 0xffff0000) >> 16);
			if (!vo) return;
			var level : int = (msg.level & 0xff00) >> 8;
			var oldLevel : int = vo.level;
			var exp : int = level > oldLevel ? (vo.maxExp - vo.exp + msg.currentExp) : (msg.currentExp - vo.exp);
			vo.level = level;
			vo.state = msg.level & 0xff;
			vo.exp = msg.currentExp;
			ArtifactManage.instance().critNum = msg.critNum;
			ArtifactManage.instance().lastExp = msg.lastGetExp;
			Logger.debug("SCTrainArtifactsRes.exp===>" + msg.currentExp, "vo.exp===>" + vo.exp, "level===>" + level, "oldLevel===>" + oldLevel);
			
			if (level > oldLevel)
				_panel.playLevelUp(exp);
			else {
				if (vo.type != 3)
					_panel.playerCorona(vo.getPre());
				_panel.playExp(exp);
			}

			if (msg.result == 0) _panel.playerCrit(msg.critNum);
			_panel.refresh(vo);
		}

		/** 激活 **/
		private function openArtifact(msg : SCActivateArtifactsRes) : void {
			if (msg.result != 0) return;
			var vo : VoArtifact = ArtifactManage.instance().getVo((msg.level & 0xffff0000) >> 16);
			if (!vo) return;
			vo.level = (msg.level & 0xff00) >> 8;
			vo.state = msg.level & 0xff;
			_panel.currentVo.state = 0;
			Logger.debug("vo.id===>" + vo.id, "vo.exp===>" + vo.exp, "level===>" + vo.level);
			_menu.play(_panel.currentVo.id, playAction, [vo, false]);
		}

		private function playAction(vo : VoArtifact, flag : Boolean) : void {
			_panel.refresh(vo, flag);
			_menu.initCurrnVo(vo.id);
		}

		public function getResList() : Array {
			return [new LibData(StaticConfig.cdnRoot + "assets/swf/artifact.swf", "artifact"), new LibData(StaticConfig.cdnRoot + "assets/ui/numberTest.swf", "artfactNum"),new LibData(StaticConfig.cdnRoot + "assets/avatar/184549378.swf", "184549378",true,true,"1",BDSWFLoader)];
		}

		private function initDieFrame() : void {
			for (var  i : int = 0; i < 12; i++ ) {
				if (i == 0)
					ArtifactManage.instance().numVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_a", "artfactNum")));
				else if (i == 1)
					ArtifactManage.instance().numVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_b", "artfactNum")));
				else
					ArtifactManage.instance().numVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_" + (i - 2).toString(), "artfactNum")));
			}
		}

		override public function stageResizeHandler() : void {
			with(this.graphics) {
				beginFill(0x0000000);
				drawRect(0, 0, UIManager.stage.stageWidth, UIManager.stage.stageWidth);
				endFill();
			}
			this.x = 0;
			this.y = 0;
			if (_panel) {
				_stateW = Math.min(UIManager.stage.stageWidth, _panel.width);
				_stateH = Math.min(UIManager.stage.stageHeight, _panel.height);
				_panel.x = (UIManager.stage.stageWidth - _panel.width) / 2;
				_panel.y = (UIManager.stage.stageHeight - _panel.height) / 2;
				_exitButton.x = _stateW - 70;
				_exitButton.y = 10;
				_infoText.x = _stateW - 200;
				_infoText.y = 20;
				_menu.x = 150;
				MenuManager.getInstance().getMenu().x = _stateW - MenuManager.getInstance().getMenu().width;
				MenuManager.getInstance().getMenu().y = _stateH - MenuManager.getInstance().getMenu().height;
			}
		}

		private function onExit(event : MouseEvent) : void {
			MenuManager.getInstance().closeMenuView(MenuType.ARTIFACT);
		}
		
		public function get menuId() : int{
			return MenuType.ARTIFACT;
		}

		override protected function onShow() : void {
			super.onShow();
			Common.game_server.sendMessage(0xE0, new CSArtifactsState());
			_exitButton.addEventListener(MouseEvent.CLICK, onExit);
			// 角色、包裹、阵型、仙葫、法宝、元神、强化、灵珠
			MenuManager.getInstance().setShowList([MenuType.HERO_PANEL, MenuType.PACK, 3, 4, 5, 6, 7]);
			// ViewManager.instance.getContainer(ViewManager.MAP_CONTAINER).parent.removeChild(ViewManager.instance.getContainer(ViewManager.MAP_CONTAINER));
			ToolTipManager.instance.registerToolTip(_infoText, WordWrapToolTip, "神器属性对" + StringUtils.addColor("竞技场、蜀山论剑、仙龟拜佛", ColorUtils.HIGHLIGHT_DARK) + "等系统有效");
			GuideMange.getInstance().checkGuideByMenuid(MenuType.ARTIFACT, 0, _panel);
		}

		override protected function onHide() : void {
			super.onHide();
			_exitButton.removeEventListener(MouseEvent.CLICK, onExit);
			MenuManager.getInstance().setShowList();
			MenuManager.getInstance().getMenu().x = UIManager.stage.stageWidth - MenuManager.getInstance().getMenu().width;
			MenuManager.getInstance().getMenu().y = UIManager.stage.stageHeight - MenuManager.getInstance().getMenu().height;
			// UIManager.root.addChildAt(ViewManager.instance.getContainer(ViewManager.MAP_CONTAINER), 0);
			ToolTipManager.instance.destroyToolTip(_infoText);
			GuideMange.getInstance().resetAndCheckGuide(MenuType.ARTIFACT);
		}
	}
}
