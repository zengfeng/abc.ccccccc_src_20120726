package game.module.quest.animation {
	/**
	 * @author yangyiqiang
	 */
	public class Performer {
		public var id : int;
		public var x : int;
		public var y : int;
		public var state : int;

		public function Performer(arr : Array) {
			if (!arr || arr.length < 4) return;
			id = arr[0];
			x = arr[1];
			y = arr[2];
			state = arr[3];
		}

		public function toXml() : String {
			return id + "," + x + "," + y + "," + state;
		}
	}
}
