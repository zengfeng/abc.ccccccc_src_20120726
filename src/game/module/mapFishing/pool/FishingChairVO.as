package game.module.mapFishing.pool
{
	/**
	 * @author jian
	 */
	public class FishingChairVO
	{
		// =====================
		public var id : uint;
		public var x : int;
		public var y : int;
		public var position : uint;
		public var players:Array = [];
		public var usage: String;


		// =====================
		public function clone() : FishingChairVO
		{
			var vo : FishingChairVO = new FishingChairVO();
			vo.id = id;
			vo.x = x;
			vo.y = y;
			vo.position = position;

			return vo;
		}
	}
}
