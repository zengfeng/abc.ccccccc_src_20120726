package game.module.daily {
	import game.manager.DailyInfoManager;
	import game.manager.VersionManager;

	/**
	 * @author yangyiqiang
	 */
	public class VoAction
	{
		public var id : int = 0;

		public var name : String ;

		public var description : String ;

		private var ico : String;

		public function parse(xml : XML) : void
		{
			id = xml.@id;
			name = xml.@name;
			description = xml.children();
			ico = xml.@ico;
		}

		public function getName() : String
		{
			if (isToday)
				return "今日特定活动  " + name;
			else
				return DailyManage.WEEKDAY[id] + " " + name;
		}

		public function get isToday() : Boolean
		{
			return DailyInfoManager.instance.weekday == id;
		}

		public function getIcoUrl() : String
		{
			return VersionManager.instance.getUrl("assets/ico/daily/action" + id + ".png");
		}

		public function getBigIcoUrl() : String
		{
			return VersionManager.instance.getUrl("assets/ico/daily/actionB" + id + ".png");
		}
	}
}
