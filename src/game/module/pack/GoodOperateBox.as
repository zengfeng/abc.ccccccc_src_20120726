package game.module.pack {
	import game.core.item.Item;
	import game.core.item.equipment.Equipment;
	import game.core.menu.IMenuButton;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.SignalBusManager;
	import game.module.pack.merge.MergeManager;

	import gameui.cell.LabelSource;
	import gameui.controls.GList;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;
	import gameui.data.GListData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.alert.Alert;

	import flash.events.Event;
	import flash.events.MouseEvent;





	/**
	 * @author jian
	 */
	public class GoodOperateBox extends GComponent
	{
		// =====================
		// 定义
		// =====================
		private var _list : GList;

		public function GoodOperateBox()
		{
			var data : GComponentData = new GComponentData();
			data.parent = UIManager.root;
			super(data);
		}

		override public function set source(value : *) : void
		{
			if (!value is Item)
				return;

			_source = value;

			updateList();
		}

		override protected function create() : void
		{
			super.create();

			var data : GListData = new GListData();
			data.scaleMode = ScaleMode.AUTO_HEIGHT;
			data.width = 40;
			data.rows = 0;
			data.bgAsset = new AssetData(UI.TIP_BACKGROUND);
			data.cellData.overAsset = new AssetData(UI.TIP_OVER_BACKGROUND);
			data.cellData.selected_overAsset = new AssetData(UI.TIP_OVER_BACKGROUND);
			// data.cellData.width = 36;
			data.cellData.labelData.textColor = 0xFFFFFF;
			data.cellData.labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			// data.cellData.labelData.width = 40;
			data.verticalScrollPolicy=GPanelData.OFF;
			_list = new GList(data);
			addChild(_list);
		}

		private function updateList() : void
		{
			var arr : Array = [];
			var item : Item = _source as Item;

			if (item is Equipment)
				arr.push(new LabelSource("装备", executeEquip));
			if (item.usable)
				arr.push(new LabelSource("使用", executeUseItem));
//			if (item.usable && (_source as Item).nums > 1)
//				arr.push(new LabelSource("全部使用", executeUseAll));
			if (UserData.instance.level >= 30 && MergeManager.instance.checkMergeable(item.id))
			{
				arr.push(new LabelSource("合成", executeMerge));
			}
			if (item.price > 0)
				arr.push(new LabelSource("出售", executeSellItem));

			_list.model.source = arr;
		}

		private function executeEquip() : void
		{
			ManagePack.equipItem(_source as Equipment);
			hide();
		}

		private function executeUseItem() : void
		{
			if (_source["useLevel"]  > UserData.instance.level)
			{
				StateManager.instance.checkMsg(251);
				return;
			}
			ManagePack.useItem(_source["id"], _source["binding"], 1, 0);
			hide();
		}

		private function executeUseAll() : void
		{
			ManagePack.useItem(_source["id"], _source["binding"], _source["nums"], 0);
			hide();
		}

		private function executeMerge() : void
		{
			var button : IMenuButton = MenuManager.getInstance().openMenuView(MenuType.MERGE_MATERIAL);
			if (button)
			{
				SignalBusManager.mergeViewSelectSource.dispatch((_source as Item).id);
				hide();
			}
		}

		private function executeSellItem() : void
		{
			StateManager.instance.checkMsg(249, null, onSellConfirm);
		}

		private function onSellConfirm(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				ManagePack.sellItem([_source]);
				hide();
			}
			return true;
		}

		override protected function onShow() : void
		{
			_list.selectionModel.addEventListener(Event.CHANGE, cell_selectHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_clickHandler);
		}

		override protected function onHide() : void
		{
			_list.selectionModel.removeEventListener(Event.CHANGE, cell_selectHandler);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_clickHandler);
		}

		private function cell_selectHandler(event : Event) : void
		{
			var func : Function = (_list.selection as LabelSource).value;

			if (func is Function)
				func();
		}

		private function stage_clickHandler(event : MouseEvent) : void
		{
			if (!hitTestPoint(event.stageX, event.stageY))
				hide();
		}
	}
}
