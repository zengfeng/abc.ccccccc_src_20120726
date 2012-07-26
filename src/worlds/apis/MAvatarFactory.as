package worlds.apis {
	import game.core.avatar.AvatarMonster;
	import game.core.avatar.AvatarNpc;

	import worlds.roles.animations.AvatarFactory;
	public class MAvatarFactory
	{
		public static function makeMonster(avatarId:int):AvatarMonster
		{
			return AvatarFactory.instance.makeMonster(avatarId);
		}
		
		public static function makeNpc(npcId:int):AvatarNpc
		{
			return AvatarFactory.instance.makeNpc(npcId);
		}
	}
}
