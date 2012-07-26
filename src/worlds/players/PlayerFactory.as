package worlds.players {
	import game.core.avatar.AvatarPlayer;
	import game.module.bossWar.BossWarSystem;

	import worlds.apis.MMouse;
	import worlds.apis.MPlayer;
	import worlds.apis.MapUtil;
	import worlds.roles.PlayerPool;
	import worlds.roles.animations.AvatarFactory;
	import worlds.roles.animations.PlayerAnimation;
	import worlds.roles.animations.PlayerAnimationPool;
	import worlds.roles.animations.SelfPlayerAnimation;
	import worlds.roles.cores.Player;
	import worlds.roles.cores.SelfPlayer;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-18
	*/
	public class PlayerFactory
	{
		/** 单例对像 */
		private static var _instance : PlayerFactory;

		/** 获取单例对像 */
		public static  function get instance() : PlayerFactory
		{
			if (_instance == null)
			{
				_instance = new PlayerFactory(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var playerPool : PlayerPool;
		private var playerAnimationPool : PlayerAnimationPool;
		private var avatarFactory : AvatarFactory;

		function PlayerFactory(singleton : Singleton) : void
		{
			singleton;
			playerPool = PlayerPool.instance;
			playerAnimationPool = PlayerAnimationPool.instance;
			avatarFactory = AvatarFactory.instance;
		}

		public function makeSelfPlayer(name : String, colorStr : String, heroId : int, clothId : int, rideId : int) : SelfPlayer
		{
			var player : SelfPlayer = SelfPlayer.instance;
			var playerAnimation : PlayerAnimation = new SelfPlayerAnimation();
			var avatar : AvatarPlayer = avatarFactory.makeSelfPlayer(heroId, clothId, rideId, name, colorStr);
			playerAnimation.reset(avatar, name, colorStr);
			player.setAnimation(playerAnimation);
			if(MapUtil.hasMask) player.setNeedMask(true);
			return player;
		}

		public function makePlayer(playerId:int,name : String, colorStr : String, heroId : int, clothId : int, rideId : int) : Player
		{
			var player : Player = playerPool.getObject();
			var playerAnimation : PlayerAnimation = playerAnimationPool.getObject();
			var avatar : AvatarPlayer = avatarFactory.makePlayer(heroId, clothId, rideId, name, colorStr);
			avatar.source = playerId;
//			avatar.addEventListener("clickPlayer", onClickPlayer);
			playerAnimation.reset(avatar, name, colorStr);
			player.setAnimation(playerAnimation);
			player.callShowInfo = onClickPlayer;
			player.clickToType = 2;
			if(MapUtil.hasMask) player.setNeedMask(true);
//			player.addToLayer();
			return player;
		}
		
		public function makePlayerNoAnimation():Player
		{
			var player : Player = playerPool.getObject();
			player.callShowInfo = onClickPlayer;
			player.clickToType = 2;
			return player;
		}
		
		public function makePlayerAnimation(playerId:int,name : String, colorStr : String, heroId : int, clothId : int, rideId : int):PlayerAnimation
		{
			var playerAnimation : PlayerAnimation = playerAnimationPool.getObject();
			var avatar : AvatarPlayer = avatarFactory.makePlayer(heroId, clothId, rideId, name, colorStr);
			avatar.source = playerId;
			playerAnimation.reset(avatar, name, colorStr);
			if(MapUtil.hasMask) playerAnimation.setNeedMask(true);
			return playerAnimation;
		}


		private function onClickPlayer(player:Player) : void
		{
			if(!MMouse.enableShowPlayerInfo) return;
			MPlayer.onClickShowInfo(player.id);
		}
	}
}
class Singleton
{
}