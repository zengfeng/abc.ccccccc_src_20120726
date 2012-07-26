package game.module.monsterPot
{
	import game.module.battle.view.BTSystem;
	import game.module.quest.QuestDisplayManager;
	import game.net.core.Common;
	import game.net.data.CtoC.CCVIPLevelChange;
	import game.net.data.CtoS.CSChallengeDemon;
	import game.net.data.CtoS.CSResetDemon;
	import game.net.data.StoC.SCChallengeDemon;
	import game.net.data.StoC.SCDemonInfo;
	import game.net.data.StoC.SCDemonLoot;
	import game.net.data.StoC.SCDemonOpen;
	import game.net.data.StoC.SCResetDemon;

	import log4a.Logger;

	/**
	 * @author jian
	 */
	public class MonsterPotManager
	{
		// ===============================================================
		// 单例
		// ===============================================================
		private static var __instance : MonsterPotManager = null;

		public static function get instance() : MonsterPotManager
		{
			if (__instance == null)
			{
				__instance = new MonsterPotManager();
			}
			return __instance;
		}

		public function MonsterPotManager()
		{
			if (__instance)
				throw (Error("单例错误！"));

			__instance = this;
		}

		// ===============================================================
		// 属性
		// ===============================================================
		private var _view : MonsterPotScene;
		private var _model : MonsterPotModel = new MonsterPotModel();

		public function get model() : MonsterPotModel
		{
			return _model;
		}

		public function set view(value : MonsterPotScene) : void
		{
			_view = value;
		}

		public function get view() : MonsterPotScene
		{
			return _view;
		}

		// ===============================================================
		// 方法
		// ===============================================================
		public function initiate() : void
		{
			Common.game_server.addCallback(0x88, onReceiveDemonInfo);
			Common.game_server.addCallback(0x89, onReceiveChallengeDemon);
			Common.game_server.addCallback(0x8A, onReceiveResetDemon);
			Common.game_server.addCallback(0x8B, onReceiveDemonLoot);
			Common.game_server.addCallback(0x8C, onReceiveDemonOpen);
			Common.game_server.addCallback(0xFFF7, onVIPChange);

			sendDemonInfoRequest();
		}

		// ------------------------------------------------
		// 响应服务器消息
		// ------------------------------------------------
		private function onReceiveDemonInfo(msg : SCDemonInfo) : void
		{
			Logger.info("SCDemonInfo");

			var countryVO : MonsterCountryVO;
			var countryId : uint;
			var nextMonsterId : uint;
			var usedReset : uint;
			var passCount : uint;

			// 开启国
			var openedCountryId : int = int(msg.openedDemon / 100);
			var openedMonsterId : int = msg.openedDemon % 100;

			_model.openedCountryId = openedCountryId;
			if (_model.currentCountryId == 0)
				_model.currentCountryId = openedCountryId;

			// 最大重置次数
			_model.maxFreeResetCount = msg.maxResetCount >> 5;
			_model.maxGoldResetCount = msg.maxResetCount & 0x1F - _model.maxFreeResetCount;

			for each (countryVO in _model.countries)
			{
				// 是否开启
				countryVO.opened = (countryVO.countryId <= openedCountryId);
				// 全开，带到某怪，未开启
				countryVO.openedMonsterId = (countryVO.countryId < openedCountryId) ? 5 : (countryVO.countryId == openedCountryId) ? openedMonsterId : 0;

				// 重置次数
				countryVO.goldResetCount = _model.maxGoldResetCount;
				countryVO.freeResetCount = _model.maxFreeResetCount;
			}

			// 读取数据包信息
			for (var i : int = 0; i < msg.progress.length; i++)
			{
				countryId = Math.floor(((msg.progress[i] & 0xFFFFF ) >> 7 ) / 100);
				nextMonsterId = ((msg.progress[i] & 0xFFFFF ) >> 7) % 100;
				usedReset = msg.progress[i] & 0x7F;
				passCount = msg.progress[i] >> 20; 
				
				countryVO = _model.getCountryVoById(countryId);
				// 下一个挑战怪物
				countryVO.nextMonsterId = nextMonsterId < 1 ? 1 : nextMonsterId;
				// 免费重置次数
				countryVO.freeResetCount = Math.max(0, _model.maxFreeResetCount - usedReset);
				// 元宝充值次数
				countryVO.goldResetCount = Math.min(_model.maxGoldResetCount, _model.maxFreeResetCount + _model.maxGoldResetCount - usedReset);
				// 通关次数
				countryVO.passCount = passCount;
			}

			if (msg.hasCorpseId)
			{
				countryId = int(msg.corpseId / 100);
				countryVO = _model.getCountryVoById(countryId);

				countryVO.currentMonsterId = (msg.corpseId % 100);
				countryVO.state = MonsterCountryVO.CORPSE;
				countryVO.stuffItems = msg.items;

				// 如果有尸体，默认打开有尸体的国
				_model.currentCountryId = countryId;
			}

			for each (countryVO in _model.countries)
			{
				trace(countryVO.toString());
			}

			// 更新视图
			updateView();
		}

		private function onReceiveChallengeDemon(msg : SCChallengeDemon) : void
		{
			if (msg.result == false)
				return;

			var countryId : uint = Math.floor(msg.demonId / 100);
			var nextMonsterId : uint = msg.demonId % 100;

			var countryVO : MonsterCountryVO = _model.getCountryVoById(countryId);
			countryVO.nextMonsterId = nextMonsterId;
			countryVO.stuffItems = msg.items;
			countryVO.state = MonsterCountryVO.CORPSE;

			if (nextMonsterId != countryVO.currentMonsterId + 1)
			{
				countryVO.currentMonsterId = nextMonsterId - 1;
				Logger.error("锁妖壶客户端服务器不同步！");
			}

			_model.currentCountryId = countryId;

			trace(countryVO.toString());
			
			// 通关次数加1
			if (nextMonsterId > 5)
				countryVO.passCount++;

			if (nextMonsterId > 5 && countryVO.passCount == 1)
			{
				if (BTSystem.INSTANCE().isInBattle)
				{
					BTSystem.INSTANCE().addClickEndCall({fun:onArchivement, arg:[countryVO]});
				}
				else
				{
					onArchivement(countryVO);
				}
			}

			updateView();
		}

		private function onArchivement(countryVO : MonsterCountryVO) : void
		{
			QuestDisplayManager.getInstance().playAchieve("通关" + countryVO.countryName + "炼妖壶");
		}

		// 锁妖尸体已拾取
		private function onReceiveDemonLoot(msg : SCDemonLoot) : void
		{
			var countryVO : MonsterCountryVO = _model.getCountryVoById(_model.currentCountryId);

			countryVO.state = MonsterCountryVO.IDLE;
			countryVO.currentMonsterId = 0;

			updateView();
		}

		// 重置锁妖
		private function onReceiveResetDemon(msg : SCResetDemon) : void
		{
			var countryId : int = int(msg.demonId / 100);
			var monsterId : int = msg.demonId % 100;

			var countryVO : MonsterCountryVO = _model.getCountryVoById(countryId);
			countryVO.nextMonsterId = monsterId;
			countryVO.freeResetCount = Math.max(msg.countLeft - _model.maxGoldResetCount, 0);
			countryVO.goldResetCount = Math.min(msg.countLeft, _model.maxGoldResetCount);
			countryVO.currentMonsterId = 0;
			countryVO.state = MonsterCountryVO.IDLE;

			updateView();
		}

		// 锁妖开放
		private function onReceiveDemonOpen(msg : SCDemonOpen) : void
		{
			var openedCountryId : int = int(msg.demonId / 100);
			var openedMonsterId : int = msg.demonId % 100;

			_model.openedCountryId = openedCountryId;

			var countryVO : MonsterCountryVO = _model.getCountryVoById(openedCountryId);
			countryVO.openedMonsterId = openedMonsterId;

			if (_model.currentCountryId == 0)
				_model.currentCountryId = openedCountryId;

			for each (countryVO in _model.countries)
			{
				// 是否开启
				countryVO.opened = (countryVO.countryId <= openedCountryId);
				// 全开，带到某怪，未开启
				countryVO.openedMonsterId = (countryVO.countryId < openedCountryId) ? 5 : (countryVO.countryId == openedCountryId) ? openedMonsterId : 0;
			}

			updateView();
		}

		// VIP等级变化
		private function onVIPChange(msg : CCVIPLevelChange) : void
		{
			// VIP等级变化，重置炼妖壶
			sendDemonInfoRequest();
		}

		// ------------------------------------------------
		// 发送消息至服务器
		// ------------------------------------------------
		// 请求锁妖壶信息
		public function sendDemonInfoRequest() : void
		{
			Common.game_server.sendMessage(0x88);
		}

		// 挑战锁妖壶
		public function sendChallengeDemonRequest() : void
		{
			var msg : CSChallengeDemon = new CSChallengeDemon();
			msg.cityId = _model.currentCountryId;
			Common.game_server.sendMessage(0x89, msg);
		}

		// 重置锁妖壶
		public function sendResetDemonRequest() : void
		{
			var msg : CSResetDemon = new CSResetDemon();
			msg.cityId = _model.currentCountryId;
			Common.game_server.sendMessage(0x8A, msg);
		}

		// 获取战利品
		public function sendLootAwardRequest() : void
		{
			Common.game_server.sendMessage(0x8B);
		}

		// ------------------------------------------------
		// 控制视图
		// ------------------------------------------------
		private function updateView() : void
		{
			if (_view && _view.parent)
				_view.updateView();
		}

		public function debug() : void
		{
			Logger.debug("已开启：" + _model.openedCountryId);
			Logger.debug("当前国：" + _model.currentCountryId);
			for each (var countryVO:MonsterCountryVO in _model.countries)
			{
				Logger.debug(countryVO.toString());
			}
		}
	}
}
