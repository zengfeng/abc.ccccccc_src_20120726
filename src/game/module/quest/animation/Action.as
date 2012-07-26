package game.module.quest.animation {
	import game.config.StaticConfig;
	import game.core.user.UserData;
	import game.manager.RSSManager;
	import game.module.quest.VoNpc;

	/**
	 * @author yangyiqiang
	 */
	public class Action {
		public var id : int;
		/*
		 * 1:对话
		2:人物状态切换
		3:战斗
		4:人物冒光（身上加程序效果）
		5:屏幕抖动
		6:黑屏之后文字
		7:压黑底显示文字（有确定）
		8:2个模型绑定 describe里，若target在上层，则填0,ID 若target在下层，则填1,ID describe里填 0，33【NPCid】，x，y【X,Y为相对坐标】
		9:烟雾逃遁
		10:移动
		 */
		public var type : int;
		/* 
		 * 描述 如果是对话，则为对话内容
		 * [x,y] 移动到指定点
		 */
		public var describe : String;
		/** direction  1:左边 2：右边 */
		public var direction : int = 1;
		/* 执行者 */
		public var targets : Array = [];
		public var target : int;
		public var completeType : Number = 0;

		public function parse(xml : XML) : void {
			id = xml.@id;
			type = xml.@type;
			describe = xml.@describe;
			targets = String(xml.@target).split("|");
			target = targets[0];
			completeType = xml.@completeType;
			direction = xml.@direction;
		}

		private var _vo : VoNpc;

		public function get helfUrl() : String {
			// 4007自己的影子
			if (target == 0 || target == 4007) {
				return StaticConfig.cdnRoot + "assets/avatar/halfBody/" + UserData.instance.myHero.id + ".png";
			}
			_vo = RSSManager.getInstance().getNpcById(target);
			if (!_vo||_vo.halfId==0) return null;
			return StaticConfig.cdnRoot + "assets/avatar/halfBody/" + _vo.halfId + ".png";
		}

		public function get targetName() : String {
			if (target == 0) {
				return UserData.instance.playerName;
			}
			if (!_vo) _vo = RSSManager.getInstance().getNpcById(target);
			if (!_vo) return "";
			return _vo.name;
		}
	}
}
