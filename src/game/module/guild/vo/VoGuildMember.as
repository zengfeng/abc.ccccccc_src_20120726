package game.module.guild.vo
{
	import game.net.data.StoC.GuildMember;

	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;
	/**
	 * @author zhangzheng
	 */
	public class VoGuildMember {
		
		public static var posArray:Array = ["族员","副族长","族长"];
		public var id : int ;
		public var name : String ;
		public var level : int ;
		public var position : int ;
		public var rank:int ;
		public var devote:int ;
		public var latestonl:int ;
		public var potential:int ;
		public var isOnline:Boolean ;
		public var vote:Boolean ;			//vote ,self voted id ;
		public var ticket:int ;			//vote , tickets got in voting;
		public var candidature:Boolean ;
		
		public function positionStr():String 
		{
			return VoGuildMember.posArray[position];
		}
		
		public function parse( mem:GuildMember ):void
		{
			id = mem.id ;
			name = mem.name ;
			level = mem.level ;
			position = mem.position ;
			rank = mem.rank ;
			devote = mem.devote ;
			latestonl = (new Date()).time/1000 - mem.latestonl ;
			potential = mem.potential ;
			isOnline = mem.online ;
			vote = (mem.vote & 0x10000) != 0 ;
			candidature = (mem.vote & 0x20000 ) != 0 ;
			ticket = mem.vote & 0xFFFF ;
		}
		
		public function colorname():String{
			return StringUtils.addColor(name , PotentialColorUtils.getColorOfStr(potential));
		}
		
		public function linecolorname():String{
			return StringUtils.addLine( StringUtils.addColor(name , PotentialColorUtils.getColorOfStr(potential)));;
		}
		
		public function merge( mem:GuildMember ):void
		{
			
		}
	}
}
