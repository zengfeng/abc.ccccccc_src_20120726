package game.module.gem.identify
{
	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import flash.events.Event;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.definition.UI;
	import gameui.cell.GCell;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import net.AssetData;





	/**
	 * @author jian
	 */
	public class AbstractorSubPanel extends GPanel
	{
		// =====================
		// @属性
		// =====================
		protected var _sourceGrid : ItemGrid;
		protected var _control : GemIdentifyControl;

		// =====================
		// @创建
		// =====================
		public function AbstractorSubPanel(control : GemIdentifyControl, sourceGrid : ItemGrid)
		{
			_control = control;
			_sourceGrid = sourceGrid;

			var data : GPanelData = new GPanelData();
			data.width = 258;
			data.height = 358;
			data.bgAsset = new AssetData(UI.AREA_BACKGROUND);

			super(data);
		}

		// =====================
		// @更新
		// =====================
		public function updateItemGrid() : void
		{
			var fItems : Array = getFilterItems();
			var unfiltered : Array = ItemManager.instance.packModel.getPageItems(Item.GEM);

			var filtered : Array = [];
			var match : Boolean;

			for each (var item:Item in unfiltered)
			{
				match = false;
				for each (var fItem:Item in fItems)
				{
					if (item.id == fItem.id && item.binding == fItem.binding)
					{
						fItems.splice(fItems.indexOf(item), 1);
						match = true;
						break;
					}
				}
				if (!match)
					filtered.push(item);
			}

			_sourceGrid.source = filtered;
		}

		protected function addUnidentifiedItem(item : Item) : void
		{
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			_sourceGrid.addEventListener(GCell.SELECT, sourceSelectHandler, true);
		}

		override protected function onHide() : void
		{
			super.onHide();
			_sourceGrid.removeEventListener(GCell.SELECT, sourceSelectHandler, true);
		}

		/*
		 * 添加原石
		 */
		private function sourceSelectHandler(event : Event) : void
		{
			var item : Item = ItemGridCell(event.target).source;
			addUnidentifiedItem(item);
		}

		// =====================
		// @其它
		// =====================
		protected function getFilterItems() : Array
		{
			return [];
		}
	}
}
