package game.module.formation.upgrade {
	import com.commUI.button.KTButtonData;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.StringUtils;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.module.formation.formationManage.FMManager;
	import game.module.formation.formationManage.VoFM;
	import game.net.core.Common;
	import game.net.data.CtoS.CSLearn;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	import net.RESManager;

	/**
	 * @author Lv
	 */
	public class UpgradItem extends GPanel {
		public var usingTxt : GLabel;
		public var fmName : GLabel;
		public var fmLevel : GLabel;
		private var upgradBtn : GButton;
		private var LimitTxt : GLabel;
		private var upName : String;
		private var mcItem : MovieClip;
		private var FmBG : MovieClip;
		public var FmID : int;
		private var level : int;

		public function UpgradItem(name : String, id : int, level : int) {
			_data = new GPanelData();
			initData();
			upName = name;
			FmID = id;
			this.level = level;
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 170;
			_data.height = 66;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
		}

		private var _isClick : Boolean = false;
		private var _openClick : Boolean = false;

		private function initEvent() : void {
			upgradBtn.addEventListener(MouseEvent.CLICK, onclick);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		}

		private var isRoll : Boolean = true;

		private function onRollOver(event : MouseEvent) : void {
			if (!isRoll) return;
			if (!isClick)
				FmBG.gotoAndStop(2);
			else
				FmBG.gotoAndStop(3);
		}

		private function onRollOut(event : MouseEvent) : void {
			if (!isRoll) return;
			if (!isClick)
				FmBG.gotoAndStop(1);
			else
				FmBG.gotoAndStop(3);
		}

		private function initView() : void {
			addGB();
			addPanel();
		}

		private function onclick(event : MouseEvent) : void {
			event.stopPropagation();
			var myLevel : int = UserData.instance.myHero.level;
			var thisFmlevel : int = FMManager.formationLeveLimitVec[level];
			if (myLevel < thisFmlevel)
				StateManager.instance.checkMsg(281);
			if (!isGrader) return;
			var cmd : CSLearn = new CSLearn();
			cmd.id = FmID;
			Common.game_server.sendMessage(0x1D, cmd);
		}

		// 升级阵形
		public function upgradeFm(Fmlevel : int) : void {
			if (upgradBtn.label.text == "升级") {
				StateManager.instance.checkMsg(197);
			} else if (!((FmID == 11) && (Fmlevel == 1))) {
				StateManager.instance.checkMsg(280);
			}

			level = Fmlevel;
			upgradBtn.visible = true;
			upgradBtn.label.text = "升级";
			var myLevel : int = UserData.instance.myHero.level;
			var needLevel : int = FMManager.formationLeveLimitVec[level];
			// if(myLevel>(needLevel-3)){
			if (myLevel > (needLevel - 1)) {
				upgradBtn.visible = true;
			} else {
				fmUpgraderEnable();
			}
			if (level > 1)
				mcItem.gotoAndStop(3);
			fmLevel.text = String(level) + "级";
			fmLevel.visible = true;
			showTip(level);
			isRoll = true;
		}

		public function fmStart(lev : int) : void {
			fmLevel.visible = false;
			upgradBtn.visible = false;
			LimitTxt.text = "（" + StringUtils.addColor(String(lev), "#FF0000") + "级可学习）";
			showTip(level);
			isRoll = false;
		}

		public function fmLeanr() : void {
			upgradBtn.label.text = "学习";
			fmLevel.visible = false;
			LimitTxt.visible = false;
			upgradBtn.visible = true;
			showTip(level);
			isRoll = false;
		}

		public function fmUpgrader() : void {
			upgradBtn.visible = true;
			upgradBtn.label.text = "升级";
			fmLevel.visible = true;
			LimitTxt.visible = false;
			showTip(level);
			isRoll = true;
		}

		public function fmUpgraderEnable() : void {
			// upgradBtn.label.text = "升级";
			fmLevel.visible = true;
			LimitTxt.visible = false;
			upgradBtn.visible = false;
			showTip(level);
		}

		public function changeMC(str : String) : void {
			mcItem = RESManager.getMC(new AssetData(str,"FMSwf"));
			mcItem.x = 7;
			mcItem.y = 6;
			mcItem.gotoAndStop(2);
			_content.addChild(mcItem);
			if (level > 1) {
				mcItem.gotoAndStop(3);
			}
		}

		// 阵形启用
		public function usingFormation() : void {
			usingTxt.visible = true;
			usingTxt.textColor = 0x33CC00;
			FmBG.gotoAndStop(3);
		}

		public function closingFormation() : void {
			usingTxt.visible = false;
			FmBG.gotoAndStop(1);
		}

		public function mouseOver() : void {
			FmBG.gotoAndStop(2);
		}

		public function mouseOut() : void {
			FmBG.gotoAndStop(1);
		}

		public function mouseClick() : void {
			isClick = true;
			FmBG.gotoAndStop(3);
		}

		private function addPanel() : void {
			var data : GLabelData = new GLabelData();
			data.textFieldFilters = [];
			data.textColor = 0x2F1F00;
			data.text = "(启用中)";
			data.x = 63;
			data.y = 7;
			usingTxt = new GLabel(data);
			_content.addChild(usingTxt);
			data.clone();
			data.text = upName;
			data.x = 69;
			data.y = 22;
			fmName = new GLabel(data);
			_content.addChild(fmName);
			data.clone();
			data.text = level + "级";
			data.x = 130;
			fmLevel = new GLabel(data);
			_content.addChild(fmLevel);
			data.clone();
			data.textFormat.size = 12;
			data.text = "（主将XX级可学习）";
			data.x = 60;
			data.y = 42;
			data.width = 130;
			data.textFormat = new TextFormat("12", null, null, null, null, null, null, null, TextFormatAlign.CENTER);
			LimitTxt = new GLabel(data);
			_content.addChild(LimitTxt);
			fmLevel.visible = false;
			var datab : GButtonData = new KTButtonData();
			datab.labelData.text = "学习";
			datab.x = 112;
			datab.y = 41;
			datab.width = 50;
			datab.height = 22;
			upgradBtn = new GButton(datab);
			_content.addChild(upgradBtn);
			upgradBtn.visible = false;
			ToolTipManager.instance.registerToolTip(upgradBtn, ToolTip, setBtnTips);
		}

		private var isGrader : Boolean = true;

		private function showTip(level : int) : void {
			var showLevel : int = (FMManager.formationKindsDic[FmID] as VoFM).fm_shwoLevel;
			var arr : Array = FMManager.formationLeveLimitVec;
			var lev : int = arr[level];
			if (showLevel > lev)
				lev = showLevel + 2;
			var NUM : int = FMManager.formationSilverLevelVec[level];
			var myleveL : int = UserData.instance.myHero.level;
			var mySilver : int = UserData.instance.silver;
			if (myleveL > (lev - 1))
				isGrader = true;
			else
				isGrader = false;
			if (myleveL > (lev - 1)) {
				tipsStr = "所需等级：" + StringUtils.addColor(String(lev), "#FFF000") + "\r";
				if (mySilver < NUM)
					tipsStr += "所需银币：" + StringUtils.addColor(String(NUM), "#FF0000");
				else
					tipsStr += "所需银币：" + StringUtils.addColor(String(NUM), "#FFF000");
			} else {
				tipsStr = "所需等级：" + StringUtils.addColor(String(lev), "#FF0000") + "\r" ;
				if (mySilver < NUM)
					tipsStr += "所需银币：" + StringUtils.addColor(String(NUM), "#FF0000");
				else
					tipsStr += "所需银币：" + StringUtils.addColor(String(NUM), "#FFF000");
			}
		}

		private var tipsStr : String;

		private function setBtnTips() : String {
			var showLevel : int = (FMManager.formationKindsDic[FmID] as VoFM).fm_shwoLevel;
			var arr : Array = FMManager.formationLeveLimitVec;
			var lev : int = arr[level];
			if (showLevel > lev)
				lev = showLevel + 2;
			var NUM : int = FMManager.formationSilverLevelVec[level];
			var myleveL : int = UserData.instance.myHero.level;
			var mySilver : int = UserData.instance.silver;
			if (myleveL > (lev - 1))
				isGrader = true;
			else
				isGrader = false;
			if (myleveL > (lev - 1)) {
				tipsStr = "所需等级：" + StringUtils.addColor(String(lev), "#FFF000") + "\r";
				if (mySilver < NUM)
					tipsStr += "所需银币：" + StringUtils.addColor(String(NUM), "#FF0000");
				else
					tipsStr += "所需银币：" + StringUtils.addColor(String(NUM), "#FFF000");
			} else {
				tipsStr = "所需等级：" + StringUtils.addColor(String(lev), "#FF0000") + "\r" ;
				if (mySilver < NUM)
					tipsStr += "所需银币：" + StringUtils.addColor(String(NUM), "#FF0000");
				else
					tipsStr += "所需银币：" + StringUtils.addColor(String(NUM), "#FFF000");
			}
			return tipsStr;
		}

		private function addGB() : void {
			FmBG = RESManager.getMC(new AssetData("rightBG","FMSwf"));
			_content.addChild(FmBG);
		}

		public function get isClick() : Boolean {
			return _isClick;
		}

		public function set isClick(isClick : Boolean) : void {
			_isClick = isClick;
		}

		public function get openClick() : Boolean {
			return _openClick;
		}

		public function set openClick(openClick : Boolean) : void {
			_openClick = openClick;
		}
	}
}
