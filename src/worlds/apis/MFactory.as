package worlds.apis
{
	import worlds.roles.RoleFactory;
	import worlds.roles.animations.SimpleAnimationPool;
	import worlds.roles.animations.SimpleAnimation;
	import worlds.roles.RolePool;
	import worlds.roles.cores.Role;
	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-25
	 */
	public class MFactory
	{
		public static function makeRole() : Role
		{
			return RolePool.instance.getObject();
		}

		public static function makeSimpleAnimation() : SimpleAnimation
		{
			return SimpleAnimationPool.instance.getObject();
		}

		public static function makeTurtle(quality : int, playerId : int, playerName : String, playerColorStr : String, name : String, colorStr : String) : Role
		{
			return RoleFactory.instance.makeTurtle(quality, playerId, playerName, playerColorStr, name, colorStr);
		}
	}
}
