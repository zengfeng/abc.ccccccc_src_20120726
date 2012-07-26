package game.core.avatar {
	/**
	 * @author yangyiqiang
	 */
	public final class AvatarAction {
		public var action : int = 1;
		public var loop : int = 0;
		public var index : int = 0;
		public var arr : Array;

		public function AvatarAction(_action : int=1, _loop : int = 0, _index : int = -1, _arr : Array = null) {
			action = _action;
			loop = _loop;
			index = _index;
			arr = _arr;
		}

		public function reset(_action : int=1, _loop : int = 0, _index : int = -1, _arr : Array = null) : void {
			action = _action;
			loop = _loop;
			index = _index;
			arr = _arr;
		}
	}
}
