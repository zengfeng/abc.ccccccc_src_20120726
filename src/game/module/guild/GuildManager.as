package game.module.guild {
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.module.chat.ManagerChat;
	import game.module.guild.vo.VoGuild;
	import game.module.guild.vo.VoGuildAction;
	import game.module.guild.vo.VoGuildApply;
	import game.module.guild.vo.VoGuildMember;
	import game.module.guild.vo.VoGuildTrend;
	import game.module.guild.vo.VoTrendConfig;
	import game.net.data.StoC.GuildInfo;
	import game.net.data.StoC.GuildInfoPartA;
	import game.net.data.StoC.GuildMember;
	import game.net.data.StoC.GuildReserves;
	import game.net.data.StoC.SCGuildInfoChange;
	import game.net.data.StoC.SCGuildMemberInfoChg;
	import game.net.data.StoC.SCGuildTrendMessage;
	import game.net.data.StoC.SCListGuildTrend;
	import game.net.data.StoC.SCListGuildTrend.Player;
	import game.net.data.StoC.SCListGuildTrend.Trend;
	import game.net.data.StoC.SCViewOtherGuild;

	import com.commUI.alert.Alert;
	import com.utils.PotentialColorUtils;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @author zhangzheng
	 */
	public class GuildManager extends EventDispatcher {
		
		private static var _instance:GuildManager ;
		
		private var _selfguild:VoGuild ;
		
		//家族列表
		private var _viewguild:VoGuild ;
		private var _guildList:Vector.<VoGuild> ;
		private var _guildlistbg:int ;
		private var _guildlisttotal:int ;
		//家族申请
		private var _applyList:Vector.<VoGuildApply> ;
		//家族活动
		private var _actiondata:Vector.<VoGuildAction> ;
		//家族动态
		private var _trendList:Vector.<VoGuildTrend> = new Vector.<VoGuildTrend>() ;
		private var _trendstamp:uint = 0 ;
		private var _trendlatid:uint = 0xFF ;
		
		public function GuildManager( single:Singleton , target : IEventDispatcher = null) {
			single ;
			super(target);
		}
		
		public static function get instance():GuildManager
		{
			if( _instance == null )
				_instance = new GuildManager(new Singleton());
			return _instance ;
		}
		
		public function initAction():void{
			if( _actiondata != null	)
				return ;
			_actiondata = new Vector.<VoGuildAction>() ;
			for( var i:int = 0 ; i < VoGuildAction.actioncfgarr.length ; ++ i )
			{
				var act:VoGuildAction = new VoGuildAction( i , _selfguild == null ? 1 : _selfguild.level);
				_actiondata.push(act);
			}
		}
		
//		public function loadActionConfig( arr:Array ):void{
//			
//			_actiondata = new Vector.<VoGuildAction>();
//			for each ( var obj:Object in arr )
//			{
//				var data : VoGuildAction = new VoGuildAction();
//				data.actId = obj[0];
//				data.title = obj[1];
//				data.reward = obj[2];
//				data.intro = obj[3];
//				data.openlvl = obj[4];
//				data.paneltype = obj[5]=="" ?data.actId : obj[5];
//				if( obj[10] != "" )
//				{
//					var strtime:Array = (obj[10] as String ).split(":");
//					var hour:int = int(strtime[0]) ;
//					var min:int = int(strtime[1]);
//					data.beginstamp = hour*3600000+min*60000 ;
//					data.begintime = obj[10];
//				}
//				data.shortcutmap = obj[11];
//				if( obj[12] != "" )
//				{
//					if(obj[12] == null)return;
//					var strpos:Array = (obj[12] as String ).split(",");
//					data.shortcutx = int(strpos[0]);
//					data.shortcuty = int(strpos[1]);
//				}
//				_actiondata.push(data);
//			}
//		}
		
		public function get guildlistbegin():int{
			return _guildlistbg ;
		}
		
		public function get guildlisttotal():int{
			return _guildlisttotal ;
		}
		
		public function get selfmember():VoGuildMember{
			return _selfguild == null ? null : _selfguild.getMember(UserData.instance.playerId);
		}
		
		public function get selfguild():VoGuild{
			return _selfguild ;
		}
		
		public function get viewguild():VoGuild{
			return _viewguild ;
		}
		
		public function get guildList():Vector.<VoGuild>{
			return _guildList ;
		}
		
		public function get applyList():Vector.<VoGuildApply>{
			return _applyList ;
		}
		
		public function get actiondata():Vector.<VoGuildAction>{
			return _actiondata ;
		}
		
		public function get trendList():Vector.<VoGuildTrend>{
			return _trendList ;
		}
		
		public function requestApplyList():void{
			
			if( _applyList == null ){
				GuildProxy.cs_listapply() ;
			}
			else{
				var evt:GuildEvent = new GuildEvent(GuildEvent.GUILD_APPLY_CHANGE);
				dispatchEvent(evt);
			}
		}
		
		public function requestTrendList():void{
			GuildProxy.cs_listtrend(_trendlatid , _trendstamp) ;
		}
		
		public function setSelfGuild(info : GuildInfo) : void {
			
			if( info != null ){
				_selfguild = new VoGuild() ;
				_selfguild.parse(info);
				_selfguild.sortMember();
				for each( var vo:VoGuildAction in _actiondata )
				{
					vo.update(_selfguild.level);
					vo.setState(_selfguild.actionstate);
					vo.setRemain(_selfguild.actionremain);
					vo.setConfig(_selfguild.actionconfig);
				}
				var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_ENTER );
				dispatchEvent(evt);
			}
		}

//		public function viewGuild(info : GuildInfo) : void {
//			if( info != null ){
//				_viewguild = new VoGuild() ;
//				_viewguild.parse(info);
//				var evt:GuildEvent = new GuildEvent( GuildEvent. );
//				dispatchEvent(evt);
//			}
//		}

		public function addApplyList(players : Vector.<GuildReserves> ) : void {
	
			_applyList = new Vector.<VoGuildApply>();
				
			for( var i : int = 0 ; i < players.length ; ++ i )
			{
				var vop:VoGuildApply = new VoGuildApply() ;
				vop.parse(players[i]);
				_applyList.push(vop) ;
			}
			
			var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_APPLY_CHANGE );
			dispatchEvent(evt);
		}

		public function removeGuildApply(player : uint) : void {
			for( var i:int = 0 ; i < _applyList.length ; ++ i )
			{
				if(_applyList[i].id == player){
					_applyList.splice(i, 1);
					break ;
				}
			}
			var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_APPLY_CHANGE );
			dispatchEvent(evt);
		}

		public function changeGuildInfo(msg : SCGuildInfoChange) : void {
			
			var basechg:Boolean = false ;
			var actchg:Boolean = false ;
			
			if( _selfguild != null )
			{
				if( msg.hasExp )
				{
					var prelvl:int = _selfguild.level ;
					_selfguild.exp = msg.exp ;
					if( _selfguild.level > prelvl ){
						// TO DO : 家族等级提升为XX 提示
						ManagerChat.instance.clanPrompt( _selfguild.name + "升到" + _selfguild.level.toString() + "级" );
					}
					basechg = true ;
				}
				
				if( msg.hasSeq )
				{
					_selfguild.seq = msg.seq ;
					basechg = true ;
				}
				
				if( msg.hasAnnounce )
				{
					_selfguild.announce = msg.announce ;
					basechg = true ;
				}
				
				if( msg.hasIntro )
				{
					_selfguild.intro = msg.intro ;
					basechg = true ;
				}

				if( msg.hasAction )
				{
					_selfguild.actionstate = msg.action ;
					for each ( var vo1:VoGuildAction  in _actiondata )
						vo1.setState(msg.action);
					actchg = true ;
				}
				
				if( msg.hasActionconfig )
				{
					_selfguild.actionconfig = msg.actionconfig ;
					for each ( var vo2:VoGuildAction in _actiondata )
						vo2.setConfig(msg.actionconfig);
					if( _actiondata[2].state < 2 )
						ManagerChat.instance.clanPrompt("本周家族寻宝将于周"+GuildUtils.WEEKDAY[_actiondata[2].config&7]+"18:30开启");
					else 
						ManagerChat.instance.clanPrompt("下周家族寻宝将于周"+GuildUtils.WEEKDAY[_actiondata[2].config>>3]+"18:30开启");
					actchg = true ;
				}
				if( msg.hasActionremain )
				{
					_selfguild.actionremain = msg.actionremain ;
					for each ( var vo3:VoGuildAction in _actiondata )
						vo3.setRemain(msg.actionremain);
					actchg = true ;
				}
				if( msg.hasStatus )
				{
					_selfguild.status = msg.status ;
					basechg = true ;
				}
				
				var evt:GuildEvent ;
				if( basechg ){
					evt = new GuildEvent(GuildEvent.GUILD_BASE_CHANGE);
					dispatchEvent(evt);
				}
				if( actchg ){
					evt = new GuildEvent( GuildEvent.GUILD_ACTION_CHANGE );
					dispatchEvent(evt);
				}
			}
			
		}

		public function changeMemberInfo(msg : SCGuildMemberInfoChg) : void {
			
			if( _selfguild == null )
				return ;
			var vo:VoGuildMember = _selfguild.getMember(msg.id);
			if( vo == null )
				return ;
			if( msg.hasLevel )
				vo.level = msg.level ;
			if( msg.hasRank )
				vo.rank = msg.rank ;
			if( msg.hasDevote )	
				vo.devote = msg.devote ;	
			if( msg.hasLatestonl )
				vo.latestonl = (new Date()).time / 1000 - msg.latestonl ;
			if( msg.hasPotential )
				vo.potential = msg.potential ;
			if( msg.hasOnline )
				vo.isOnline = msg.online;
			if( msg.hasVote )
			{
				vo.vote = (msg.vote & 0x10000) != 0;
				vo.candidature = (msg.vote & 0x20000) != 0 ;
				vo.ticket = msg.vote & 0xFFFF ;
			}
			var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_MEMBER_INFO_CHANGE );
			evt.param = vo.id ;
			dispatchEvent(evt);
			if( msg.hasDevote || msg.hasOnline )
			{
				_selfguild.sortMember();
				evt = new GuildEvent(GuildEvent.GUILD_MEMBER_LIST_CHANGE);
				dispatchEvent(evt);
			}
		}

		public function onVote(voter : uint, voted : uint) : void {
			
			if( _selfguild == null )
				return ;
			var vo1:VoGuildMember = _selfguild.getMember(voter);
			var vo2:VoGuildMember = _selfguild.getMember(voted);
			if( vo2 != null )
				++ vo2.ticket ;
			if( vo1 != null )
				vo1.vote = true ;
			var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_VOTE_CHANGE );
			dispatchEvent(evt);
		}

		public function leaveGuild() : void {
			_selfguild = null ;
			_applyList = null ;
			_trendList = new Vector.<VoGuildTrend>();
			_trendstamp = 0 ;
			var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_LEAVE );
			dispatchEvent(evt);
		}

		public function memberLeave(id : uint) : void {
			if( _selfguild == null )
			{
				return ;
			}
			_selfguild.delmember(id) ;
			var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_MEMBER_LIST_CHANGE );
			dispatchEvent(evt);
		}

		public function memberEnter(member : GuildMember) : void {
			if( _selfguild == null )
			{
				return ;
			}
			var mem:VoGuildMember = new VoGuildMember() ;
			mem.parse(member) ;
			_selfguild.addmember(mem);
			_selfguild.sortMember() ;
			
			StateManager.instance.checkMsg(141,[mem.colorname()]);
			
			var evt:GuildEvent ;
			if( _applyList != null ){
				for ( var i:int = 0 ; i < _applyList.length ; ++ i )
				{
					if( _applyList[i].id == mem.id )
					{
						_applyList.splice(i, 1);
						break  ;
					}
				}
				evt = new GuildEvent( GuildEvent.GUILD_APPLY_CHANGE );
				dispatchEvent(evt);
				
			}
				
			evt = new GuildEvent( GuildEvent.GUILD_MEMBER_LIST_CHANGE );
			dispatchEvent(evt);
		}

		public function setGuildRequest(guild : uint) : void {
			
			for each( var vo:VoGuild in _guildList )
			{
				if( vo.id == guild )
				{
					vo.isApply = true ;
					break ;
				}
			}
			var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_LIST_CHANGE );
			evt.param = guild ;
			dispatchEvent(evt);
		}

		public function listGuild(guild : Vector.<GuildInfoPartA> , count : int , begin : int) : void {
			_guildList = new Vector.<VoGuild>() ;
			for each( var gi:GuildInfoPartA in guild )
			{
				var vo:VoGuild = new VoGuild();
				vo.buildA(gi);
				_guildList.push(vo);
			}
			_guildlisttotal = count ;
			_guildlistbg = begin ;
			var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_LIST );
			dispatchEvent(evt);
		}

		public function changePosition(id : uint, pos : uint) : void {
			
			if( _selfguild == null )
				return ;
			var vo:VoGuildMember = _selfguild.getMember(id);
			
			var selfpospre:int = selfmember.position ;
			
			if( vo.position == 1 )
			{
				_selfguild.vice = null ;
				_selfguild.viceId = 0 ;
			}
			if( vo.position == 2 )
			{
				_selfguild.leader = null ;
				_selfguild.leaderId = 0 ;
			}
			
			if( pos == 2 )
			{
				if( _selfguild.leader != null )
				{
					_selfguild.leader.position = 0 ;
					_selfguild.leader = null ;
					_selfguild.leaderId = 0 ;
				}
			}
			
			if( pos == 1 )
			{
				if( _selfguild.vice != null )
				{
					_selfguild.vice.position = 0 ;
					_selfguild.vice = null ;
					_selfguild.viceId = 0 ;
				}
			}
			
			vo.position = pos ;
			if( vo.position == 1 )
			{
				_selfguild.vice = vo ;
				_selfguild.viceId = vo.id; 
			}
			else if( vo.position == 2 )
			{
				_selfguild.leader = vo ;
				_selfguild.leaderId = vo.id ;
			}
			
			var evt:GuildEvent ;
			evt = new GuildEvent( GuildEvent.GUILD_BASE_CHANGE );
			dispatchEvent(evt);
			evt = new GuildEvent( GuildEvent.GUILD_MEMBER_LIST_CHANGE );
			dispatchEvent(evt);
			if( selfpospre != selfmember.position )
			{
				evt = new GuildEvent(GuildEvent.SELF_POSITION_CHANGE);
				dispatchEvent(evt);
			}

		}

		public function addGuildApply(request : GuildReserves) : void {
			if( _applyList != null )
			{
				var apply:VoGuildApply = new VoGuildApply() ;
				apply.parse(request);
				_applyList.push(apply);
				var evt:GuildEvent = new GuildEvent( GuildEvent.GUILD_APPLY_CHANGE );
				dispatchEvent(evt);
				
			}
		}

		public function addTrends(msg : SCListGuildTrend) : void {
			_trendstamp = msg.stamp ;
			_trendlatid = msg.latid ;
			var templist:Vector.<VoGuildTrend> = new Vector.<VoGuildTrend>();
			var tempplayer:Dictionary = new Dictionary() ;
			var obj:Object ;
			for each( var mem:VoGuildMember in _selfguild.memberList )
			{
				obj = new Object();
				obj["name"] = mem.name ;
				obj["potential"] = mem.potential ;
				tempplayer[mem.id] = obj ;
			}
			for each( var pl:Player in msg.player )
			{
				obj = new Object() ;
				obj["name"] = pl.name ;
				obj["potential"] = pl.potential ;
				tempplayer[pl.id] = obj ;
			}
			
			for each( var tr:Trend in msg.trend )
			{
				var vo:VoGuildTrend = new VoGuildTrend() ;
				vo.parse( tr ,tempplayer);
				templist.push(vo);
			}
			_trendList = templist.concat(_trendList);
			if( _trendList.length > 60 )
				_trendList.splice(60, _trendList.length - 60 );
			
			var evt:Event = new GuildEvent(GuildEvent.GUILD_TREND_CHANGE) ;
			dispatchEvent(evt);
		}
		
		public function getFilteredTrends( hr:Boolean , offer:Boolean ):Vector.<VoGuildTrend>
		{
			var result:Vector.<VoGuildTrend> = new Vector.<VoGuildTrend>();
			for each( var vo:VoGuildTrend in _trendList )
			{
				if ( vo.trendtype == VoTrendConfig.TREND_HR && hr )
				{
					result.push(vo);
				}
				else if ( vo.trendtype == VoTrendConfig.TREND_XP && offer )
				{
					result.push(vo);
				}
			}
			return result ;
		}

		public function refreshRemain():void
		{
			var pr:int = UserData.instance.status & 0xFF ;
			for( var i:int = 0 ; i < _actiondata.length ; ++ i )
			{
				actiondata[i].setPersonalRemain(pr) ;
			}
			var evt:Event = new GuildEvent(GuildEvent.GUILD_ACTION_CHANGE);
			dispatchEvent(evt);
		}

		public function actionEnable(i : int) : Boolean {
			if( i < _actiondata.length )
				return _selfguild != null && _selfguild.level >= actiondata[i].openlvl && actiondata[i].personalremain > 0 ;
			return false;
		}
		
		public function checkActionOpen( i:int ):Boolean {
			return _selfguild != null && _selfguild.level >= actiondata[i].openlvl ;
		}
		
		public function checkActionRemain( i:int ):Boolean {
			return actiondata[i].personalremain > 0 ;
		}

		public function showTrendMessage(msg : SCGuildTrendMessage) : void {
			
			var cfg:VoTrendConfig = VoGuildTrend.conf[msg.trid] ;
			var dict:Dictionary = new Dictionary();
			if( cfg != null )
			{
				for each( var id:uint in msg.param )
				{
					var pl:VoGuildMember = _selfguild.memberDict[id];
					if( pl != null )
					{
						var obj:Object = new Object();
						obj["name"] = pl.name ;
						obj["potential"] = pl.potential;
						dict[pl.id] = obj ;
					}
				}
				
				ManagerChat.instance.clanPrompt( cfg.getTrendString(msg.param,dict) );
			}
		}

		public function viewOtherGuild(msg : SCViewOtherGuild) : void {
			for each ( var vo:VoGuild in _guildList )
			{
				if( vo.id == msg.extinfo.id )
				{
					vo.buildB( msg.extinfo );
					var evt:GuildEvent = new GuildEvent(GuildEvent.VIEW_GUILD_BUILD);
					dispatchEvent(evt);
					break ;
				}
			}
		}
		
		private var __idtemp:int ;
		private var __postemp:int ;
		
		public function setMemberPosition( id:uint , pos : int ):void{
			
			var mem:VoGuildMember = _selfguild == null ? null :_selfguild.memberDict[id];
			if( mem == null )
				return ;
			if( pos == 2 ){
				__idtemp = id ;
				__postemp = pos ;
				StateManager.instance.checkMsg(241,[mem.colorname()],onConfirmMemberPosition);
			}else if( pos == 1 ) {
				if( _selfguild.vice != null ){
					__idtemp = id ;
					__postemp = pos ;
					StateManager.instance.checkMsg(240,[mem.colorname(),_selfguild.vice.colorname()],onConfirmMemberPosition);
				}
				else 
					GuildProxy.cs_memberpostion(id, pos);
			}else {
				GuildProxy.cs_memberpostion(id, pos);
			}
		}
		
		private function onConfirmMemberPosition(type:String):Boolean
		{
			if( type == Alert.OK_EVENT ){
				GuildProxy.cs_memberpostion(__idtemp,__postemp);
				__idtemp = 0 ;
				__postemp = 0 ;
			}
			return true ;
		}

		public function removeGuildMember(playerId : uint) : void {
			var mem:VoGuildMember = _selfguild == null ? null :_selfguild.memberDict[playerId];
			if( mem == null )
				return ;
			StateManager.instance.checkMsg(242,[mem.name],onConfirmRemove,[PotentialColorUtils.getColorLevel(mem.potential)]);
			__idtemp = playerId ;
		}

		private function onConfirmRemove(type:String):Boolean
		{
			if( type == Alert.OK_EVENT ){
				GuildProxy.cs_guildremove(__idtemp);
				__idtemp = 0 ;
				__postemp = 0 ;
			}
			return true ;
		}

		public function sendIntroChange(intro : String, announce : String) : void {
			if( _selfguild == null || selfmember == null || selfmember.position == 0 )
				return ;
			if( intro != _selfguild.intro ){
				GuildProxy.cs_guildintro(intro);
			}
			if( announce != _selfguild.announce ){
				GuildProxy.cs_guildannounce(announce);
			}
		}
	}
}
class Singleton{
}