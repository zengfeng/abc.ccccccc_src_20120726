package game.core.avatar
{
	/**
	 * @author yangyiqiang
	 */
	public class AvatarUnit
	{
		public var key:int;
		public var avatars:Array=[];
		public var timer:uint=80;
        
        public function toString():String
        {
            return "AvatarUnit{key:"+ key +", timer:"+ timer +", avatars:"+ avatars +"}";
        }
	}
}
