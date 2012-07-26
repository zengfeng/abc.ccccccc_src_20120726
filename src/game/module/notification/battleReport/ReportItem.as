package game.module.notification.battleReport {
	import com.utils.PotentialColorUtils;
	import game.core.user.UserData;
	import game.net.core.Common;
	import game.net.data.CtoS.CSSpecialOpNotification;
	import flash.text.TextFormat;
	import game.definition.UI;

	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.button.KTButtonData;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author Lv
	 */
	public class ReportItem extends GCell {
		
		
		// ======================================================
		// Getter/Setter
		// ======================================================
		override public function set source(value : *) : void
		{
			_source = value;

			if (_source)
			{
				updateBg();
				updateVipListCellText();
				if(ReportVO.setBG == true)
					clear();
			}
			else
				clear();
		}
		
		
		private var playerName:TextField;
		private var staticText:TextField;
		private var seeReport:TextField;
		private var closeBtn:GButton;
		
		public function get ReportVO() : BTReprotVO
		{
			return _source as BTReprotVO;
		}
		//==================================================
		//初始化UI
		//==================================================
		override protected function create() : void
		{
			super.create();
			addVipListCellText();
		}

		private function addVipListCellText() : void {
			playerName = UICreateUtils.createTextField(null, "", 230, 18, 5, 4, new TextFormat(null,null,null,null,null,null,null,null,TextFormatAlign.CENTER));
			addChild(playerName);

//			staticText = UICreateUtils.createTextField(null, "", 115, 18, 115, 4,new TextFormat(null,null,null,null,null,null,null,null,TextFormatAlign.CENTER));
//			addChild(staticText);

			seeReport = UICreateUtils.createTextField(null, "", 60, 18, 244, 4,new TextFormat(null,null,null,null,null,null,null,null,TextFormatAlign.CENTER));
			addChild(seeReport);
			
			var data:GButtonData = new KTButtonData(8);
			closeBtn = new GButton(data);
			closeBtn.x = 314;
			closeBtn.y = 8;
			addChild(closeBtn);
			closeBtn.visible = false;
			
			seeReport.mouseEnabled = true;
			seeReport.selectable = false ;
			
			seeReport.addEventListener(MouseEvent.CLICK,onEnterFighting);
			closeBtn.addEventListener(MouseEvent.CLICK, onDeletThis);
		}
		
		public function ReportItem(data : GCellData) {
			
			data.upAsset = new AssetData(SkinStyle.emptySkin);
			data.overAsset = null;
			data.selected_upAsset = null;
			data.selected_overAsset = null;
			data.disabledAsset = null;
			super(data);
			
		}
		//==================================================
		//初始化数据
		//==================================================
		private function updateVipListCellText() : void {
			var obj:Object = ReportVO.btrObj;
			if(obj == null){
				clear();
				return;
			}
			playerName.htmlText = StringUtils.addColor(obj["name"],PotentialColorUtils.getColorOfStr(obj["color"]));
			if(obj["type"] == 402){
				seeReport.visible = true;
				playerName.htmlText = StringUtils.addColor(obj["name"],PotentialColorUtils.getColorOfStr(obj["color"])) + StringUtils.addColor("成功打劫了你！","#2F1F00");
			}
			else{
				seeReport.visible = false;
				playerName.htmlText = StringUtils.addColor(obj["name"],PotentialColorUtils.getColorOfStr(obj["color"])) + StringUtils.addColor("打劫你失败了。","#2F1F00");
			}
			seeReport.htmlText = StringUtils.addLine(StringUtils.addColor("查看战报","#FF6633"));
			closeBtn.visible = true;
		}
		//==================================================
		//清空数据
		//==================================================
		private function clear() : void {
			
			playerName.htmlText = "";
//			staticText.htmlText = "";
			seeReport.htmlText = "";
			closeBtn.visible = false;
		}
		//==================================================
		//添加不同背景
		//==================================================
		private function updateBg() : void {
			var bg : Sprite;
			if (ReportVO.bgInt == 0)
				bg = UIManager.getUI(new AssetData(UI.VIP_LIST_LIGHT_BG));
			else
				bg = UIManager.getUI(new AssetData(UI.VIP_LIST_DARK_BG));
			bg.x = 0;
			bg.y = 0;
			bg.width = 339;
			bg.height = 25;
			addChildAt(bg, 1);
		}

		private function onEnterFighting(event : MouseEvent) : void {
			var obj:Object = ReportVO.btrObj;
			if(!obj)return;
			var cmd:CSSpecialOpNotification = new CSSpecialOpNotification();
			cmd.id = obj["id"];
			cmd.type = 2;
			Common.game_server.sendMessage(0x5A,cmd);
		}

		private function onDeletThis(event : MouseEvent) : void {
			var obj:Object = ReportVO.btrObj;
			if(!obj)return;
			var cmd:CSSpecialOpNotification = new CSSpecialOpNotification();
			cmd.id = obj["id"];
			cmd.type = 0x12;
			Common.game_server.sendMessage(0x5A,cmd);
		}
		
		override protected function onHide() : void {
			super.onHide();
		}
		
		override protected function onShow() : void {
			super.onShow();
			seeReport.removeEventListener(MouseEvent.MOUSE_DOWN,onEnterFighting);
			closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onDeletThis);
		}
	}
}
