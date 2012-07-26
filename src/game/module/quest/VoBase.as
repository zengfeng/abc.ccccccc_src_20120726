package game.module.quest {
	import flash.events.EventDispatcher;

	import game.manager.VersionManager;

	/**
	 * @author yangyiqiang
	 */
	public class VoBase extends EventDispatcher {
		public var id : int;
		public var name : String;
		public var headImg : int;
		public var avatarId : int;
		public var dugeonBoss:int;     //是否副本boss

		public function get avatarUrl() : String {
			return "";
		}

		public function get helfIocUrl() : String {
			return headImg==0?null:VersionManager.instance.getUrl("assets/ico/halfBody/" + headImg + ".png");
		}
	}
}
