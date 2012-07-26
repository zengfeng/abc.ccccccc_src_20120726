package game.module.guild.vo {
	import game.net.data.StoC.GuildReserves;

	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;
	/**
	 * @author zhangzheng
	 */
	public class VoGuildApply {
		
		public var id : int ;
		public var name : String ;
		public var level : int ;
		public var rank : int ;
		public var potential : int ;
		public var latestonl : int ;
		
		public function parse(pl : GuildReserves) : void {
			id = pl.id ;
			name = pl.name ;
			level = pl.level ;
			rank = pl.rank ;
			potential = pl.potential ;
			latestonl = pl.latestonl ;
		}
		
		public function colorname():String{
			return StringUtils.addColor(name , PotentialColorUtils.getColorOfStr(potential));
		}
		
		public function linecolorname():String{
			return StringUtils.addLine( StringUtils.addColor(name , PotentialColorUtils.getColorOfStr(potential)));;
		}
	}
}
