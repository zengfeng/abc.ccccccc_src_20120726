package game.module.quest {
	import game.manager.VersionManager;
	/**
	 * @author yangyiqiang
	 */
	public class VoNpcLink
	{
		public var id : int;

		public var type : int;

		public var messgage : String;

		public var link : String;
		
		private var _icoUrl:String;

		public function parse(xml:XML) : void
		{
			id = xml.@id;
			type = xml.@type;
			messgage =  xml.@messgage;;
			link =  xml.@link;
			_icoUrl=xml.@icoName;
		}
		
		public function get icoUrl():String
		{
			if(_icoUrl==null||_icoUrl=="")_icoUrl="action1";
			return VersionManager.instance.getUrl("assets/ico/daily/" + _icoUrl + ".png");
		}
	}
}
