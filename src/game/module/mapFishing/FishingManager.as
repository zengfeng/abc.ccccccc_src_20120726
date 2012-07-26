package game.module.mapFishing {
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.core.user.UserData;
	import game.manager.PreLoadManager;
	import game.manager.SignalBusManager;
	import game.module.daily.DailyManage;
	import game.module.mapFishing.element.FishingSelfPlayer;
	import game.module.mapFishing.pool.FishingPool;
	import game.module.mapFishing.view.AwardPanel;
	import game.module.mapFishing.view.BaitPanel;
	import game.module.mapFishing.view.BasketPanel;
	import game.module.mapFishing.view.ProgressPanel;
	import game.module.quest.QuestUtil;
	import game.net.core.Common;
	import game.net.data.CtoS.CSCancelFish;
	import game.net.data.CtoS.CSFishBegin;
	import game.net.data.CtoS.CSFishDraw;
	import game.net.data.CtoS.CSInstantFish;
	import game.net.data.StoC.SCCancelFishRes;
	import game.net.data.StoC.SCFishBegin;
	import game.net.data.StoC.SCFishDraw;
	import game.net.data.StoC.SCFishReady;
	import game.net.data.StoC.SCInstantFish;

	import log4a.Logger;

	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import worlds.apis.MSelfPlayer;
	import worlds.apis.MValidator;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.apis.validators.Validator;

	import com.commUI.alert.Alert;
	import com.greensock.TweenLite;
	import com.utils.UrlUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	// import game.net.data.CtoS.CSFishReady;
	/**
	 * @author Rieman
	 */
	public class FishingManager
	{
		public static const BOX : String = 'fix_box';
		public static const CLOUD : String = 'icon_hint';
		public static const ARROW : String = 'fishArrow';
		// =====================
		// 单例
		// =====================
		private static var __instance : FishingManager;

		public static function get instance() : FishingManager
		{
			if (!__instance)
				__instance = new FishingManager();

			return __instance;
		}

		public function FishingManager() : void
		{
			if (__instance)
				throw(Error("单例错误！"));

			initiate();
		}

		// =====================
		// 属性
		// =====================
		private var _baitPanel : BaitPanel;
		private var _awardPanel : AwardPanel;
		private var _basketPanel : BasketPanel;
		private var _progressPanel : ProgressPanel;
		private var _progressContainer : Sprite;
		private var _selfPlayer : FishingSelfPlayer;
		private var _model : FishingModel;
		private var _pendingShowProgress : Boolean = false;
		private var _volink : uint;
		private var _exitValidator : Validator;

		// =====================
		// Getter/Setter
		// ===============================================================
		public function set selfPlayer(value : FishingSelfPlayer) : void
		{
			_selfPlayer = value;
			if (_selfPlayer && _pendingShowProgress)
			{
				showProgressPanel();
			}
		}

		public function get model() : FishingModel
		{
			return _model;
		}

		public function get baitPanel() : BaitPanel
		{
			if (!_baitPanel)
				_baitPanel = new BaitPanel(_model);
			return _baitPanel;
		}

		public function get awardPanel() : AwardPanel
		{
			if (!_awardPanel)
				_awardPanel = new AwardPanel();
			return _awardPanel;
		}

		public function get basketPanel() : BasketPanel
		{
			if (!_basketPanel)
			{
				_basketPanel = new BasketPanel();
				_basketPanel.title = "鱼篓";
			}
			return _basketPanel;
		}

		public function get progressPanel() : ProgressPanel
		{
			if (!_progressPanel)
			{
				_progressPanel = new ProgressPanel(_model);
				_progressPanel.x = 0;
				_progressPanel.y = -90;
				_progressContainer = new Sprite();
				_progressContainer.addChild(_progressPanel);
			}
			return _progressPanel;
		}

		// =====================
		// 位置
		// =====================
		public function initiate() : void
		{
			_model = new FishingModel();
			_model.timer = new Timer(1000);

			MWorld.sInstallComplete.add(onEnterMap);
		}

		private function onEnterMap() : void
		{
			if (MapUtil.isCapitalMap())
			{
				MWorld.sInstallComplete.remove(onEnterMap);
				MWorld.sUninstallComplete.add(onExitMap);
			}
		}

		private function onExitMap() : void
		{
			MWorld.sInstallComplete.add(onEnterMap);
			MWorld.sUninstallComplete.remove(onExitMap);
			
			FishingPlayerManager.instance.clear();
			FishingPool.instance.clear();
		}

		public function enterFishing(volink : uint) : void
		{
			if (volink == 15)
				_model.resume = false;
			else
				_model.resume = true;

			_volink = volink;

			StateManager.instance.changeState(StateType.FISHING, true);

			var res : RESManager = RESManager.instance;
			PreLoadManager.instance.moduleLoader.startShow("");

			res.add(new SWFLoader(new LibData(UrlUtils.getFishoingSWF(), "fishing")));
			res.addEventListener(Event.COMPLETE, onLoadAssetComplete);
			res.startLoad();
		}

		private function onLoadAssetComplete(event : Event) : void
		{
			RESManager.instance.removeEventListener(Event.COMPLETE, onLoadAssetComplete);
			PreLoadManager.instance.moduleLoader.hide();

			QuestUtil.sendCSNpcReAction(_volink);
			addEvents();
			// MMouse.enableWalk = false;
			// MMouse.sMouseWalk.add(onMouseClickMap);
			MValidator.changeMap.add(onValidateExitFishing);
			MValidator.transport.add(onValidateExitFishing);
			MValidator.walk.add(onValidateExitFishing);
			MValidator.joinOtherActivity.add(onValidateExitFishing);
		}

		public function initProgressPanel() : void
		{
			progressPanel.updateState();
			showProgressPanel();
		}

		private function showProgressPanel() : void
		{
			if (_selfPlayer)
			{
				progressPanel.setPosition(_selfPlayer.getPosition());
				MSelfPlayer.player.uiAdd(_progressContainer);
				_pendingShowProgress = false;
			}
			else
			{
				_pendingShowProgress = true;
			}
		}

		private function showAwardPanel() : void
		{
			awardPanel.y = -280;
			awardPanel.x = -190;
			awardPanel.alpha = 0;
			_selfPlayer.avatar.addChild(awardPanel);

			TweenLite.to(awardPanel, 0.17, {alpha:1, onComplete:onAwardShown});
		}

		private function onAwardShown() : void
		{
			TweenLite.to(awardPanel, 0.17, {delay:2.5, alpha:0, onComplete:onAwardHidden});
		}

		private function onAwardHidden() : void
		{
			awardPanel.hide();
		}

		public function startFishing() : void
		{
			// 检查剩余钓鱼次数
			if (_model.leftTimes <= 0)
			{
				StateManager.instance.checkMsg(182);
				return;
			}

			if (_model.resume)
			{
				// 继续上次钓鱼
				_model.resume = false;
				sendFishBeginMessage();
			}
			else
			// 开始钓鱼，选择鱼饵
				baitPanel.show();
		}

		public function finishFishing() : void
		{
			_model.state = FishingState.INIT;
			progressPanel.updateState();
		}

		public function canelFishing() : void
		{
			Common.game_server.sendMessage(0x3C, new CSCancelFish());
		}

		public function speedUpFishing() : void
		{
			StateManager.instance.checkMsg(22, null, checkSoonDone, [10]);
			function checkSoonDone(type : String) : Boolean
			{
				switch(type)
				{
					case Alert.OK_EVENT :
					case Alert.YES_EVENT :
						if (UserData.instance.trySpendTotalGold(10) >= 0)
							sendInstantFishMessage();
						break;
				}
				return true;
			}
		}

		private function addEvents() : void
		{
			Common.game_server.addCallback(0x3e, onInstantFish);
			Common.game_server.addCallback(0x36, onFishDraw);
			Common.game_server.addCallback(0x37, onFishBegin);
			Common.game_server.addCallback(0x3b, onFishReady);
			Common.game_server.addCallback(0x3C, onCancelFish);
		}

		private function removeEvents() : void
		{
			Common.game_server.removeCallback(0x3b, onFishReady);
			Common.game_server.removeCallback(0x3e, onInstantFish);
			Common.game_server.removeCallback(0x36, onFishDraw);
			Common.game_server.removeCallback(0x37, onFishBegin);
			Common.game_server.removeCallback(0x3C, onCancelFish);
		}

		// ------------------------------------------------
		// S-C Message
		// ------------------------------------------------
		private function onFishReady(msg : SCFishReady) : void
		{
			_model.leftTimes = msg.leftTimes;

			if (_model.leftTimes == 0)
			{
				StateManager.instance.checkMsg(182);
				return;
			}
			else if (_model.leftTimes == 100)
			{
				Logger.info("服务器通知直接拉杆 SCFishingReady");
				_model.resume = false;
				_model.state = FishingState.HOLD;
			}
			else
			{
				Logger.info("服务器通知开始钓鱼 SCFishingReady");
				_model.state = FishingState.INIT;
			}

			initProgressPanel();
		}

		// 0x37
		private function onFishBegin(msg : SCFishBegin) : void
		{
			_model.state = FishingState.WAIT;
			_model.totalSeconds = msg.ret;
			_model.timer.start();
			Logger.info("服务器通知计时开始 SCFishBegin " + msg.ret);
			_model.timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_completeHandler);
			progressPanel.updateState();
		}

		private function onCancelFish(msg : SCCancelFishRes) : void
		{
			Logger.info("服务器通知取消钓鱼 SCCancelFishRes ");
			_model.state = FishingState.INIT;

			if (_progressContainer && _progressContainer.parent)
				MSelfPlayer.player.uiRemove(_progressContainer);
			// _progressContainer.parent.removeChild(_progressContainer);
			if (_baitPanel)
				_baitPanel.hide();
			removeEvents();
			MValidator.changeMap.remove(onValidateExitFishing);
			MValidator.transport.remove(onValidateExitFishing);
			MValidator.walk.remove(onValidateExitFishing);
			MValidator.joinOtherActivity.remove(onValidateExitFishing);
			// MMouse.enableWalk = true;
			// MMouse.sMouseWalk.remove(onMouseClickMap);
			StateManager.instance.changeState(StateType.FISHING, false);

			if (_exitValidator)
			{
				_exitValidator.go();
				_exitValidator = null;
			}
		}

		private function timer_completeHandler(event : TimerEvent) : void
		{
			_model.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timer_completeHandler);
			if (_model.state == FishingState.WAIT)
			{
				_model.state = FishingState.HOLD;
				if (_selfPlayer)
					_selfPlayer.hold();
				progressPanel.updateState();
			}
		}

		private function onInstantFish(msg : SCInstantFish) : void
		{
			if (msg.ret == 0)
			{
				// 可以拉杆
				Logger.info("服务器通知同意加速钓鱼，进入拉杆状态 SCInstantFish " + msg.ret);
				_model.state = FishingState.HOLD;
				_progressPanel.updateState();
				_model.timer.reset();
				_selfPlayer.hold();
			}
			else
			{
				// 元宝不足
				StateManager.instance.checkMsg(4);
			}
		}

		// 0x36
		private function onFishDraw(msg : SCFishDraw) : void
		{
			// 钓鱼成功
			if (msg.ret == 0)
			{
				Logger.info("服务器通知钓鱼成功，获得 " + msg.itemId);
				_model.awardId = msg.itemId;

				if (msg.hasLeftTimes)
				{
					if (msg.leftTimes > 0)
						SignalBusManager.updateDaily.dispatch(DailyManage.ID_FISHING, DailyManage.STATE_OPENED, msg.leftTimes);
					else
						SignalBusManager.updateDaily.dispatch(DailyManage.ID_FISHING, DailyManage.STATE_ENDED, msg.leftTimes);
					_model.leftTimes = msg.leftTimes;
				}

				_model.state = FishingState.PULL;
				_progressPanel.updateState();

				var award : Item = ItemManager.instance.newItem(msg.itemId);
				awardPanel.award = award;
				_selfPlayer.pull(award.imgUrl, onPullComplete);
			}
			// 包裹已满
			else if (msg.ret == 0xFF)
			{
				// 包裹满
				StateManager.instance.checkMsg(153);
			}
			else
			{
				// 刷新时间
				Logger.info("服务器通知刷新剩余时间，注意！！ " + msg.ret);
				_model.totalSeconds = msg.ret;
			}
		}

		private function onPullComplete() : void
		{
			if (_model.leftTimes == 0)
				_model.state = FishingState.ZERO;
			else
				_model.state = FishingState.INIT;
			_progressPanel.updateState();
			showAwardPanel();
		}

		// ------------------------------------------------
		// C-S Message
		// ------------------------------------------------
		public function sendFishReadyMessage() : void
		{
			Logger.info("开始 CSFishReady");
			// Common.game_server.sendMessage(0x3b, new CSFishReady());
		}

		public function sendFishDrawMessage() : void
		{
			Logger.info("拉杆 CSFishDraw");
			var msg : CSFishDraw = new CSFishDraw();
			Common.game_server.sendMessage(0x36, msg);
		}

		public function sendFishBeginMessage() : void
		{
			Logger.info("撒饵 CSFishBegin" + _model.bait);
			var msg : CSFishBegin = new CSFishBegin();
			msg.quality = _model.bait;
			Common.game_server.sendMessage(0x37, msg);
		}

		public function sendInstantFishMessage() : void
		{
			Logger.info("立即完成 CSInstanceFish");
			Common.game_server.sendMessage(0x3e, new CSInstantFish());
		}

		// private function onMouseClickMap(x:int, y:int):void
		// {
		// canelFishing();
		// }
		// private function onWalkLeaveFishing(doWhat : int) : Boolean
		// {
		// doWhat;
		//
		//
		// StateManager.instance.checkMsg(21, [], checkWalkLeaveFishing);
		// return false;
		// }
		private function onValidateExitFishing(v : Validator) : Boolean
		{
			_exitValidator = v;
			StateManager.instance.checkMsg(21, [], checkWalkLeaveFishing);
			return false;
		}

		private function checkWalkLeaveFishing(type : String) : Boolean
		{
			if (type == Alert.YES_EVENT || type == Alert.OK_EVENT)
			{
				canelFishing();
			}
			// else
			// {
			// _exitValidator = null;
			// }

			return true;
		}
	}
}
