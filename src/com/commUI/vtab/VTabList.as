package com.commUI.vtab
{
	import gameui.cell.LabelSource;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.group.GToggleGroup;

	import model.SingleSelectionModel;

	/**
	 * @author verycd
	 */
	public class VTabList extends GComponent
	{
		private static const NUM_TABS : uint = 6;
		protected var _group : GToggleGroup;

		public function VTabList()
		{
			var data : GComponentData = new GComponentData();

			super(data);
			initTabs();
		}
		
		public function get selectionModel():SingleSelectionModel
		{
			return _group.selectionModel;
		}
		
		public function get selection():LabelSource
		{
			return _group.selection.source;
		}
		
		public function get index() : int
		{
			return _group.selectionModel.index;
		}
		
		private function initTabs() : void
		{
			_group = new GToggleGroup();

			var tabY : Number = 0;

			for (var i : uint = 0; i < NUM_TABS; i++)
			{
				var tab : VTab = new VTab();
				tab.x = 0;
				tab.y = tabY;
				tab.group = _group;

				addChild(tab);

				tabY += tab.height;
			}
		}

		// 设置
		override public function set source (value:* /* of LabelSource */ ):void
		{
			var length : uint = value.length;
			var i : uint = 0;

			for each (var tab:VTab in _group.model.source)
			{
				if (i < length)
				{
					tab.source = value[i];
					tab.visible = true;
				}
				else
				{
					tab.visible = false;
				}

				i++;
			}
		}

		public function select(index : uint) : void
		{
			_group.selectionModel.index = index;
		}


	}
}
