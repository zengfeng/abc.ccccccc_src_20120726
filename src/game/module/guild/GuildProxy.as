package game.module.guild {
	import worlds.apis.MTo;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.net.core.Common;
	import game.net.data.CtoS.CSDisbandGuild;
	import game.net.data.CtoS.CSEnterGuildCity;
	import game.net.data.CtoS.CSGuildAnnounce;
	import game.net.data.CtoS.CSGuildIntroduce;
	import game.net.data.CtoS.CSGuildInvite;
	import game.net.data.CtoS.CSGuildList;
	import game.net.data.CtoS.CSGuildPass;
	import game.net.data.CtoS.CSGuildQuite;
	import game.net.data.CtoS.CSGuildRemove;
	import game.net.data.CtoS.CSGuildRequest;
	import game.net.data.CtoS.CSGuildVote;
	import game.net.data.CtoS.CSListGuildRequest;
	import game.net.data.CtoS.CSListGuildTrend;
	import game.net.data.CtoS.CSMemberPosition;
	import game.net.data.CtoS.CSViewGuild;
	import game.net.data.StoC.SCDisbandGuild;
	import game.net.data.StoC.SCGuildApplyNotExist;
	import game.net.data.StoC.SCGuildInfoChange;
	import game.net.data.StoC.SCGuildList;
	import game.net.data.StoC.SCGuildMemberInfoChg;
	import game.net.data.StoC.SCGuildPass;
	import game.net.data.StoC.SCGuildQuite;
	import game.net.data.StoC.SCGuildReject;
	import game.net.data.StoC.SCGuildRequest;
	import game.net.data.StoC.SCGuildRequestG;
	import game.net.data.StoC.SCGuildTrendMessage;
	import game.net.data.StoC.SCGuildVote;
	import game.net.data.StoC.SCListGuildRequest;
	import game.net.data.StoC.SCListGuildTrend;
	import game.net.data.StoC.SCMemberPosition;
	import game.net.data.StoC.SCSelfGuildInfo;
	import game.net.data.StoC.SCViewOtherGuild;
	/**
	 * @author zhangzheng
	 */
	public class GuildProxy {
		
		private static var _guildManager : GuildManager ;
		
		public static function stoc():void
		{
			Common.game_server.addCallback(0x2C0, onGuildRequest_Guild);
			Common.game_server.addCallback(0x2C1, onDisbandGuild );
			Common.game_server.addCallback(0x2C2, onChangePosition );
			Common.game_server.addCallback(0x2C3, onGuildList );
			Common.game_server.addCallback(0x2C4, onGuildRequest_Self );
			Common.game_server.addCallback(0x2C5, onGuildPass );
			Common.game_server.addCallback(0x2C6, onGuildQuite );
			Common.game_server.addCallback(0x2C7, onGuildVote );
			Common.game_server.addCallback(0x2C8, onViewOtherGuild );
//			Common.game_server.addCallback(0x2C8, onGuildInvite );
			Common.game_server.addCallback(0x2C9, onGuildInfoChange );
			Common.game_server.addCallback(0x2CA, onMemberInfoChange);
			Common.game_server.addCallback(0x2CB, onApplyNotExist );
			Common.game_server.addCallback(0x2CC, onApplyList );
			Common.game_server.addCallback(0x2CD, onApplyReject );
			Common.game_server.addCallback(0x2CE, onGuildInfo );
			Common.game_server.addCallback(0x2CF, onGuildTrendMessage );
			Common.game_server.addCallback(0x2F0, onListTrend );
		}

		private static function onViewOtherGuild( msg:SCViewOtherGuild ) : void {
			_guildManager.viewOtherGuild( msg );
		}

		private static function onGuildTrendMessage( msg:SCGuildTrendMessage ) : void {
			_guildManager.showTrendMessage( msg );
		}

		private static function onListTrend( msg:SCListGuildTrend ) : void {
			_guildManager.addTrends( msg );
		}
		
		private static function onApplyReject( msg:SCGuildReject ) : void {
			_guildManager.removeGuildApply(msg.player);
		}

		public static function get manager():GuildManager {
			if( _guildManager == null )
				_guildManager = GuildManager.instance ;
			return _guildManager ;
		}

		private static function onGuildInfo( msg:SCSelfGuildInfo ) : void {
			
//			if( msg.info.cause != 1 )
			manager.setSelfGuild( msg.info );
//			else 
//				manager.viewGuild( msg.info );
		}

		private static function onApplyList( msg:SCListGuildRequest ) : void {
			
			manager.addApplyList( msg.players);
		}

		private static function onApplyNotExist( msg:SCGuildApplyNotExist ) : void {
			
			StateManager.instance.checkMsg(143);
			manager.removeGuildApply(msg.player);
		}

		private static function onGuildInfoChange( msg:SCGuildInfoChange ) : void {
			manager.changeGuildInfo( msg );
		}

		private static function onMemberInfoChange( msg:SCGuildMemberInfoChg ) : void {
			manager.changeMemberInfo(msg);
		}

//		private static function onGuildInvite( msg:SCGuildInvite ) : void {
//		}

		private static function onGuildVote( msg:SCGuildVote ) : void {
			manager.onVote(msg.voter , msg.voted );
		}

		private static function onGuildQuite( msg:SCGuildQuite ) : void {
			if( msg.id == UserData.instance.playerId )
				manager.leaveGuild();
			else 
				manager.memberLeave(msg.id);
		}

		private static function onGuildPass( msg:SCGuildPass ) : void {
			
			manager.memberEnter( msg.member );
		}

		private static function onGuildRequest_Self( msg:SCGuildRequest ) : void {
			manager.setGuildRequest( msg.guild );
		}

		private static function onGuildList( msg:SCGuildList ) : void {
			//ToDo  报错
			manager.listGuild(msg.guild , msg.count , msg.begin );
		}

		private static function onChangePosition( msg:SCMemberPosition ) : void {
			manager.changePosition( msg.id, msg.pos );
		}

		private static function onDisbandGuild( msg:SCDisbandGuild ) : void {
			msg; 
			manager.leaveGuild() ;
		}
		
		private static function onGuildRequest_Guild( msg:SCGuildRequestG ):void{
			manager.addGuildApply(msg.request) ;
		}

		public static function cs_guildpass(id : int, pass : Boolean) : void {
			var msg:CSGuildPass = new CSGuildPass() ;
			msg.player = id ;
			msg.pass = pass ;
			Common.game_server.sendMessage(0x2c5,msg);
		}
		
		public static function cs_guildintro( intro:String ):void{
			var msg:CSGuildIntroduce = new CSGuildIntroduce() ;
			msg.intro = intro ;
			Common.game_server.sendMessage(0x2CA, msg);
		}

		public static function cs_guildrequest(id : int) : void {
			var msg:CSGuildRequest = new CSGuildRequest() ;
			msg.guild = id ;
			Common.game_server.sendMessage(0x2C4, msg);
		}

		public static function cs_listapply() : void {
			var msg:CSListGuildRequest = new CSListGuildRequest();
			Common.game_server.sendMessage(0x2CC,msg);
		}

		public static function cs_guildvote(id : int) : void {
			var msg:CSGuildVote = new CSGuildVote();
			msg.voted = id ;
			Common.game_server.sendMessage(0x2C7,msg);
		}

		public static function cs_enterguildcity() : void {
//			var msg:CSEnterGuildCity = new CSEnterGuildCity() ;
//			Common.game_server.sendMessage(0x2FE,msg);
			MTo.transportTo(1, 0, 0, 30);
		}

		public static function cs_guildannounce(text : String) : void {
			var msg:CSGuildAnnounce = new CSGuildAnnounce() ;
			msg.announce = text ;
			Common.game_server.sendMessage(0x2C9,msg);
		}

		public static function cs_guilddisband() : void {
			var msg:CSDisbandGuild = new CSDisbandGuild() ;
			Common.game_server.sendMessage(0x2C1,msg);
		}

		public static function cs_guildleave() : void {
			var msg:CSGuildQuite = new CSGuildQuite() ;
			Common.game_server.sendMessage(0x2C6,msg);
		}

		public static function cs_listtrend( trendid:uint , trendstamp : uint) : void {
			var msg:CSListGuildTrend = new CSListGuildTrend() ;
			msg.latid = trendid ;
			msg.stamp = trendstamp ;
			Common.game_server.sendMessage(0x2F0, msg);
		}
		
		public static function cs_memberpostion( id:int , position:int ):void{
			var msg:CSMemberPosition = new CSMemberPosition() ;
			msg.id = id ;
			msg.pos = position ;
			Common.game_server.sendMessage(0x2C2, msg);
		}
		
		public static function cs_guildinvite( id:int = 0 , name:String = null ):void
		{
			if( GuildManager.instance.selfguild == null ){
				return ;
			}
			var msg:CSGuildInvite = new CSGuildInvite() ;
			if( id != 0 )
				msg.id = id ;
			else 
				msg.name = name ;
			Common.game_server.sendMessage(0x2C8,msg);
		}
		
		public static function cs_guildremove( id:int ):void
		{
			var msg:CSGuildRemove = new CSGuildRemove() ;
			msg.playerid = id ;
			Common.game_server.sendMessage(0x2CD,msg);
		}
		
		public static function cs_listguild( begin:int , count:int ):void{
			var msg:CSGuildList = new CSGuildList() ;
			msg.begin = begin ;
			msg.count = count ;
			Common.game_server.sendMessage(0x2C3,msg);
		}

		public static function cs_viewGuild(id : int) : void {
			var msg:CSViewGuild = new CSViewGuild();
			msg.guild = id ;
			Common.game_server.sendMessage(0x2CB,msg);
		}
	}
}
