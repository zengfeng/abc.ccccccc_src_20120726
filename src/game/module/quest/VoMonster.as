package game.module.quest {
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarType;
	import game.manager.VersionManager;

	/**
	 * @author yangyiqiang
	 */
	public final class VoMonster extends VoBase {
		/**  headImg 头像 */
		private var counter : int = 0;
		public var skills:Array = [];

		public function parse(arr : Array) : void {
			if (!arr) return;
			id = arr[counter++];
			name = arr.length > counter ? arr[counter++] : "";
			headImg = arr.length > counter ? arr[counter++] : 0;
			avatarId = arr.length > counter ? arr[counter++] : 0;
			dugeonBoss = arr.length > counter ? arr[counter++] : 0;
			avatarId=avatarId<=0?id:avatarId;
			
		}
		
		public function IsDugeonBoss():Boolean
		{
			return dugeonBoss > 0;
		}

		public function get headImgUrl() : String {
			return VersionManager.instance.getUrl("assets/avatar/monster/halfBody/" + headImg + ".png");
		}
		
		override public function get avatarUrl() : String {
			return VersionManager.instance.getUrl("assets/avatar/" + AvatarManager.instance.getUUId(avatarId, AvatarType.MONSTER_TYPE) + ".swf");
		}
	}
}
