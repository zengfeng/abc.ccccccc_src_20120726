package game.module.mapMining.element
{
	import flash.utils.setTimeout;
	import game.core.avatar.AvatarPlayer;
	import game.module.mapMining.MiningManager;

	import worlds.apis.MPlayer;
	import worlds.roles.cores.Player;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jian
	 */
	public class MiningPlayer
	{
		// 玩家id
		public var playerId : int;
		// 模型Id
		public var modelId:int;
		// 座位id
		public var seatId : int;
		// 矿工Avatar
		protected var avatarMiner : AvatarPlayer;
		// 玩家Player
		private var _player : Player;

		public function get player() : Player
		{
			return _player;
		}

		public function enter() : void
		{
			_player = MPlayer.getPlayer(playerId);
			if (!_player)
				throw (Error("获取玩家Player未空！" + playerId));
			_player.changeModel(modelId);
			avatarMiner = player.avatar as AvatarPlayer;
			avatarMiner.standDirection(avatarMiner.x, avatarMiner.y + 20);
			avatarMiner.changeModel(12);
		}

		public function exit() : void
		{
			_player.avatar.changeModel();
			_player = null;
			avatarMiner = null;
		}

		public function takePlace() : void
		{
			avatarMiner.setAction(avatarMiner.direction + 10);
			
			setTimeout(digMineral, 1000);
		}

		public function digMineral() : void
		{
			if(!_player)
				return;
			if(!avatarMiner)
				return;
				
			avatarMiner.setAction(avatarMiner.direction + 15, 1);
			avatarMiner.player.addEventListener(Event.COMPLETE, onDigComplete);
			MiningManager.instance.pool.sitDown(seatId);
		}

		protected function onDigComplete(event : Event) : void
		{
			(event.currentTarget as Sprite).removeEventListener(Event.COMPLETE, onDigComplete);
			var avatar : AvatarPlayer = player.avatar as AvatarPlayer;
			avatar.stand();
			MiningManager.instance.pool.returnSeat(seatId);
		}

		public function stand() : void
		{
			if (avatarMiner.player.hasEventListener(Event.COMPLETE))
				avatarMiner.player.removeEventListener(Event.COMPLETE, onDigComplete);
			avatarMiner.stand();
		}
	}
}
