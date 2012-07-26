package game.module.guild.vo {
	import game.core.item.config.ItemConfig;
	import game.core.item.config.ItemConfigManager;
	import game.net.data.StoC.SCListGuildTrend.Trend;

	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;

	import flash.utils.Dictionary;
	/**
	 * @author zhangzheng
	 */
	public class VoGuildTrend {
		
		public static var conf:Dictionary = new Dictionary() ;
		
		public var trendid:int ;
		public var stamp:int ;
		public var trendstr:String ;
		public var trendtype:int ;
		public var timestr:String ;
		
		
		public static function loadTrendConfig( xml:XML ):void{
			var vo:VoTrendConfig = new VoTrendConfig();
			vo.parse(xml);
			conf[vo.trendId] = vo ;
		}
		
		public function parse( data:Trend , source:Dictionary ):void
		{
			var tr : VoTrendConfig = conf[data.trendid] ;
			trendstr = tr.getTrendColorString( data.param ,source );
			timestr = getTimeStr(data.stamp);
			trendtype = tr.trendType ;
			trendid = data.trendid ;
			stamp = data.stamp ;
		}
		
		private function getTimeStr(unt : uint) : String
		{
			var thisDate : Date = new Date();
			var date : Date = new Date(thisDate.time - unt * 1000);
			if ((thisDate.fullYear == date.fullYear) && (thisDate.month == date.month) && (thisDate.date == date.date))
			{
				var mins : String = "";
				if (date.minutes > 9)
				{
					mins = String(date.minutes);
				}
				else
				{
					mins = "0" + date.minutes;
				}
				return "今日 " + date.hours + ":" + mins;
			}
			else
			{
				var day : int = 0;
				if (thisDate.month == date.month)
				{
					day = thisDate.date - date.date;
				}
				else
				{
					day = date.date - date.day + thisDate.day;
				}
				return day + " 天以前";
			}
		}
	}
}
