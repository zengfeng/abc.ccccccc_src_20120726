package game.module.vip.config
{
	/**
	 * @author ME
	 */
	public class VIPConfig
	{
		// ======================================================
		// 属性
		// ======================================================
		public var level : int;
		public var gold : int;
		public var friend:int;
		public var openNumbers : Array;
		public var items : Array;
		public var treasurePackages : Array;

		public function getItem(itemId : int) : VIPItem
		{
			for each (var item:VIPItem in items)
			{
				if (item.id == itemId)
					return item;
			}
			return null;
		}

		public function getOpenNumber(itemId : int) : int
		{
			var item : VIPItem;
			for (var i : int = items.length - 1; i >= 0; i--)
			{
				item = items[i];

				if (item.id == itemId)
				{
					return openNumbers[i];
				}
			}

			return 0;
		}
	}
}
