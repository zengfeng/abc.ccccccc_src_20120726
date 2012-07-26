package game.module.quest {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.mapNpcConvoy.NpcConvoy;
	import game.module.quest.animation.ActionDriven;
	import game.module.quest.guide.GuideMange;

	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;

	import net.AssetData;
	import net.RESManager;

	import worlds.apis.MSelfPlayer;
	import worlds.apis.MWorld;

	import com.greensock.TweenLite;
	import com.utils.StringUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;





	/**
	 * @author yangyiqiang
	 */
	public class QuestDisplayManager
	{
		private static var _instance : QuestDisplayManager;

		private var _questView : QuestPanel;

		public var waitForQuest : Array;
		
		public static const SHOW_MAIN:int=101020;

		public function QuestDisplayManager()
		{
			if (_instance)
			{
				throw Error("QuestManager 是单类，不能多次初始化!");
			}
			ViewManager.addStageResizeCallFun(onResize);
			MWorld.sEnterDupl.add(QuestUtil.endAutoRun);
		}

		public static function getInstance() : QuestDisplayManager
		{
			if (_instance == null)
			{
				_instance = new QuestDisplayManager();
			}
			return _instance;
		}

		private function onResize(...args) : void
		{
			if (!_action) return;
			_action.x = UIManager.stage.stageWidth / 2 ;
			_action.y = UIManager.stage.stageHeight * 2 / 3;
		}

		public function get questView() : QuestPanel
		{
			if (!_questView)
			{
				_questView = new QuestPanel();
				_questView.show();
				GLayout.update(UIManager.root, _questView);
			}
			return _questView;
		}

		private var _questList : Array = [];

		public function showQuests(arr : Array) : void
		{
			if (QuestManager.getInstance().isSubmit(SHOW_MAIN))return;
			_questList = arr;
			if (!_questList) return;
			for each (var vo:VoQuest in _questList)
			{
				vo.base.type == 1 ? showMainQuest(vo) : showBranchQuest(vo);
			}
		}

		public function showWait() : void
		{
			showQuests(waitForQuest);
		}

		/** 是否在动画中 */
		public function isShowing(vo : VoQuest) : Boolean
		{
			if (!vo || vo.base.type != 1) return false;
			if (!_currnVo || _currnVo.id != vo.id) return false;
			return true;
		}

		private var _achieveMc : MovieClip;

		public function playAchieve(str : String) : void
		{
			if (str == "") return;
			if (!_achieveMc)
				_achieveMc = RESManager.getMC(new AssetData("questAchieve", "quest"));
			if (!_achieveMc) return;
			_achieveMc.alpha = 1;
			_achieveMc["string"] = str;
			_achieveMc.gotoAndStop(0);
			_achieveMc.x = (UIManager.stage.stageWidth - _achieveMc.width) / 2 - 355;
			_achieveMc.y = (UIManager.stage.stageHeight - _achieveMc.height) / 2;
			UIManager.root.addChild(_achieveMc);
			_achieveMc.gotoAndPlay(0);
			_achieveMc.addEventListener("hide", hideAchieve);
		}

		private function hideAchieve(event : Event) : void
		{
			TweenLite.to(_achieveMc, 1, {delay:2, alpha:0, overwrite:0, onComplete:removeAchieve});
		}

		private function removeAchieve() : void
		{
			if (_achieveMc && _achieveMc.parent) _achieveMc.parent.removeChild(_achieveMc);
		}

		private var _currnVo : VoQuest;

		private var _action : MovieClip;

		public function showMainQuest(vo : VoQuest) :void
		{
			if (ActionDriven.instance().isInQuestAction)
			{
				ActionDriven.instance().addClickEndCall({fun:showMainQuest, arg:[vo]});
				return;
			}
			if (_currnVo == vo) return;
			_currnVo = vo;
			GuideMange.getInstance().hide();
			addQuestMode();
			if (_action && _action.parent)
			{
				_action.gotoAndStop(0);
				_action.alpha = 1;
				_action.parent.removeChild(_action);
			}
			_action = RESManager.getMC(new AssetData("action", "quest"));
			if (_action)
			{
				_action.x = UIManager.stage.stageWidth / 2 ;
				_action.y = UIManager.stage.stageHeight * 2 / 3;
				_action.alpha = 1;
				_action.addEventListener("work", onWork);
				ViewManager.instance.addToStage(_action, ViewManager.AUTO_CONTAINER);
				_action.gotoAndPlay(0);
			}
		}

		public function closeMainQuest() : void
		{
			if (_action && _action.parent)
			{
				_action.gotoAndStop(0);
				_action.removeEventListener(MouseEvent.CLICK, onClick);
				_action.removeEventListener("work", onWork);
				_action.alpha = 1;
				_action.parent.removeChild(_action);
				_action.removeEventListener("close", exit_clickHandler);
			}
			removeQuestMode().removeEventListener(MouseEvent.CLICK, onClick);
			_currnVo = null;
			_questList = [];
			questView.traceTasks();
		}

		private function exit_clickHandler(event : Event) : void
		{
			closeMainQuest();
			QuestUtil.checkQuide();
		}

		private  var modalSkin : Sprite = ASSkin.emptySkin;

		public  function addQuestMode() : Sprite
		{
			if (!modalSkin)
				modalSkin = ASSkin.emptySkin;
			modalSkin.width = UIManager.stage.stageWidth;
			modalSkin.height = UIManager.stage.stageHeight;
			if (!ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).contains(modalSkin))
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).addChild(modalSkin);
			return modalSkin;
		}

		public  function removeQuestMode() : Sprite
		{
			if (modalSkin && modalSkin.parent)
			{
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).removeChild(modalSkin);
			}
			return modalSkin;
		}

		public function checkQuestMain() : Boolean
		{
			if (_action && _action.parent&&_currnVo&&UserData.instance.level < 5)
			{
				GuideMange.getInstance().moveTo(-200, -70, _currnVo.isCompleted ? "点击提交" : "点击接取", _action);
				return true;
			}
			return false;
		}
		
		public function getMainAction():MovieClip
		{
			return _action;
		}

		private function onWork(event : Event) : void
		{
			if (_action && _currnVo)
			{
				var str : String = _currnVo.getTargeString();
				_action["setQuest"](StringUtils.addLine(str), _currnVo.isCompleted ? 0 : 1, _currnVo.isCompleted ? "点击提交" : "点击接取");
				_action.addEventListener(MouseEvent.CLICK, onClick);
				addQuestMode().addEventListener(MouseEvent.CLICK, onClick);
				ViewManager.instance.addToStage(_action, ViewManager.AUTO_CONTAINER);
				_action.addEventListener("close", exit_clickHandler);
				_action.buttonMode = true;
				if (UserData.instance.level > 5) return;
				GuideMange.getInstance().moveTo(-200, -70, _currnVo.isCompleted ? "点击提交" : "点击接取", _action);
			}
		}

		private function showBranchQuest(vo : VoQuest) : void
		{
		}

		private function onClick(event : MouseEvent) : void
		{
			TweenLite.to(_action, 0.5, {alpha:0, onComplete:actionEnd, overwrite:0});
			removeQuestMode().removeEventListener(MouseEvent.CLICK, onClick);
			_action.removeEventListener(MouseEvent.CLICK, onClick);
			_action.removeEventListener("work", onWork);
			if (!_currnVo) return;
			if (_currnVo.base.getCompleteTry() == 7 || _currnVo.base.getCompleteTry() == 8)
			{
				NpcConvoy.removeNpc(_currnVo.base.npcPublish);
				QuestUtil.removeQuestMode();
			}
			if (!_currnVo.isCompleted)
			{
				MSelfPlayer.avatar.questAccept();
				QuestUtil.questVoAction(_currnVo);
				_currnVo = null;
			}
		}

		private function actionEnd() : void
		{
			if (_currnVo && _currnVo.isCompleted&&_currnVo.base.type!=QuestManager.DAILY)
			{
				QuestUtil.sendTaskOperateReq(_currnVo.id, QuestUtil.SUBMIT);
			}
			if (_currnVo && _currnVo.isCompleted&&_currnVo.base.type==QuestManager.DAILY){
				SignalBusManager.questPanelEndMissionUpdate.dispatch(_currnVo.id);
				//TO DO
				if(!MenuManager.getInstance().getMenuState(MenuType.DAILY_QUEST))
					MenuManager.getInstance().openMenuView(MenuType.DAILY_QUEST);
			}
			
			closeMainQuest();
			_questList = [];
		}
	}
}
