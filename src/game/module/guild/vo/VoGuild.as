package game.module.guild.vo {
	import game.net.data.StoC.GuildInfoPartA;
	import game.net.data.StoC.GuildInfoPartB;
	import game.net.data.StoC.GuildMember;
	import game.net.data.StoC.GuildInfo;
	import flash.utils.Dictionary;
	/**
	 * @author zhangzheng
	 */
	public class VoGuild {
		
		public static var guildexp : Array = new Array;
		
		public var id:int ;
		public var name:String ;
		private var _level:int ;
		private var _exp:int ;
		public var seq:int ;
		public var leaderId:int ;
		public var viceId:int ;
		public var announce:String ;
		public var intro:String ;
		public var leader:VoGuildMember ;
		public var vice:VoGuildMember ;
		public var isApply:Boolean ;	//view other guild only
		public var status:int ;

		public var actionstate:int ;
		public var actionconfig:int ;
		public var actionremain:int ;
		public var isComplete:Boolean = false;
		private var _membercnt:int ;
		
		
		public var memberList:Vector.<VoGuildMember> ;
		public var memberDict:Dictionary ;
		private var _candidature:Vector.<VoGuildMember> ;
		
		public static function loadGuildExp( arr:Array ):void{
			for each ( var obj:Object in arr )
			{
				var cfg : Object = new Object() ;
				cfg["level"] = uint(obj[0]);
				cfg["experience"] = uint(obj[1]);
				cfg["teabonous"] = uint(obj[3]);
				guildexp.push(cfg);
			}
		}
		
		public function parse( info:GuildInfo ):void
		{
			id = info.id ;
			name = info.name ;
			_exp = info.exp ;
			_level = glevel( info.exp );
			seq = info.seq ;
			leaderId = info.leader; 
			viceId = info.vice ;
			announce = info.announce ;
			intro = info.intro ;
			if( info.hasApply )
				isApply = info.apply ;
			if( info.hasAction )
				actionstate = info.action ;
			if( info.hasActionconfig )
				actionconfig = info.actionconfig ;
			if( info.hasActionremain )
				actionremain = info.actionremain ;
			status = info.status ;
				
			memberList = new Vector.<VoGuildMember>();
			memberDict = new Dictionary();
			for each( var mem:GuildMember in info.member )
			{
				var vom:VoGuildMember = new VoGuildMember() ;
				vom.parse(mem);
				memberList.push(vom);
				memberDict[vom.id] = vom ;
				if( vom.id == leaderId )
					leader = vom ;
				if( vom.id == viceId )
					vice = vom ;
			}
			
			isComplete = true ;
		}
		
		public function set exp(e:int):void{
			_exp = e ;
			glevel(e);
		}
		
		public function get exp():int{
			return _exp ;
		}
		
		public function get level():int{
			return _level ;
		}
		
		public function get levelexp():int{
			return _level < guildexp.length ? guildexp[ _level ].experience : 0 ;
		}
		
		public function get prelevelexp():int{
			return _level == 0 ? 0 : guildexp[level - 1].experience;
		}
		
		public function getMember( id:int ):VoGuildMember
		{
			return memberDict[id];
		}
		
		
		public function sortMember():void{
			memberList.sort(function( member1:VoGuildMember , member2:VoGuildMember ):Number
			{ 
				if( member1.isOnline != member2.isOnline )
					return member1.isOnline ? -1 : 1 ;
				if( member1.position != member2.position )
					return member2.position - member1.position ;
				return member2.devote - member1.devote ;});
		}
		
		private function glevel( exp:int ):int
		{
			var cur : uint = 0 ;
			for each ( var obj:Object in guildexp )
			{
				if ( obj["experience"] > exp )
				{
					_level = cur ;
					return cur ;
				}
				else
				{
					cur = obj["level"];
				}
			}
			_level = cur ;
			return cur ;
		}
		
		public function delmember(id:int):void{
			var vo:VoGuildMember = memberDict[id] as VoGuildMember ;
			if( vo != null )
			{
				delete memberDict[id] ;
				memberList.splice( memberList.indexOf(vo) , 1);
				if( _candidature != null && _candidature.indexOf(vo) >= 0 )
					_candidature.splice(memberList.indexOf(vo), 1);
				if(vo.position == 1){
					vice = null ;
					viceId = 0 ;
				}
			}
		}
		
		public function addmember(member:VoGuildMember):void{
			if( !memberDict.hasOwnProperty( member.id ) )
			{
				memberDict[member.id] = member ;
				memberList.push( member );
			}
		}

		public function buildA(gi : GuildInfoPartA) : void {
			id = gi.id ;
			name = gi.name ;
			seq = gi.rank ;
			exp = gi.exp ;
			_membercnt = gi.membercnt ;
			isApply = gi.isApply ;
			if( gi.hasLeader )
			{
				leaderId = gi.leader.id ;
				leader = new VoGuildMember() ;
				leader.parse(gi.leader);
			}
		}
		
		public function get membercnt():int{
			return memberList == null ? _membercnt : memberList.length ;
		}

		public function buildB(extinfo : GuildInfoPartB) : void {
			intro = extinfo.intro ;
			memberList = new Vector.<VoGuildMember>() ;
			memberDict = new Dictionary() ;
			for each( var vo:GuildMember in extinfo.member )
			{
				var mem:VoGuildMember = new VoGuildMember() ;
				mem.parse(vo);
				memberList.push(mem);
				memberDict[mem.id] = mem;
				if( mem.id == leaderId )
					leader = mem ;
			}
			isComplete = true ; 
		}
		
		public function get candidature():Vector.<VoGuildMember>{
			
			if( _candidature == null ){
				
				_candidature = new Vector.<VoGuildMember>() ;
				for each( var vo:VoGuildMember in memberList )
				{
					if( vo.candidature ){
						_candidature.push(vo);
					}
				}
			}
			return _candidature ;
		}
		
		public function get teabonous():uint{
			return _level == 0 ? 100 : guildexp[level - 1].teabonous;
		}
		
	}
}
