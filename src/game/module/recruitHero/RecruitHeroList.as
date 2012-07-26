package game.module.recruitHero
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import game.core.hero.VoHero;
	import game.definition.UI;
	import gameui.cell.GCell;
	import gameui.containers.GPanel;
	import gameui.data.GGirdData;
	import net.AssetData;




	/**
	 * @author 1
	 */
	public class RecruitHeroList extends GPanel
	{
		// =====================
		// 属性
		// =====================
		private var _cells : Array;

		// =====================
		// Setter/Getter
		// =====================
		override public function set source(value : *) : void
		{
			_source = value;

			initCells();
			updateCells();
		}

		public function get heroes() : Array
		{
			if (!_source)
				return [];
			else
				return _source as Array;
		}

		public function get thisdata() : GGirdData
		{
			return _data as GGirdData;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function RecruitHeroList()
		{
			var data : GGirdData = new GGirdData();
			data.width = 405;
			data.height = 375;
			data.columns = 3;
			data.rows = 2;
			data.bgAsset = new AssetData(UI.CENTS_RECRUIT_PANEL_BG);
			data.cell = RecruitHeroCell;
			data.padding = 2;
			data.vgap = 4;
			data.hgap = 2;
			data.cellData.width = 128;
			data.cellData.height = 180;
			data.cellData.upAsset = new AssetData(UI.RECRUIT_ITEM_BG);
			data.cellData.overAsset = new AssetData(UI.RECRUIT_ITEM_ROLLOVER_BG);
			data.cellData.selected_upAsset = new AssetData(UI.RECRUIT_ITEM_CLICKDOWN_BG);
			data.cellData.selected_overAsset = new AssetData(UI.RECRUIT_ITEM_CLICKDOWN_BG);
			data.scrollBarData.wheelSpeed = 12;

			super(data);
		}

		override protected function create() : void
		{
			super.create();
		}

		private function initCells() : void
		{
			if (!_cells)
				_cells = [];

			var t : uint = getTimer();
			//trace("initCell start");
			for (var i : uint = _cells.length; i < Math.max(heroes.length, thisdata.rows * thisdata.columns); i++)
			{
				var cell : GCell = new thisdata.cell(thisdata.cellData);
				cell.x = 3 + (i % thisdata.columns) * (thisdata.cellData.width + thisdata.hgap);
				cell.y = 3 + uint(i / thisdata.columns) * (thisdata.cellData.height + thisdata.vgap);

				_cells.push(cell);
				add(cell);
			}
			layout();

			//trace("initCell done" + (getTimer() - t));
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateCells() : void
		{
			var i : uint = 0;
			for each (var hero:VoHero in heroes)
			{
				(_cells[i] as RecruitHeroCell).source = hero;
				i++;
			}
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			// addEventListener(GCell.SELECT, targetSelectHandler, true);
			addEventListener(GCell.SINGLE_CLICK, targetSelectHandler, true);
		}

		override protected function onHide() : void
		{
			// removeEventListener(GCell.SELECT, targetSelectHandler, true);
			removeEventListener(GCell.SINGLE_CLICK, targetSelectHandler, true);
			super.onHide();
		}

		private function targetSelectHandler(event : Event) : void
		{
			var selectedCell : GCell = event.target as GCell;

			for each (var cell:GCell in _cells)
			{
				if (cell.selected && cell != selectedCell)
					cell.selected = false;
			}
		}
	}
}
