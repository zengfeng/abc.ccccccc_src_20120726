package game.module.mapMining
{
	import game.core.avatar.AvatarThumb;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.DailyInfoManager;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.daily.DailyManage;
	import game.module.mapMining.element.MiningPlayer;
	import game.module.mapMining.element.MiningSelfPlayer;
	import game.module.mapMining.event.MiningEvent;
	import game.module.mapMining.pool.MiningPool;
	import game.module.mapMining.scene.MiningScene;
	import game.module.mapMining.ui.MineralBasket;
	import game.module.mapMining.ui.MiningAwardPanel;
	import game.module.mapMining.ui.MiningPanel;
	import game.module.quest.QuestUtil;
	import game.module.quest.guide.GuideMange;
	import game.module.quest.guide.GuideType;
	import game.net.core.Common;
	import game.net.data.CtoS.CSMiningReceive;
	import game.net.data.CtoS.CSMiningStart;
	import game.net.data.StoC.SCMiningPlayerStart;
	import game.net.data.StoC.SCMiningResult;

	import gameui.controls.GButton;
	import gameui.core.GAlign;
	import gameui.core.ScaleMode;
	import gameui.data.GButtonData;
	import gameui.layout.GLayout;

	import log4a.Logger;

	import net.AssetData;

	import worlds.apis.MNpc;
	import worlds.apis.MPlayer;
	import worlds.apis.MValidator;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.apis.validators.Validator;
	import worlds.roles.cores.Role;

	import com.commUI.alert.Alert;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * @author jian
	 */
	public class MiningManager
	{
		// =====================
		// 矿工系统
		// 1. 副本地图，设置若干采矿点，玩家可以在采矿点上采矿，获得仙石。
		// 2. 玩家进入采矿区域，换矿工装。玩家离开采矿区域，换回正常装束。
		// 3. 玩家有小矿骡。小矿骡跟随玩家。小矿骡可以点击，弹出矿篓窗口。
		// 4. 采矿有动画。
		// 5. 每日采矿有次数限制
		// =====================
		// =====================
		// 单例
		// =====================
		private static var __instance : MiningManager;

		public static function get instance() : MiningManager
		{
			if (!__instance)
				__instance = new MiningManager();

			return __instance;
		}

		public function MiningManager()
		{
			if (__instance)
				throw ("单例错误！");

			__instance = this;

			initiate();
		}

		// =====================
		// 属性
		// =====================
		// 批量的个数
		private static const BATCH_COUNT : int = 12;
		// 采矿配置文件
		private var _config : MiningConfig;
		// 玩家存储表
		private var _playerDictionary : Dictionary;
		// 自己采矿玩家
		private var _miningSelfPlayer : MiningSelfPlayer;
		// 控制面板
		private var _miningPanel : MiningPanel;
		// 获取面板
		private var _awardPanel : MiningAwardPanel;
		// 矿楼
		private var _mineralBasket : MineralBasket;
		// 退出按钮
		private var _exitButton : GButton;
		// 矿场位置管理器
		private var _miningPool : MiningPool;
		// 场景动态管理器
		private var _scene : MiningScene;
		// 目标晶石id
		private var _targetStoneId : int = -1;
		// 目标晶石
		private var _targetStone : Role;
		// 是否自动寻路
		private var _isAutoRouting : Boolean = false;
		// 获取仙石
		private var _awards : Array;
		// 合并同类仙石
		private var _mergedAwards : Array;
		// 延时创建的玩家
		private var _delaySetupPlayers : Array;
		// 采矿中
		private var _isMining : Boolean = false;
		// 参加活动
		private var _validator : Validator;

		// =====================
		// getter/setter
		// =====================
		public function get batchMode() : Boolean
		{
			return _miningPanel.batchMode;
		}

		public function get selfIsMining() : Boolean
		{
			return _miningSelfPlayer ? true : false;
		}

		public function get miningSelfPlayer() : MiningSelfPlayer
		{
			return _miningSelfPlayer;
		}

		public function get awardPanel() : MiningAwardPanel
		{
			if (!_awardPanel)
			{
				_awardPanel = new MiningAwardPanel();
				// _awardPanel.x = 1000;
				// _awardPanel.y = 500;
			}
			return _awardPanel;
		}

		public function get mineralBasket() : MineralBasket
		{
			if (!_mineralBasket)
				_mineralBasket = new MineralBasket();

			return _mineralBasket;
		}

		public function get miningPanel() : MiningPanel
		{
			if (!_miningPanel)
				_miningPanel = new MiningPanel();

			return _miningPanel;
		}

		public function get scene() : MiningScene
		{
			if (!_scene)
				_scene = new MiningScene();

			return _scene;
		}

		public function get exitButton() : GButton
		{
			if (!_exitButton)
			{
				var data : GButtonData = new GButtonData();
				data.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
				data.align = new GAlign(-1, 20, 20);
				data.upAsset = new AssetData(UI.BUTTON_EXIT_UP);
				data.overAsset = new AssetData(UI.BUTTON_EXIT_OVER);
				data.downAsset = new AssetData(UI.BUTTON_EXIT_DOWN);
				data.scaleMode = ScaleMode.SCALE_NONE;
				_exitButton = new GButton(data);
			}

			return _exitButton;
		}

		public function get pool() : MiningPool
		{
			return _miningPool;
		}

		public function set config(value : MiningConfig) : void
		{
			_config = value;
		}

		public function get timesLeft() : int
		{
			return _miningPanel.timesLeft;
		}

		private function decreaseTimes() : void
		{
			var times : int = _miningPanel.timesLeft;

			if (batchMode)
				times -= BATCH_COUNT;
			else
				times--;

			if (times < 0)
				times = 0;

			_miningPanel.timesLeft = times;
			SignalBusManager.updateDaily.dispatch(DailyManage.ID_MINING, (times > 0 || UserData.instance.vipLevel >= MiningUtils.VIP_LEVEL) ? DailyManage.STATE_OPENED : DailyManage.STATE_ENDED, times);
		}

		private function get mapSetup() : Boolean
		{
			return MWorld.isInstallComplete && MapUtil.currentMapId == MiningUtils.MAP_ID;
		}

		private var _isMapRealSetup : Boolean = false;

		// =====================
		// 方法
		// =====================
		private function initiate() : void
		{
			var seats : Array = [];

			_miningPool = new MiningPool(seats);
			_delaySetupPlayers = [];
			initPlayerDictionary();

			MPlayer.MODEL_MINGING_IN.add(playerIn);
			MPlayer.MODEL_MINGING_OUT.add(playerOut);
		}
		
		// 玩家进入采矿地图
		public function playerIn(playerId : int, modelId : int) : void
		{
			// 判断玩家是否为主将

			//
			var player : MiningPlayer;

			if (playerId == UserData.instance.playerId)
			{
				player = _miningSelfPlayer = new MiningSelfPlayer();
				enterMining();
			}
			else
			{
				player = new MiningPlayer();
			}

			player.playerId = playerId;
			player.modelId = modelId;

			if (!(player is MiningSelfPlayer))
			{
				if (mapSetup)
				{
					player.enter();
				}
				else
				{
					_delaySetupPlayers.push(player);
				}
			}

			_playerDictionary[playerId] = player;
		}

		// 玩家退出采矿地图
		public function playerOut(playerId : int) : void
		{
			var player : MiningPlayer = _playerDictionary[playerId];

			if (player == null)
				return;

			player.exit();
			delete _playerDictionary[playerId];

			if (player is MiningSelfPlayer)
			{
				clearPlayerDictionary();
				exitMining();
				_miningSelfPlayer = null;
			}
		}

		// 进入矿场
		private function enterMining() : void
		{
			StateManager.instance.changeState(StateType.MINING, true);
			if (mapSetup)
				realEnterMining();
			else
				MWorld.sInstallComplete.add(onMapSetupComplete);
		}

		private function onMapSetupComplete() : void
		{
			_isMapRealSetup = true;
			MWorld.sInstallComplete.remove(onMapSetupComplete);
			realEnterMining();
		}

		private function realEnterMining() : void
		{
			if (!_isMapRealSetup)
				return;

			MValidator.changeMap.add(onValidateExitMining);
			MValidator.walk.add(onValidateExitMining);
			MValidator.transport.add(onValidateExitMining);
			MValidator.joinOtherActivity.add(onValidateExitMining);

			GuideMange.getInstance().checkGuide(GuideType.MINING, 0, miningPanel);
			setupDelayPlayers();
			SignalBusManager.clickNPC.add(onClickNPC);
			Common.game_server.addCallback(0x1D0, onMiningResult);
			Common.game_server.addCallback(0x1D1, onMiningPlayerStart);
			_miningSelfPlayer.enter();
			_miningSelfPlayer.eventDispatcher.addEventListener(MiningEvent.OPEN_BASKET, onOpenBasket);
			miningPanel.addEventListener(MiningEvent.GO, goMiningHandler);
			exitButton.show();
			miningPanel.show();
			GLayout.layout(exitButton);
			GLayout.layout(miningPanel);
			exitButton.addEventListener(MouseEvent.CLICK, onClickExit);
			SignalBusManager.selfStartWalk.add(onStartWalking);
			onUpdateDaily();
			SignalBusManager.onUpdateDaily.add(onUpdateDaily);

			scene.enterScene();
		}

		private function onValidateExitMining(v : Validator) : Boolean
		{
			if (_isMining)
			{	
				_validator = v;
				return false;
			}
			else
			{
				return true;
			}
		}

		private function setupDelayPlayers() : void
		{
			for each (var player:MiningPlayer in _delaySetupPlayers)
			{
				player.enter();
			}

			_delaySetupPlayers = [];
		}

		// 其他玩家开始采矿
		private function onMiningPlayerStart(msg : SCMiningPlayerStart) : void
		{
			// 不处理自己
			if (msg.playerId == UserData.instance.playerId)
				return;

			var player : MiningPlayer = _playerDictionary[msg.playerId];

			if (!player)
				return;

			player.seatId = msg.mineralId;
			player.takePlace();
		}

		// 点击退出
		private function onClickExit(event : Event) : void
		{
			MWorld.csBackMap();
		}

		// 点击前往采矿
		private function goMiningHandler(event : MiningEvent) : void
		{
			if (!checkCondition())
				return;

			GuideMange.getInstance().checkGuide(GuideType.MINING, 2);
			// TODO：随即位置需要改为根据玩家数目优选
			if (_targetStoneId <= 0)
			{
				var stones : Array = MiningUtils.getStones();
				var index : int = int(Math.random() * (stones.length - 1));
				trace("随机第" + index + "块晶石");
				_targetStoneId = stones[index];
			}
			QuestUtil.goAndClickNpc(_targetStoneId);
			startAutoRouting();
		}

		// 开始
		private function onStartWalking() : void
		{
			if (_isAutoRouting)
			{
				stopAutoRouting();
			}
			else
			{
				//
			}
		}

		// 退出矿场
		private function exitMining() : void
		{
			Logger.info("退出采矿");
			_isMapRealSetup = false;
			_miningSelfPlayer.eventDispatcher.removeEventListener(MiningEvent.OPEN_BASKET, onOpenBasket);
			MValidator.changeMap.remove(onValidateExitMining);
			MValidator.walk.remove(onValidateExitMining);
			MValidator.transport.remove(onValidateExitMining);
			MValidator.joinOtherActivity.remove(onValidateExitMining);
			SignalBusManager.clickNPC.remove(onClickNPC);
			Common.game_server.removeCallback(0x1D0, onMiningResult);
			Common.game_server.removeCallback(0x1D1, onMiningPlayerStart);
			SignalBusManager.selfStartWalk.remove(onStartWalking);
			miningPanel.removeEventListener(MiningEvent.GO, goMiningHandler);
			exitButton.removeEventListener(MouseEvent.CLICK, onClickExit);
			exitButton.hide();
			miningPanel.hide();
			_isAutoRouting = false;
			SignalBusManager.onUpdateDaily.add(onUpdateDaily);
			StateManager.instance.changeState(StateType.MINING, false);
			scene.exitScene();
		}

		private function onUpdateDaily() : void
		{
			_miningPanel.timesLeft = DailyInfoManager.instance.getDailyVar(DailyManage.ID_MINING);
		}

		// 打开矿篓
		private function onOpenBasket(event : Event) : void
		{
			mineralBasket.show();
		}

		// 点击NPC（开始采矿）
		private function onClickNPC(npcId : int) : void
		{
			Logger.info("点击NPC");

			if (timesLeft < 1)
			{
				// StateManager.instance.checkMsg(msgId)
			}

			if (MiningUtils.isStoneNpc(npcId))
			{
				_targetStoneId = npcId;
				_targetStone = MNpc.getNpc(npcId);
				startMining();
			}
		}

		// 开始采矿
		private function startMining() : void
		{
			if (_isAutoRouting)
				stopAutoRouting();
			Logger.info("开始采矿！");
			Logger.info("播放采矿动画！");
			GuideMange.getInstance().checkGuide(GuideType.MINING, 2);

			if (!checkCondition())
				return;

			if (_miningPanel.useGold)
				StateManager.instance.checkMsg(402, null, onConfirmSpendGold, [_miningPanel.batchMode ? MiningUtils.GOLD_COST * MiningUtils.BATCH_TIMES : MiningUtils.GOLD_COST]);
			else
				realStartMining();
		}

		private function onConfirmSpendGold(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				realStartMining();
			}

			return true;
		}

		private function realStartMining() : void
		{
			_isMining = true;
			// MMouse.enableWalk = false;

			_miningSelfPlayer.takePlace();
			_miningPanel.digging = true;
			_scene.showLightCircle(_targetStoneId);

			setTimeout(onMiningComplete, 2000);
		}

		// 判断条件是否满足
		private function checkCondition() : Boolean
		{
			// 免费采矿次数
			if (_miningPanel.timesLeft == 0 && !_miningPanel.useGold)
			{
				StateManager.instance.checkMsg(400);
				return false;
			}

			// 包裹空间不足
			if (UserData.instance.tryPutPack(calculatePackCost()) < 0)
			{
				StateManager.instance.checkMsg(153);
				return false;
			}

			// 元宝不足
			if (_miningPanel.useGold && UserData.instance.trySpendTotalGold(MiningUtils.GOLD_COST) < 0)
			{
				StateManager.instance.checkMsg(4);
				return false;
			}

			return true;
		}

		// 计算包裹容量
		private function calculatePackCost() : int
		{
			if (!_miningPanel.batchMode)
				return 1;

			if (_miningPanel.useGold)
				return 8;

			return Math.min(_miningPanel.timesLeft, 4);
		}

		private function startAutoRouting() : void
		{
			_isAutoRouting = true;
			// TODO: 切换按钮
		}

		private function stopAutoRouting() : void
		{
			_isAutoRouting = false;
			// TODO：切换按钮
		}

		private function onMiningComplete() : void
		{
			sendMiningStartMessage(batchMode, _miningPanel.useGold, 0);
			Logger.info("动画播放完毕，向服务器发送采矿结果请求");
		}

		private function onMiningResult(msg : SCMiningResult) : void
		{
			// 空列表，非法挖掘
			if (msg.itemId.length == 0)
			{
				_isMining = false;
				Logger.error("非法采集！");
				_miningPanel.digging = false;
//				MMouse.enableWalk = true;
				_miningSelfPlayer.stand();
				scene.hideLightCircle();
				return;
			}

			decreaseTimes();

			var itemDict : Dictionary = new Dictionary();
			var item : Item;
			var itemId : int;
			var itemNum : int;

			_awards = [];
			for each (var id:uint in msg.itemId)
			{
				itemId = id & 0xFFFF;
				itemNum = id >> 16;

				item = ItemManager.instance.newItem(itemId);
				item.nums = itemNum;
				_awards.push(item);

				if (itemDict[itemId])
					itemDict[itemId] += itemNum;
				else
					itemDict[itemId] = itemNum;
			}

			_mergedAwards = [];

			for (var key:String in itemDict)
			{
				itemId = int(key);
				item = ItemManager.instance.newItem(itemId, true);
				item.nums = itemDict[itemId];
				_mergedAwards.push(item);
			}

			setTimeout(onShowAward, 1500);
			_miningSelfPlayer.digMineral();
									_miningPanel.digging = false;
			scene.hideLightCircle();
			scene.playStoneAnimation(_awards, _targetStone, _miningSelfPlayer.donkey);

			Logger.info("收到服务器采矿结果");
			Logger.info("播放矿石飞入包裹动画");
		}

		// 弹出获取窗口
		private function onShowAward() : void
		{
			_isMining = false;
			// MMouse.enableWalk = true;

			awardPanel.awards = _mergedAwards;
			var avatar : AvatarThumb = _miningSelfPlayer.player.avatar;
			var parent : DisplayObjectContainer = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			var point : Point = parent.globalToLocal(avatar.localToGlobal(new Point(-10, -120)));
			awardPanel.x = point.x;
			awardPanel.y = point.y - 50;
			awardPanel.scaleX = 0.1;
			awardPanel.scaleY = 0.1;
			parent.addChild(awardPanel);
			TweenLite.to(awardPanel, 0.25, {scaleX:1, scaleY:1, y:point.y, ease:Expo.easeOut, onComplete:onAwardShown});
		}

		private function onAwardShown() : void
		{
			TweenLite.to(awardPanel, 0.25, {delay:0.75, alpha:0, onComplete:onAwardHidden});
		}

		private function onAwardHidden() : void
		{
			awardPanel.alpha = 1;
			awardPanel.parent.removeChild(awardPanel);
			endMining();
		}

		// 结束采矿
		private function endMining() : void
		{
			awardPanel.hide();
			sendMiningReceiveMessage();
			
			if (_validator)
			{
				_validator.go();
				_validator = null;
			}
		}

		private function sendMiningReceiveMessage() : void
		{
			Logger.info("收取仙石");
			var msg : CSMiningReceive = new CSMiningReceive();
			Common.game_server.sendMessage(0x1D1, msg);
		}

		private function sendMiningStartMessage(batch : Boolean, useGold : Boolean, mineralId : int) : void
		{
			var msg : CSMiningStart = new CSMiningStart();
			msg.batch = batch;
			msg.useGold = useGold;
			// TODO
			msg.mineralId = mineralId;
			Common.game_server.sendMessage(0x1D0, msg);
		}

		//
		public function initPlayerDictionary() : void
		{
			_playerDictionary = new Dictionary();
		}

		public function clearPlayerDictionary() : void
		{
			_playerDictionary = new Dictionary();
		}
	}
}
