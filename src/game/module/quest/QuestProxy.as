package game.module.quest {
	import framerate.SecondsTimer;

	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.manager.DailyInfoManager;
	import game.manager.RSSManager;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.battle.view.BTSystem;
	import game.module.daily.DailyManage;
	import game.module.mapNpcConvoy.NpcConvoy;
	import game.module.monsterPot.MonsterPotManager;
	import game.module.quest.animation.ActionDriven;
	import game.module.quest.guide.GuideMange;
	import game.net.core.Common;
	import game.net.data.CtoC.CCUserDataChangeUp;
	import game.net.data.StoC.SCConveyFail;
	import game.net.data.StoC.SCLoopQuestDataRes;
	import game.net.data.StoC.SCLoopQuestSubmitRes;
	import game.net.data.StoC.SCNpcTrigger;
	import game.net.data.StoC.SCNpcTrigger.NpcIterAct;
	import game.net.data.StoC.SCPlotBegin;
	import game.net.data.StoC.SCQuestList;
	import game.net.data.StoC.SCQuestOperateReply;
	import game.net.data.StoC.SCQuestStepUpdate;

	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import worlds.apis.MNpc;
	import worlds.apis.MSelfPlayer;

	/**
	 * @author yangyiqiang
	 */
	public class QuestProxy {
		private var _manage : QuestManager = QuestManager.getInstance();
		private var _view : QuestPanel ;

		// private var _message : QuestMessagePanel = new QuestMessagePanel();
		public function QuestProxy() {
			Common.game_server.addCallback(0xFFF1, heroInfoChange);
			Common.game_server.addCallback(0x30, taskList);
			Common.game_server.addCallback(0x31, taskTrigger);
			Common.game_server.addCallback(0x32, taskAction);
			Common.game_server.addCallback(0x33, npcTrigger);
			Common.game_server.addCallback(0x39, plotBegin);
			Common.game_server.addCallback(0x3A, questFail);

			Common.game_server.addCallback(0xD7, loopQuestDataRes);
			Common.game_server.addCallback(0xD8, updateMsg);
		}

		private function heroInfoChange(msg : CCUserDataChangeUp) : void {
			if (msg.level == msg.oldLevel) return;
			QuestDisplayManager.getInstance().showQuests(QuestManager.getInstance().levelUp());
			MenuManager.getInstance().refresh();
			if (_view)
				_view.traceTasks();
		}

		/** 服务器返回任务列表 */
		private function taskList(msg : SCQuestList) : void {
			_manage.refreshQuests(msg);
			MenuManager.getInstance().initialize();
			if (!_view) {
				_view = QuestDisplayManager.getInstance().questView;
			}
			_view.traceTasks();
			QuestUtil.checkQuide();
			GuideMange.getInstance().checkAllGuide();
			if (MenuManager.getInstance().checkOpen(MenuType.DAILY)) {
				DailyInfoManager.instance.requestDaily();
			}
			MonsterPotManager.instance.initiate();
			// MenuManager.getInstance().getMenuButton(MenuType.PACK).addMenuMc(2,"新");
		}

		/** 接受、提交、放弃任务返回 */
		private function taskTrigger(msg : SCQuestOperateReply) : void {
			if (msg.result != 0) return;
			var temp : VoQuest;
			// 1:接受 2:提交 3:放弃
			switch(msg.op) {
				case 1:
					temp = _manage.resetQuestState(msg.questId, QuestManager.CURRENT);
					if (temp.base.type == QuestManager.DAILY) {
						_manage.resetQuestState(QuestManager.COMMON_DAILY, QuestManager.UNDONE);
						var quality : uint = 0;
						if (msg.hasQuality) {
							quality = msg.quality;
						}
						SignalBusManager.questPanelAcceptMissionUpdate.dispatch(temp.id, quality);
					}
					_manage.resetQuestNpcState(temp);
					// _message.source = temp.base.introdunction;
					if (temp.base.getCompleteTry() != 1 && temp.base.type != QuestManager.DAILY)  // 对话及支线任务不自动做下一步
						QuestUtil.questVoAction(temp);
					else QuestUtil.checkQuide();
					// 悬赏
					break;
				case 2:
					temp = _manage.resetQuestState(msg.questId, QuestManager.SUBMIT);
					QuestDisplayManager.getInstance().playAchieve(temp.base.notice);
					MSelfPlayer.avatar.questComplete();
					_manage.resetQuestNpcState(temp);
					if (!MenuManager.getInstance().refresh()) {
						QuestDisplayManager.getInstance().showQuests(_manage.submitQuest(msg.questId));
					} else {
						QuestDisplayManager.getInstance().waitForQuest = _manage.submitQuest(msg.questId);
					}
					SignalBusManager.questPanelSubmitMissionUpdate.dispatch(msg.questId);
					break;
			}
			_view.traceTasks();
		}

		private function taskAction(msg : SCQuestStepUpdate) : void {
			var temp : VoQuest = _manage.resetQuestState(msg.questId, QuestManager.CURRENT);
			if (!temp) return;
			temp.isCompleted = msg.isCompleted;
			if (temp.isCompleted) {
				if (temp.base.getCompleteTry() == 7 || temp.base.getCompleteTry() == 8) {
					NpcConvoy.removeNpc(temp.base.npcPublish);
					QuestUtil.removeQuestMode();
				}
				if (BTSystem.INSTANCE().isInBattle) {
					BTSystem.INSTANCE().addClickEndCall({fun:QuestDisplayManager.getInstance().showMainQuest, arg:[temp]});
				} else
					QuestDisplayManager.getInstance().showMainQuest(temp);
				_view.traceTasks();
				return;
			}
			temp.base.reqStep[msg.stepType - 1] = msg.stepNum;
			if (BTSystem.INSTANCE().isInBattle) {
				BTSystem.INSTANCE().addClickEndCall({fun:QuestUtil.questVoAction, arg:[temp]});
			} else
				QuestUtil.questVoAction(temp);
			_view.traceTasks();
		}

		private function npcTrigger(msg : SCNpcTrigger) : void {
			var quest : VoQuest ;
			var npc : VoNpc = RSSManager.getInstance().getNpcById(msg.npcId);
			if (!npc) return;
			QuestUtil.endAutoRun();
			if (msg.plotId) {
				ActionDriven.instance().playAnimation(msg.plotId);
				return;
			}
			Logger.debug("接收到npc.name==>" + npc.name, "   msg.acts.length=" + msg.acts.length);
			if (QuestUtil.tempAnimation != -1) ActionDriven.instance().playAnimation(QuestUtil.tempAnimation);
			var str : String = "";
			for each (var act:NpcIterAct in msg.acts) {
				if (act.actionTyp == 5) return;
				if (act.actionTyp == 2) {
					QuestUtil.getGoodId(act.actionId);
					QuestUtil.startUserItem();
					return;
				}
				// 功能链接
				if (act.actionTyp == 20) {
					str += addLink(QuestManager.getInstance().voNpcLinkDic[act.actionId]) + "|";
					continue;
				}
				quest = _manage.search(act.actionId);

				if (!quest) continue;
				// 第二种对话
				if (act.actionTyp == 3)
					quest.resetDialogueIndex(1);
				else
					quest.resetDialogueIndex();
			}
			if (msg.acts.length == 0) {
				if (npc.type == 1 && MNpc.getAvatar(npc.id))
					MNpc.getAvatar(npc.id).showDialog(npc.defaultDialog);
			} else {
				var actionTyp : int;
				if ( quest != null && quest.base.type == 3) {
					actionTyp = act.actionTyp == 3 ? 2 : 1;
				} else {
					actionTyp = act.actionTyp == 3 ? 2 : 0;
				}
				showDialoguePanel(npc, quest, str.substring(0, str.length - 1), actionTyp);
			}
		}

		private function addLink(vo : VoNpcLink) : String {
			if (!vo) return "";
			return vo.messgage + "_" + vo.id.toString();
		}

		private function questFail(msg : SCConveyFail) : void {
			msg;
			QuestUtil.removeQuestMode();
		}

		private function plotBegin(msg : SCPlotBegin) : void {
			Logger.debug("SCPlotBegin msg.plotId===>" + msg.plotId);
			ActionDriven.instance().playAnimation(msg.plotId);
		}

		private function showDialoguePanel(npc : VoBase, quest : VoQuest = null, str : String = "", flag : int = 0) : void {
			var x : int = (UIManager.stage.stageWidth - 500) / 2 ;
			var y : int = (UIManager.stage.stageHeight) / 2 + 40;
			ViewManager.dialogueSprite.x = x;
			ViewManager.dialogueSprite.y = y;
			ViewManager.dialogueSprite.setData(npc, quest, str, flag);
			ViewManager.dialogueSprite.show();
			GLayout.layout(ViewManager.dialogueSprite);
		}

		private function updateMsg(msg : SCLoopQuestSubmitRes) : void {
			refreshDailyQuest(msg.leftNum);
		}

		private function loopQuestDataRes(msg : SCLoopQuestDataRes) : void {
			_nextWantedTime = msg.nextTime;
			SecondsTimer.addFunction(countDown);
			refreshDailyQuest(msg.leftNum);
		}

		private function refreshDailyQuest(leftNum : int) : void {
			SignalBusManager.updateDaily.dispatch(DailyManage.ID_QUEST, 2, leftNum);
			_manage.refreshDaily();
			if (_view)
				_view.traceTasks();
		}

		private var _nextWantedTime : int ;

		private function countDown() : void {
//			_nextWantedTime--;
//			if (_nextWantedTime <= 0)
//				SecondsTimer.removeFunction(countDown);
		}
	}
}
