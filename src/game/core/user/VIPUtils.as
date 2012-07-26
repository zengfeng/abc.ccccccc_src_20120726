package game.core.user
{
	/**
	 * @author jian
	 */
	public class VIPUtils
	{
		public static function canTransport():Boolean
		{
			return UserData.instance.vipLevel > 0;
		}
	}
}
