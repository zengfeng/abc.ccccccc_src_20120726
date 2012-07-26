package game.module.mapFishing
{
	import log4a.Logger;
	import game.core.user.UserData;
	import game.module.mapFishing.element.FishingPlayer;
	import game.module.mapFishing.element.FishingSelfPlayer;

	import worlds.apis.MPlayer;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-16 ����12:43:08
	 */
	public class FishingController
	{
		public function FishingController(singleton : Singleton)
		{
			singleton;
			initiate();
		}

		/** 单例对像 */
		private static var _instance : FishingController;

		/** 获取单例对像 */
		static public function get instance() : FishingController
		{
			if (_instance == null)
			{
				_instance = new FishingController(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 钓鱼玩家管理器 */
		private var fishingPlayerManager : FishingPlayerManager = FishingPlayerManager.instance;


		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 是否进入钓鱼地图 */
		private var _isEnter : Boolean = true;

		/** 是否进入钓鱼地图 */
		public function get isEnter() : Boolean
		{
			return _isEnter;
		}

		/** 自己玩家ID */
		private function get selfPlayerId() : int
		{
			return UserData.instance.playerId;
		}

		/** 自己钓鱼玩家 */
		private var fishingSelfPlayer : FishingSelfPlayer;

		/** 自己是否在钓鱼中 */
		public function get selfIsFishing() : Boolean
		{
			return fishingSelfPlayer ? true : false;
		}

		private function initiate() : void
		{
			MPlayer.MODEL_FISHING_IN.add(playerIn);
			MPlayer.MODEL_FISHING_OUT.add(playerOut);
		}

		/** 玩家进入钓鱼模式 */
		public function playerIn(playerId : int, modelId : int) : void
		{
			var fishingPlayer : FishingPlayer = fishingPlayerManager.getPlayer(playerId);

			// 如果该玩家已经在钓鱼中
			if (fishingPlayer != null)
				return;

			fishingPlayer = playerId != selfPlayerId ? new FishingPlayer() : new FishingSelfPlayer();
			fishingPlayer.playerId = playerId;
			fishingPlayer.modelId = modelId;
			fishingPlayer.player = MPlayer.getPlayer(playerId);
			fishingPlayer.enter();

			if (playerId == selfPlayerId)
			{
				fishingSelfPlayer = fishingPlayer as FishingSelfPlayer;
				FishingManager.instance.selfPlayer = fishingSelfPlayer;
			}

			fishingPlayerManager.addPlayer(fishingPlayer);
		}

		/** 玩家退出钓鱼模式 */
		public function playerOut(playerId : int) : void
		{
			var fishingPlayer : FishingPlayer = fishingPlayerManager.getPlayer(playerId);
			if (fishingPlayer == null)
			{
				Logger.error("错误的钓鱼玩家" + playerId);
				return;
			}

			fishingPlayerManager.removePlayer(playerId);

			if (playerId == selfPlayerId)
			{
				fishingSelfPlayer = null;
				FishingManager.instance.selfPlayer = null;
			}

			fishingPlayer.exit();
		}
	}
}
class Singleton
{
}