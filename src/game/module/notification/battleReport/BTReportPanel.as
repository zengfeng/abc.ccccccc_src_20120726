package game.module.notification.battleReport {
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.net.core.Common;
	import game.net.data.CtoS.CSSpecialOpNotification;

	import gameui.controls.GList;
	import gameui.data.GListData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Lv
	 */
	public class BTReportPanel extends GCommonSmallWindow {
		private var _vipList : GList;

		public function BTReportPanel() {
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 364;
			data.height = 308;
			data.parent = ViewManager.instance.uiContainer;
			data.allowDrag = true;
			super(data);
		}

		override protected function create() : void {
			super.create();
			title = "仙龟拜佛";
			addBackGroud();
			addListCell();
		}

		private function addListCell() : void {
			var data : GListData = new GListData();
			data.padding = 0;
			data.x = 7;
			data.y = 2;
			data.width = 349;
			data.height = 300;
			data.hGap = 0;
			// data.rows = VIPConfigManager.instance.getNItems();
			data.rows = 0;
			data.bgAsset = new AssetData(SkinStyle.emptySkin);
			data.verticalScrollPolicy = GPanelData.ON;
			data.cell = ReportItem;
			data.cellData.width = 349;
			data.cellData.height = 25;
			_vipList = new GList(data);
			addChild(_vipList);

			//addDataToList();
		}

		public function addDataToList() : void {
			_vipList.model.clear();
			var arr : Array = new Array();
			var objVec : Vector.<Object> = BattleReportProxy.btreprotObj;
			var maxObj : int = objVec.length;
			var max : int;
			if (maxObj - 1 < 12) {
				max = 12;
			} else {
				max = maxObj;
			}
			
			var index : Number = 0;
			for (var i : int = 0; i < max; i++) {
				var item : BTReprotVO = new BTReprotVO();
				item.bgInt = index;
				if (maxObj < 12) {
					if (i > maxObj-1)
						item.setBG = true;
					else{
						item.btrObj = objVec[i];
						item.setBG = false;
					}
				} else {
					item.setBG = false;
					item.btrObj = objVec[i];
				}

				arr.push(item);
				if (index == 0)
					index = 1;
				else
					index = 0;
			}
			_vipList.model.source = arr;
		}

		private function addBackGroud() : void {
			var viewBg : Sprite = UIManager.getUI(new AssetData(UI.TRADE_BACKGROUND_BIG));
			viewBg.x = 5;
			viewBg.y = 0;
			viewBg.width = 354;
			viewBg.height = 304;
			addChild(viewBg);
		}
		
		override protected function onClickClose(event : MouseEvent) : void
		{
			super.onClickClose(event);
			deletAll();
			BattleReportProxy.openBattleRePanel = false;
		}

		private function deletAll() : void {
			var cmd:CSSpecialOpNotification = new CSSpecialOpNotification();
			cmd.id = 0;
			cmd.type = 0x12;
			Common.game_server.sendMessage(0x5A,cmd);
		}
		
		override public function hide():void{
			super.hide();
			BattleReportProxy.openBattleRePanel = false;
		}
	}
}
