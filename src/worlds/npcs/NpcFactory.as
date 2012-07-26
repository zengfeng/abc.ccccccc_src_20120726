package worlds.npcs
{
	import game.core.avatar.AvatarThumb;

	import worlds.apis.MNpc;
	import worlds.roles.NpcPool;
	import worlds.roles.animations.AvatarFactory;
	import worlds.roles.animations.SimpleAnimation;
	import worlds.roles.animations.SimpleAnimationPool;
	import worlds.roles.cores.Npc;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	 */
	public class NpcFactory
	{
		/** 单例对像 */
		private static var _instance : NpcFactory;

		/** 获取单例对像 */
		public static  function get instance() : NpcFactory
		{
			if (_instance == null)
			{
				_instance = new NpcFactory(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var npcPool : NpcPool;
		private var avatarFactory : AvatarFactory;
		private var simpleAnimationPool : SimpleAnimationPool;

		function NpcFactory(singleton : Singleton) : void
		{
			singleton;
			npcPool = NpcPool.instance;
			avatarFactory = AvatarFactory.instance;
			simpleAnimationPool = SimpleAnimationPool.instance;
		}

		public function make(npcId : int, isHit : Boolean, hasAvatar : Boolean, avatarId : int, name : String, colorStr : String) : Npc
		{
			var npc : Npc;
			 if (isHit == false)
			 {
				npc = makeNpc(npcId);
			}
			else
			{
				if (hasAvatar)
				{
					npc = makeMonster(npcId, avatarId, name, colorStr);
				}
				else
				{
					npc = makeHideMonster(npcId);
				}
			}
			return npc;
		}

		/** 创建正常NPC */
		public function makeNpc(npcId : int) : Npc
		{
			var role : Npc = npcPool.getObject();
			role.resetNpc(npcId);
			var avatar : AvatarThumb = avatarFactory.makeNpc(npcId);
			var animation : SimpleAnimation = simpleAnimationPool.getObject();
			animation.resetSimple(avatar);
			role.setAnimation(animation);
			role.addClickCall(onClickNpc);
			role.addToLayer();
			role.clickToType = 1;
			return role;
		}

		private function onClickNpc(role : Npc) : void
		{
			var npcId : int = role.id;
			trace("onClickNpc", npcId);
			MNpc.clickNpcCall(npcId);
		}

		/** 创建可见怪物 */
		public function makeMonster(npcId : int, avatarId : int, name : String, colorStr : String) : Npc
		{
			var role : Npc = npcPool.getObject();
			role.resetNpc(npcId);
			var avatar : AvatarThumb = avatarFactory.makeMonster(avatarId);
			avatar.setName(name, colorStr);
			var animation : SimpleAnimation = simpleAnimationPool.getObject();
			animation.resetSimple(avatar);
			role.setAnimation(animation);
			role.addToLayer();
			role.clickToType = 0;
			return role;
		}

		/** 创建隐藏怪物 */
		public function makeHideMonster(npcId : int) : Npc
		{
			var role : Npc = npcPool.getObject();
			role.resetNpc(npcId);
			return role;
		}
	}
}
class Singleton
{
}