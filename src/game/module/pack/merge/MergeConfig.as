package game.module.pack.merge
{
	/**
	 * @author jian
	 */
	public class MergeConfig
	{
		// 材料物品ID
		public var sourceId : int;
		// 合成物品ID
		public var targetId : int;
		// 材料物品数量
		public var count : int;
//		// 需要货币ID
//		public var moneyId : int;
		// 需要货币数量
		public var moneyCount : int;
		
		public function parse(arr:Array):void
		{
			targetId = arr[1];
			sourceId = arr[3];
			count = arr[4];
			moneyCount = arr[5];
		}
	}
}
