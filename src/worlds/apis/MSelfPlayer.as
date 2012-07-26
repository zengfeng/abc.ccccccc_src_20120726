package worlds.apis
{
	import worlds.players.GlobalPlayers;
	import game.core.user.UserData;

	import worlds.roles.cores.SelfPlayer;

	import game.core.avatar.AvatarMySelf;

	import worlds.auxiliarys.MapPoint;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.mediators.SelfMediator;
	import worlds.players.PlayerData;
	import worlds.roles.structs.PlayerStruct;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	*/
	public class MSelfPlayer
	{
		public static var sInstallComplete : MSignal = SelfMediator.sInstallComplete;
		public static var sWalkStart : MSignal = SelfMediator.sWalkStart;
		public static var sWalkEnd : MSignal = SelfMediator.sWalkEnd;
		public static var sTransport : MSignal = SelfMediator.sTransport;
		public static var sChangeCloth : MSignal = SelfMediator.sChangeCloth;
		public static var sChangeRide : MSignal = SelfMediator.sChangeRide;
		private static var _autoWalk:Boolean = false;
		public static function set autoWalk(value:Boolean):void
		{
			_autoWalk = value;
		}
		
		public static function get autoWalk():Boolean
		{
			return _autoWalk;
		}

		public static function get  id() : int
		{
			return UserData.instance.playerId;
		}

		public static function get struct() : PlayerStruct
		{
			return GlobalPlayers.instance.self;
		}

		public static function get avatar() : AvatarMySelf
		{
			return AvatarMySelf.instance;
		}

		public static function get player() : SelfPlayer
		{
			return SelfPlayer.instance;
		}

		public static function get position() : MapPoint
		{
			return SelfMediator.cbPosition.call();
		}

		public static function setClanName(name : String, color : String = "#00ee66") : void
		{
			avatar.setClanName(name, color);
		}
	}
}
