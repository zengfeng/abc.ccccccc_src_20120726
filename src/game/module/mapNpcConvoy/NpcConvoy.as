package game.module.mapNpcConvoy
{
	import worlds.auxiliarys.MapMath;

	import game.core.avatar.AvatarNpc;
	import game.manager.RSSManager;
	import game.module.quest.VoNpc;

	import worlds.apis.MAvatarFactory;
	import worlds.apis.MFactory;
	import worlds.apis.MNpc;
	import worlds.apis.MSelfPlayer;
	import worlds.apis.MapUtil;
	import worlds.roles.animations.SimpleAnimation;
	import worlds.roles.cores.Role;
	import worlds.roles.structs.NpcStruct;

	import flash.utils.Dictionary;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-25
	// Npc护送
	// ============================
	public class NpcConvoy
	{
		/** 单例对像 */
		private static var _instance : NpcConvoy;

		/** 获取单例对像 */
		static public function get instance() : NpcConvoy
		{
			if (_instance == null)
			{
				_instance = new NpcConvoy(new Singleton());
			}
			return _instance;
		}

		function NpcConvoy(singleton : Singleton) : void
		{
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var dic : Dictionary = new Dictionary();

		private function addNpc(npcId : int) : void
		{
			var role : Role = dic[npcId];
			if (role == null)
			{
				role = makNpc(npcId);
				if (role == null) return;
			}
			role.follow(MSelfPlayer.player);
			dic[npcId] = role;
		}

		private function removeNpc(npcId : int) : void
		{
			var role : Role = dic[npcId];
			if (role == null) return;
			role.cancelFollow();
			role.destory();
			delete dic[npcId];
		}

		private function makNpc(npcId : int) : Role
		{
			var struct : NpcStruct = MNpc.getStruct(npcId);
			var avatarId : int ;
			var name : String ;
			var colorStr : String ;
			var speed : int ;
			var x : int ;
			var y : int ;
			if (struct)
			{
				avatarId = struct.avatarId;
				name = struct.name;
				colorStr = struct.colorStr;
				speed = struct.speed;
				x = struct.x;
				y = struct.y;
			}
			else
			{
				var voNpc : VoNpc = RSSManager.getInstance().getNpcById(npcId);
				if (voNpc == null) return null;
				avatarId = voNpc.avatarId;
				name = voNpc.name;
				colorStr = "0xFF7E00";
				speed = 4;
				x = 0;
				y = 0;
			}
			x = MSelfPlayer.position.x + MapMath.randomInt(120, 70) * MapMath.randomPlusMinus(1);
			y = MSelfPlayer.position.y + MapMath.randomInt(120, 70) * MapMath.randomPlusMinus(1);
			var role : Role = MFactory.makeRole();
			var avatar : AvatarNpc = MAvatarFactory.makeNpc(npcId);
			avatar.setName(name, colorStr);
			var animation : SimpleAnimation = MFactory.makeSimpleAnimation();
			animation.resetSimple(avatar);
			role.resetRole(npcId);
			role.setAnimation(animation);
			if (MapUtil.hasMask) role.setNeedMask(MapUtil.hasMask);
			role.initPosition(x, y, speed);
			role.addToLayer();
			return role;
		}

		// =====================
		// 静态方法
		// =====================
		public static function addNpc(npcId : int) : void
		{
			instance.addNpc(npcId);
		}

		public static function removeNpc(npcId : int) : void
		{
			instance.removeNpc(npcId);
		}
	}
}
class Singleton
{
}