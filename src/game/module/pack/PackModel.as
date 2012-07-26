package game.module.pack
{
	import com.utils.ItemUtils;

	import flash.utils.Dictionary;

	import game.core.item.Item;
	import game.core.item.pile.PileItem;
	import game.core.user.UserData;

	/**
	 * @author jian
	 */
	public class PackModel
	{
		private var _pages : Array;
		private var _pageItems : Dictionary;

		public function PackModel()
		{
			initPages();
		}

		public function initPages() : void
		{
			_pages = [1, 2, 4, 8, 16, 32];
			_pageItems = new Dictionary();

			for each (var page:uint in _pages)
			{
				_pageItems[page] = [];
				/* of Item */
			}
		}

		// TODO: 对装备的处理有问题
		public function addItem(item : Item) : void
		{
			changePageItem(item.topType, item);
		}

		public function changeItem(item : Item) : void
		{
			changePageItem(item.topType, item);
		}

		public function removeItem(item : Item) : void
		{
			removePageItem(item.topType, item);
		}

		public function getPageItems(page : uint) : Array /* of Item */
		{
			return ItemUtils.splitPileArray(_pageItems[page]);
		}

		public function getMultiPageItems(pages : uint) : Array /* of Item */
		{
			var items : Array = [];
			for each (var topType:int in Item.TOP_TYPES)
			{
				if ((pages & topType) != 0)
					items = items.concat(ItemUtils.splitPileArray(_pageItems[topType]));
			}
			return items;
		}

		public function getPageItemsPile(page : uint) : Array /* of Item*/
		{
			return _pageItems[page];
		}

		public function changePageItem(page : uint, item : Item) : void
		{
			var newItems : Array = [];
			/* of Item */
			var oldItems : Array = _pageItems[page];

			for each (var oldItem:Item in oldItems)
			{
				if (oldItem.equals(item))
					continue;

				newItems.push(oldItem);
			}

			newItems.push(item);

			_pageItems[page] = newItems.sort(ItemUtils.sortItemFunc);

			updatePackCurrent();
		}

		public function removePageItem(page : uint, item : Item) : void
		{
			var newItems : Array = [];
			/* of Item */
			var oldItems : Array = _pageItems[page];

			for each (var oldItem:Item in oldItems)
			{
				if (oldItem.equals(item))
					continue;

				newItems.push(oldItem);
			}

			_pageItems[page] = newItems.sort(ItemUtils.sortItemFunc);

			updatePackCurrent();
		}

		private function updatePackCurrent() : void
		{
			var nums : uint = 0;
			for each (var arr:Array in _pageItems)
			{
				for each (var item:Item in arr)
				{
					if (item is PileItem)
						nums += Math.ceil(Number(item.nums) / item.config.stackLimit);
					else
						nums++;
				}
			}
			UserData.instance.packCurrent = nums;
		}
	}
}
