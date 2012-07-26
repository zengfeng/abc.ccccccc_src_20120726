package game.module.wordDonate {
	import game.core.user.UserData;
	import game.core.hero.VoHero;
	import flash.utils.setTimeout;
	import flash.text.TextField;
	import game.config.StaticConfig;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.wordDonate.donateManage.DonateManage;
	import game.module.wordDonate.donateManage.DonateRewardManager;
	import game.module.wordDonate.donateManage.DonateVo;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import game.net.data.CtoS.CSDonate;
	import game.net.data.CtoS.CSDonateList;
	import game.net.data.CtoS.CSDonateListCount;

	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.controls.GProgressBar;
	import gameui.controls.GTextInput;
	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.data.GProgressBarData;
	import gameui.data.GTextInputData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.GToolTipManager;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;

	import com.commUI.GCommonWindow;
	import com.commUI.icon.ItemIcon;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipData;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	/**
	 * @author Lv
	 */
	public class DonatePanelView extends GCommonWindow  implements IModuleInferfaces ,IAssets {
		private var submitBtn : GButton;
		private var textInputG : GTextInput;
		private var myRanking : GLabel;
		private var weekContribution : GLabel;
		private var expPro : GProgressBar;
		private var expTotal : GLabel;
		private var firstStep : GLabel;
		private var endStep : GLabel;
		private var vo : DonateVo;
		private var fontTipSp : Sprite;
		private var icon : ItemIcon;
		private var linkText : GLabel;
		/** 帮助按钮 */
		private var helpButton : GButton;

		public function DonatePanelView() {
			_data = new GTitleWindowData();
			super(_data);
		}

		override protected function initData() : void {
			_data.width = 328;
			_data.height = 290;
			_data.parent = ViewManager.instance.uiContainer;
			_data.panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			_data.allowDrag = true;
			super.initData();
		}

		private function initEvents() : void {
			submitBtn.addEventListener(MouseEvent.CLICK, ondown);
			textInputG.addEventListener(FocusEvent.FOCUS_OUT, listenerFocusOUT);
			textInputG.addEventListener(FocusEvent.FOCUS_IN, onfoucsIN);
			textInputG.addEventListener(Event.CHANGE, ontextInput);
		}

		private function onfoucsIN(event : FocusEvent) : void {
			textInputG.text = "";
		}
		private var index:Number = 0 ;
		private function ontextInput(event : Event) : void {
			var total : uint = ItemManager.instance.getPileItem(1800).nums;
			var textInt : Number =  Number(TextField(event.target).text);
			if (textInt > total && textInputG.text != "") {
				textInputG.text = String(total);
			}else{
				textInputG.text = String(textInt);
			}
			index = Number(textInputG.text);
		}

		private function listenerFocusOUT(event : FocusEvent) : void {
			var textInt : Number =  index;
			var num:int = ItemManager.instance.getPileItem(1800).nums;
				
			if (textInt > num && textInputG.text != "") {
				textInputG.text = String(num);
			}else if(textInt  == 0){
				textInputG.text = String(num);
			}else{
				textInputG.text = String(textInt);
			}
		}

		override protected function onClickClose(event : MouseEvent) : void {
			MenuManager.getInstance().changMenu(MenuType.DONATE);
		}

		public function initModule() : void {
			title = "开天斧";
			addBG();
			addPanel();
			super.initViews();
			initEvents();
			DonateProxy.instance.applyNow();
		}

		private function addBG() : void {
			var bg : Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			bg.x = 3;
			bg.y = 5;
			bg.width = 316;
			bg.height = 279;
			_contentPanel.addChild(bg);

			var bg2 : Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND2));
			bg2.x = 12;
			bg2.y = 180;
			bg2.width = 296;
			bg2.height = 72;
			_contentPanel.addChild(bg2);

			var bg3 : Bitmap = new Bitmap(RESManager.getBitmapData(new AssetData("ktf", "KTFSwf")));
			bg3.x = 7;
			bg3.y = 9;
			_contentPanel.addChild(bg3);

			icon = UICreateUtils.createItemIcon({x:103, y:190, showBorder:true, showBg:true, showNums:true, showToolTip:true});
			_contentPanel.addChild(icon);

			helpButton = UICreateUtils.createHelpGbutton();
			helpButton.x = 328 - helpButton.width - 30;
			helpButton.y = -25;
			var helpStr : String = donateTips();
			var toolTipData : ToolTipData = new ToolTipData();
			toolTipData.labelData.minWidth = 210;
			var helpToolTip : ToolTip = new ToolTip(toolTipData);
			helpToolTip.source = helpStr;
			helpButton.toolTip = helpToolTip;
			GToolTipManager.registerToolTip(helpToolTip);
			addChild(helpButton);
		}

		private function updateIcon() : void {
			if (!icon) return;
			icon.source = ItemManager.instance.getPileItem(1800);
		}

		private function ondown(event : MouseEvent) : void {
			var total : uint = ItemManager.instance.getPileItem(1800).nums;
			if (uint(textInputG.text) > 0 && (total > 0)) {
				var cmd : CSDonate = new CSDonate();
				cmd.count = uint(textInputG.text);
				Common.game_server.sendMessage(0x100, cmd);

				var cmd1 : CSDonateList = new CSDonateList();
				cmd1.page = DonateProxy.nowPageNum;
				Common.game_server.sendMessage(0x103, cmd1);

				var cmd2 : CSDonateListCount = new CSDonateListCount();
				Common.game_server.sendMessage(0x102, cmd2);
				StateManager.instance.checkMsg(207);
			} else {
				StateManager.instance.checkMsg(204);
			}
		}

		public function setPanel() : void {
			if (!myRanking) return;
			vo = DonateManage.getDonateDic[DonateProxy.donateLevel];
			var vo2 : DonateVo;
			vo2 = DonateManage.getDonateDic[DonateProxy.donateLevel + 1];
			var index : int = DonateProxy.nowWeekRank;
			if (index == 0)
				myRanking.text = "未贡献";
			else {
				myRanking.text = String(index);
			}
			// 是否更改
			textInputG.text = String(ItemManager.instance.getPileItem(1800).nums);

			weekContribution.text = DonateProxy.nowWeekContributionVaule + "个";
			if (DonateManage.getDonateMaxLevel == vo.level) {
				firstStep.text = "满级";
				endStep.visible = false;
				expTotal.visible = false;
				expPro.visible = false;
			} else {
				endStep.visible = true;
				expTotal.visible = true;
				expPro.visible = true;
				firstStep.text = StringUtils.addBold(DonateProxy.donateLevel + "级 → ");
				endStep.text = StringUtils.addBold((DonateProxy.donateLevel + 1) + "级");
				expTotal.text = StringUtils.addColor(String(DonateProxy.nowContributionVaule) + "/" + String(vo2.expVaule), "#FFFFFF");
				expPro.value = ((DonateProxy.nowContributionVaule) / (vo2.expVaule)) * 100;
			}
			expTotal.x = (this.width - expTotal.width) / 2;
			var one : String = "";
			one = "<b><font color='#FFFFFF' bold = '2' size = '14'>开天斧 </font></b>" +"<b><font color='#FFCC00' bold = '2' size = '14'>" + vo.level + "级</font></b>" + "\n" + "打坐经验提升"+"<font color='#FFCC00' size = '12'>" + vo.percentageUp + "%</font>\n\n";
			var two : String = "";
			if (DonateManage.getDonateMaxLevel != vo.level) {
				two = "<b><font color='#FFFFFF' size = '14'>下一级效果</font></b>\n" + "打坐经验提升"+"<font color='#FFCC00' size = '12'>" + vo2.percentageUp + "%</font>";
			}
			imgTipsStr = one + two;
			var maxRank : int = DonateRewardManager.saveDonateRewardMaxRank;
			var rank : int = DonateProxy.nowWeekRank;
			if (rank == 0) return;
			var str : String = "";
			if (rank < maxRank)
				str = DonateRewardManager.saveDonateRewardDic[rank];
			else
				str = DonateRewardManager.saveDonateRewardDic[maxRank];
			str = str.split("：")[1];
			//str = str.split("、")[0]  + "、" + str.split("、")[1];
			
			var hero:VoHero = UserData.instance.myHero;
			
			var one1:String = StringUtils.addSize(StringUtils.addBold(StringUtils.addColorById(hero.name, (hero.color ))),14) + StringUtils.addSize(StringUtils.addBold(StringUtils.addColorById( " "+hero.level+"级", (hero.color))),14)+"\n\n";
			var one2:String = "排名：<font color='#FFF000'>"+index+"</font>\n每周奖励：\n" + str +"\n\n"+"<font color='#999999'>在周日24:00结算排名奖励 </font>";
			nameTipsStr = one1 + one2;
		}

		// 开天斧图标上的tips上的值
		private var imgTipsStr : String = "未加载";

		// 开天斧图标上的tips
		private function setImgTips() : String {
			return imgTipsStr;
		}

		// 名称tips上的值
		private var nameTipsStr : String = "未贡献" ;

		// 名称上的tips
		private function nameTips() : String {
			return nameTipsStr;
		}

		private function addPanel() : void {
			var data : GLabelData = new GLabelData();
			data.textFieldFilters = [];
			data.textColor = 0x2F1F00;
			data.text = "我的排名：";
			data.textFormat.size = 12;
			data.x = 10;
			data.y = 9;
			var text1 : GLabel = new GLabel(data);
			_contentPanel.addChild(text1);
			data.clone();
			data.x = text1.width + text1.x ;
			data.text = "排名555";
			myRanking = new GLabel(data);
			_contentPanel.addChild(myRanking);
			data.clone();
			data.text = "本周贡献：";
			data.y = text1.y + text1.height - 2;
			data.x = text1.x;
			var text2 : GLabel = new GLabel(data);
			_contentPanel.addChild(text2);
			data.clone();
			data.text = "200个";
			data.x = text2.x + text2.width;
			weekContribution = new GLabel(data);
			_contentPanel.addChild(weekContribution);
			data.clone();
			data.y = 154;
			data.text = "9999/9999";
			data.x = (this.width - data.width) / 2;
			expTotal = new GLabel(data);
			data.clone();
			data.text = "1级 → ";
			data.x = 130;
			data.y = 136;
			firstStep = new GLabel(data);
			_contentPanel.addChild(firstStep);
			data.clone();
			data.text = "2级";
			data.x = firstStep.x + firstStep.width;
			endStep = new GLabel(data);
			_contentPanel.addChild(endStep);
			data.clone();
			data.text = StringUtils.addLine("贡献排行榜");
			data.textColor = 0xFF6633;
			data.x = 10;
			data.y = text2.y + text2.height + 1;
			linkText = new GLabel(data);
			_contentPanel.addChild(linkText);

			var datainput : GTextInputData = new GTextInputData();
			datainput.borderAsset = new AssetData("sutraTextInput");
			datainput.width = 70;
			datainput.height = 22;
			datainput.x = 157;
			datainput.y = 205;
			datainput.restrict = "0-9";
			datainput.maxChars = 4;
			datainput.maxNum = 9999;
			textInputG = new GTextInput(datainput);
			_contentPanel.addChild(textInputG);

			var dataBtn : GButtonData = new GButtonData();
			dataBtn.labelData.text = "贡献";
			dataBtn.x = 126;
			dataBtn.y = 255;
			submitBtn = new GButton(dataBtn);
			_contentPanel.addChild(submitBtn);

			var dataExp : GProgressBarData = new GProgressBarData();
			dataExp.trackAsset = new AssetData("DonatePro_bg");
			dataExp.barAsset = new AssetData("DonatePro_exp");
			// dataExp.toolTipData = new GToolTipData();
			dataExp.height = 20;
			dataExp.width = 298;
			dataExp.x = 12;
			dataExp.y = 154;
			dataExp.paddingX = 3;
			dataExp.paddingY = 3;
			dataExp.padding = 3;
			expPro = new GProgressBar(dataExp);
			_contentPanel.addChild(expPro);
			expPro.value = 0 / 100 * 100;
			// expPro.toolTip.source = "10000/10000";

			// _contentPanel.addChild(expNow);
			_contentPanel.addChild(expTotal);
			expTotal.mouseEnabled = false;

			fontTipSp = new Sprite();
			fontTipSp.graphics.beginFill(0x555555, 0);
			fontTipSp.graphics.drawRect(10, 9, 100, 38);
			fontTipSp.graphics.endFill();
			_contentPanel.addChild(fontTipSp);
			ToolTipManager.instance.registerToolTip(fontTipSp, ToolTip, nameTips);

			var sp : Sprite = new Sprite();
			sp.graphics.beginFill(0xFF0000, 0);
			sp.graphics.drawRect(90, 51, 100, 84);
			sp.graphics.endFill();
			_contentPanel.addChild(sp);
			ToolTipManager.instance.registerToolTip(sp, ToolTip, setImgTips);

			linkText.addEventListener(MouseEvent.MOUSE_DOWN, onlink);
		}

		private function onlink(event : MouseEvent) : void {
			setTimeout(timerLinke, 500);
			linkText.mouseEnabled = false;
			DonateControl.instance.setupListUI();
		}

		private function timerLinke() : void {
			linkText.mouseEnabled = true;
		}

		override public function show() : void {
			super.show();
			updateIcon();
			Common.game_server.addCallback(0xFFF2, onPackChange);
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2, -1, (UIManager.stage.stageHeight - this.height) / 2, -1);
		}

		override public function hide() : void {
			super.hide();
			Common.game_server.removeCallback(0xFFF2, onPackChange);
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2, -1, (UIManager.stage.stageHeight - this.height) / 2, -1);
		}

		private function onPackChange(msg : CCPackChange) : void {
			if (msg.topType | Item.EXPEND) {
				updateIcon();
			}
		}

		public function getResList() : Array {
			return [new LibData(StaticConfig.cdnRoot + "assets/ui/KTF.swf", "KTFSwf")];
		}

		// =====================
		// 帮助tips
		// =====================
		private function donateTips() : String {
			var tips : String = "";
			var vec : Vector.<String> = DonateRewardManager.saveDonateRewardTipsVec;
			for each (var str:String in vec) {
				tips += str + "\n";
			}
			return tips;
		}
	}
}
