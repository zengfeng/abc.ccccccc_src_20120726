package game.module.sutra {
	import flash.utils.clearTimeout;
	import game.config.StaticConfig;
	import game.core.hero.VoHero;
	import game.core.item.functionItem.FunManage;
	import game.core.item.prof.ProfItemManage;
	import game.core.item.sutra.Sutra;
	import game.core.item.sutra.sutraSkill.SutraManager;
	import game.core.item.sutra.sutraSkill.SutraSkillItem;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.net.core.Common;
	import game.net.data.CtoS.CSHeroEnhance;
	import game.net.data.CtoS.CSHeroEnhanceRevoke;
	import game.net.data.CtoS.CSSwitchSkill;
	import game.net.data.StoC.SCPlayerInfoChange2;
	import game.net.data.StoC.SCSwitchSkill;

	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.controls.GMagicLable;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;

	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.tooltip.ToolTipManager;
	import com.commUI.tooltip.WordWrapToolTip;
	import com.utils.StringUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;

	/**
	 * @author Lv
	 */
	public class SutraImg extends GComponent {
		private var sutraStep : Sutra;
		private var weapMC : MovieClip;
		private var submitBtn : GButton;
		private var totalCultivation : GMagicLable;
		private var needCultivation : GMagicLable;
		private var backProf : TextField;
		private var submintText : GLabel;
		private var runesBtn1 : MovieClip;
		private var runesBtn2 : MovieClip;

		public function SutraImg() {
			_base = new GComponentData();
			initData();
			super(_base);
			initView();
			initEvent();
		}

		private function initData() : void {
			_base.width = 583;
			_base.height = 420;
		}

		private function initEvent() : void {
			submitBtn.addEventListener(MouseEvent.CLICK, onclickSub);
			backProf.addEventListener(MouseEvent.MOUSE_DOWN, onClickBack);
			Common.game_server.addCallback(0x1f, playerInfoChange2);
			Common.game_server.addCallback(0x1B, sCSwitchSkill);
		}

		private function removeEvent() : void {
			Common.game_server.removeCallback(0x1B, sCSwitchSkill);
			Common.game_server.removeCallback(0x1f, playerInfoChange2);
			submitBtn.removeEventListener(MouseEvent.CLICK, onclickSub);
			backProf.removeEventListener(MouseEvent.MOUSE_DOWN, onClickBack);
		}

		private function sCSwitchSkill(e : SCSwitchSkill) : void {
			sutraStep.runetotemID = e.skillID;
			runes = e.skillID;
			var item1 : SutraSkillItem = SutraManager.instance.getMardsData(sutraStep.hero.id,1);
			if (runes == 1) {
				sutraStep.runetotemID = runes;
				if (sutraStep.step +1 != item1.openStep) {
					baokai1.visible = true;
					baokai1.gotoAndPlay(2);
				}
				runesBtn1.gotoAndStop(3);
				if (sutraStep.getIsOpenRunet(2))
					runesBtn2.gotoAndStop(1);
			} else if (runes == 2) {
				sutraStep.runetotemID = runes;
				baokai2.visible = true;
				baokai2.gotoAndPlay(2);
				runesBtn2.gotoAndStop(3);
				runesBtn1.gotoAndStop(1);
			}
			if (runes != 0) {
				StateManager.instance.checkMsg(299, [sutraStep.getRunet(runes)]);
			}
			ToolTipManager.instance.registerToolTip(weapMC.mc, WordWrapToolTip, sutraStep.sutraTips);
			SutraContral.instance.runtesChange();
		}

		private function playerInfoChange2(e : SCPlayerInfoChange2) : void {
			if (e.hasProfExp) {
				totalCultivation.setMagicText(String(UserData.instance.profExp), UserData.instance.profExp);
				setNeedCultivation();
			}
		}

		private function onClickBack(event : MouseEvent) : void {
			if (weapMC == null) return;
			StateManager.instance.checkMsg(298, null, isBackProf, [(sutraStep.totalExpSetp) * 0.9]);
		}

		private function isBackProf(type : String) : Boolean {
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT) {
				var cmd : CSHeroEnhanceRevoke = new CSHeroEnhanceRevoke();
				cmd.id = sutraStep.hero.id;
				Common.game_server.sendMessage(0x16, cmd);
			}
			return true;
		}

		private function onclickSub(event : MouseEvent) : void {
			if (weapMC == null) return;
			
			var item1 : SutraSkillItem = SutraManager.instance.getMardsData(sutraStep.hero.id, 1);
			var item2 : SutraSkillItem = SutraManager.instance.getMardsData(sutraStep.hero.id, 2);
			if (sutraStep.step+1 == item1.openStep || sutraStep.step+1 == item2.openStep) {
				setTimeout(timeoutBtnClick, 1000);
				submitBtn.mouseEnabled = false;
				submitBtn.mouseChildren = false;
			}
			
			if (UserData.instance.profExp < sutraStep.nextSetpExp) {
				needCultivation.textColor = 0xBD0000;
				StateManager.instance.checkMsg(267);
				return;
			} else {
				needCultivation.textColor = 0xFFFFFF;
			}

			var cmd : CSHeroEnhance = new CSHeroEnhance();
			cmd.id = sutraStep.hero.id;
			Common.game_server.sendMessage(0x15, cmd);
		}

		private function timeoutBtnClick() : void {
			var item1 : SutraSkillItem = SutraManager.instance.getMardsData(sutraStep.hero.id, 1);
			var item2 : SutraSkillItem = SutraManager.instance.getMardsData(sutraStep.hero.id, 2);
			if (sutraStep.step > item2.openStep-1) {
				runesBtn1.visible = true;
				runesBtn2.visible = true;
			}else if(sutraStep.step > item1.openStep-1){
				runesBtn1.visible = true;
				runesBtn2.visible = false;
			}else{
				runesBtn1.visible = false;
				runesBtn2.visible = false;
			}
			submitBtn.mouseEnabled = true;
			submitBtn.mouseChildren = true;
		}

		private function initView() : void {
			addBG();
			addButtn();
			showCultivation();
		}

		private var needtext : GLabel;
		private var tipSutra:String = "";
		private function showCultivation() : void {
			var data : GLabelData = new GLabelData();
			data.text = "修为";
			data.x = 40;
			data.y = 11.6;
			var text1 : GLabel = new GLabel(data);
			this.addChild(text1);
			data.clone();
			data.text = String(UserData.instance.profExp);
			data.x = text1.x + text1.width;
			totalCultivation = new GMagicLable(data);
			this.addChild(totalCultivation);
			data.clone();
			data.text = "所需修为";
			data.x = 167 - 12;
			data.y = 313 + 17;
			needtext = new GLabel(data);
			this.addChild(needtext);
			data.clone();
			data.text = String(ProfItemManage.instance.getNowSetpProfExp(2));
			data.x = needtext.x + needtext.width;
			needCultivation = new GMagicLable(data);
			this.addChild(needCultivation);
			data.clone();
			data.width = 200;
			data.x = 145;

			data.y = 338;
			submintText = new GLabel(data);
			data.width = 160;
			this.addChild(submintText);
			submintText.visible = false;

			backProf = new TextField();
			backProf.defaultTextFormat = backProfStr;
			backProf.filters = [new DropShadowFilter(0, 45, 0x000000, 1, 5, 5, 2)];
			backProf.htmlText = StringUtils.addLine("取回修为");
			backProf.embedFonts = false;
			backProf.width = 52;
			this.addChild(backProf);
			backProf.x = 445 + 28;
			backProf.y = 358 + 10;
			
			
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x555555,0);
			sp.graphics.drawRect(0, 0, 132, 41);
			sp.graphics.endFill();
			addChild(sp);
			tipSutra = StringUtils.addColor(StringUtils.addSize(StringUtils.addBold("主要获得途径"),14),"#FFF000");
			tipSutra = tipSutra + "\n\n" + StringUtils.addColor("* 竞技场日常获得\n","0xFFFFFF") + StringUtils.addColor("* 竞技场排名奖励\n","0xFFFFFF") + StringUtils.addColor("* 完成重要主线任务\n","0xFFFFFF");
			tipSutra = tipSutra + StringUtils.addColor("* 参加仙龟拜佛\n","0xFFFFFF") + StringUtils.addColor("* 每日开天斧捐献\n","0xFFFFFF") + StringUtils.addColor("* 家族品茶活动\n","0xFFFFFF") + StringUtils.addColor("* 家族进献活动\n","0xFFFFFF");
			ToolTipManager.instance.registerToolTip(sp, WordWrapToolTip, tipSutra);
		}

		public function refreshData(sutra : Sutra) : void {
			clearTimeout(setID1);
			clearTimeout(setID2);
			clearTimeout(setID3);
			clearTimeout(setID4);
			clearTimeout(setID5);
			if (sutraStep)
				if (sutraStep.id == sutra.id){
					totalCultivation.text = String(UserData.instance.profExp);
					setNeedCultivation();
					 return;
				}
			sutraStep = sutra;
			if (weapMC != null)
				clearnWeapMC();
			setWeap();
			totalCultivation.text = String(UserData.instance.profExp);
			setNeedCultivation();
			backPro();
			runesEvent(false);
		}

		private function setNeedCultivation() : void {
			if (UserData.instance.profExp < sutraStep.nextSetpExp)
				needCultivation.textColor = 0xBD0000;
			else
				needCultivation.textColor = 0xFFFFFF;
			needCultivation.text = String(sutraStep.nextSetpExp);
			needCultivation.num = sutraStep.nextSetpExp;

			var hero : VoHero = UserData.instance.myHero;
			var upStepLine : int;
			if (hero.config.sutraUp < FunManage.instance.getSutraUp(hero.level))
				upStepLine = hero.config.sutraUp;
			else
				upStepLine = FunManage.instance.getSutraUp(hero.level);

			if (sutraStep.step == upStepLine) {
				submintText.visible = true;
				submitBtn.visible = false;
				needtext.visible = false;
				needCultivation.visible = false;
				bg.item2.visible = false;
				var str : String ;
				if (FunManage.instance.getSutraLeve(sutraStep.step + 1) != -1)
					str = "等级达到" + FunManage.instance.getSutraLeve(sutraStep.step + 1) + "级可升阶";
				else
					str = "法宝阶数已达上线";
				submintText.text = StringUtils.addColor(str, "#FFFF00");
				return;
			} else {
				submintText.visible = false;
				submitBtn.visible = true;
				needtext.visible = true;
				needCultivation.visible = true;
				bg.item2.visible = true;
			}
			//
			if (sutraStep.step == sutraStep.hero.config.sutraUp) {
				submintText.visible = true;
				submitBtn.visible = false;
				needtext.visible = false;
				needCultivation.visible = false;
				bg.item2.visible = false;
				submintText.text = StringUtils.addColor("法宝阶数已达上线", "#FFFF00");
			} else {
				submintText.visible = false;
				submitBtn.visible = true;
				needtext.visible = true;
				needCultivation.visible = true;
				bg.item2.visible = true;
			}
		}
		private var setID1:uint = 0;
		private var setID2:uint = 0;
		private var setID3:uint = 0;
		private var setID4:uint = 0;
		private var setID5:uint = 0;
		public function upLevelSutra(sutra : Sutra) : void {
			sutraStep = sutra;
			runesEvent(true);
			if (sutraStep.step == 0) {
				setWeap();
				totalCultivation.text = String(UserData.instance.profExp);
				setNeedCultivation();
				backPro();
				return;
			}
			totalCultivation.setMagicText(String(UserData.instance.profExp), UserData.instance.profExp);
			needCultivation.setMagicText(String(sutraStep.nextSetpExp), sutraStep.nextSetpExp);
			setWeap();
			upLevel();
			backPro();
			setNeedCultivation();
			
			var item1 : SutraSkillItem = SutraManager.instance.getMardsData(sutra.hero.id, 1);
			var item2 : SutraSkillItem = SutraManager.instance.getMardsData(sutra.hero.id, 2);
			if (sutra.step == item1.openStep) {
				setID1 = setTimeout(baokai11, 700);
			}
			if (sutra.step == item2.openStep) {
				setID2 = setTimeout(baokai12, 700);
			}
			setID3 = setTimeout(isChangeColor, 700);
			
		}

		private function baokai11() : void {
			baokai1.visible = true;
			baokai1.gotoAndPlay(2);
		}

		private function baokai12() : void {
			baokai2.visible = true;
			baokai2.gotoAndPlay(2);
		}

		private function isChangeColor() : void {
			if (UserData.instance.profExp < sutraStep.nextSetpExp) {
				needCultivation.textColor = 0xBD0000;
			}
		}

		private function addButtn() : void {
			var data : GButtonData = new KTButtonData();
			data.labelData.text = "升阶";
			data.x = 156;
			data.y = 355;
			submitBtn = new GButton(data);
			submitBtn.width = 80;
			this.addChild(submitBtn);
		}

		private var iconMc : Sprite;
		private var bg : MovieClip;
		private var baokai1 : MovieClip;
		private var baokai2 : MovieClip;

		private function addBG() : void {
			bg = RESManager.getMC(new AssetData("sutraBg", "sutraSwf"));
			addChild(bg);
			iconMc = UIManager.getUI(new AssetData("sutraGourd", "sutraSwf"));
			iconMc.x = 10;
			iconMc.y = 3;
			addChild(iconMc);

			runesBtn1 = RESManager.getMC(new AssetData("RunesBtn1", "sutraSwf"));
			runesBtn2 = RESManager.getMC(new AssetData("RunesBtn2", "sutraSwf"));
			baokai1 = RESManager.getMC(new AssetData("baokai", "sutraSwf"));
			baokai2 = RESManager.getMC(new AssetData("baokai", "sutraSwf"));
			baokai1.x = 136;
			baokai1.y = 276 + 17;
			baokai1.gotoAndStop(1);
			baokai1.visible = false;
			baokai1.mouseChildren = false;
			baokai1.mouseEnabled = false;

			baokai2.x = 242 + 16;
			baokai2.y = 276 + 17;
			baokai2.mouseChildren = false;
			baokai2.mouseEnabled = false;
			baokai2.gotoAndStop(1);
			baokai2.visible = false;
			runesBtn1.x = 120;
			runesBtn1.y = 276;
			addChild(runesBtn1);
			runesBtn2.x = 242;
			runesBtn2.y = 276;
			addChild(runesBtn2);
			runesBtn1.visible = false;
			runesBtn2.visible = false;
			this.addChild(baokai2);
			this.addChild(baokai1);
		}

		// 取回修为tips
		private function backPro() : void {
			if (sutraStep.step > 4) {
				backProf.visible = true;
				ToolTipManager.instance.registerToolTip(backProf, WordWrapToolTip, ("可取回" + StringUtils.addColor(String((sutraStep.totalExpSetp) * 0.9) + "修为", "#FFFF00") + "\n返还注入修为的" + StringUtils.addColor("90%", "#FFFF00") + "\n取回后法宝阶数降至" + StringUtils.addColor("0", "#FFFF00") + "阶"));
			} else {
				backProf.visible = false;
			}
		}

		// 更改法宝图片
		public function changeIMG() : void {
		}

		override public function get source() : * {
			return this.sutraStep;
		}

		private var weapName : String;

		public function setWeap() : void {
			// ToolTipManager.instance.registerToolTip(weapMC.mc, WordWrapToolTip, sutraStep.story);
			if (weapName == String(sutraStep.id) && weapMC != null) {
				ToolTipManager.instance.registerToolTip(weapMC.mc, WordWrapToolTip, sutraStep.sutraTips);
				return;
			}
			weapName = String(sutraStep.id);
			RESManager.instance.load(new LibData(StaticConfig.cdnRoot + "assets/weapMC/" + weapName + ".swf", weapName), initDieFrame);
		}

		private function initDieFrame() : void {
			if (weapMC != null)
				clearnWeapMC();
			if (RESManager.getMC(new AssetData("fabao", weapName)) == null) return;
			weapMC = RESManager.getMC(new AssetData("fabao", weapName));
			weapMC.x = 85;
			weapMC.y = 0;
			this.addChild(weapMC);
			ToolTipManager.instance.registerToolTip(weapMC.mc, WordWrapToolTip, sutraStep.sutraTips);
			addChild(runesBtn1);
			addChild(runesBtn2);
			this.addChild(baokai2);
			this.addChild(baokai1);
		}

		private function upLevel() : void {
			weapMC.gotoAndPlay(2);
		}

		public function clearnWeapMC() : void {
			RESManager.instance.remove(weapName);
			this.removeChild(weapMC);
			weapMC = null;
		}

		private static var _demonCopyName : TextFormat;

		public static function get backProfStr() : TextFormat {
			if (_demonCopyName) return _demonCopyName;
			var textFormat : TextFormat = new TextFormat();
			// textFormat.font = "STXinwei";
			textFormat.color = 0xFFFFFF;
			textFormat.size = 12;
			textFormat.leading = 0;
			textFormat.align = TextFormatAlign.CENTER;
			_demonCopyName = textFormat;
			return _demonCopyName;
		}

		// =====================
		// 符文
		// =====================
		private var runes : int = 0;

		private function runesEvent(open:Boolean) : void {
			var namestr : String;
			var runster : String ;
			var item1 : SutraSkillItem = SutraManager.instance.getMardsData(sutraStep.hero.id, 1);
			var item2 : SutraSkillItem = SutraManager.instance.getMardsData(sutraStep.hero.id, 2);
			runes = sutraStep.runetotemID;
			if (sutraStep.getIsOpenRunet(1)) {
				namestr = SutraManager.instance.getMardsData(sutraStep.hero.id, 1).runetotemName;
				runster = StringUtils.addColor("符印：" + namestr + "\n", "#FFFF00") + SutraManager.instance.getMardsData(sutraStep.hero.id, 1).runetotem;
				runster = runster + "\n\n" + StringUtils.addColor("同时只能激活一种符印", "#999999");
				ToolTipManager.instance.registerToolTip(runesBtn1, WordWrapToolTip, runster);
				runesBtn1.gotoAndStop(1);
				if (sutraStep.step == item1.openStep && open)
					setID5 = setTimeout(runes1, 700);
				else
					runesBtn1.visible = true;
				runesBtn1.addEventListener(MouseEvent.MOUSE_OVER, onRunes1Over);
				runesBtn1.addEventListener(MouseEvent.MOUSE_OUT, onRunes1Out);
				runesBtn1.addEventListener(MouseEvent.MOUSE_DOWN, onrunes1Down);
			} else {
				runesBtn1.visible = false;
				runesBtn1.removeEventListener(MouseEvent.MOUSE_DOWN, onrunes1Down);
				runesBtn1.removeEventListener(MouseEvent.MOUSE_OVER, onRunes1Over);
				runesBtn1.removeEventListener(MouseEvent.MOUSE_OUT, onRunes1Out);
			}
			if (sutraStep.getIsOpenRunet(2)) {
				namestr = SutraManager.instance.getMardsData(sutraStep.hero.id, 2).runetotemName;
				runster = StringUtils.addColor("符印：" + namestr + "\n", "#FFFF00") + SutraManager.instance.getMardsData(sutraStep.hero.id, 2).runetotem;
				runster = runster + "\n\n" + StringUtils.addColor("同时只能激活一种符印", "#999999");
				ToolTipManager.instance.registerToolTip(runesBtn2, WordWrapToolTip, runster);
				runesBtn2.gotoAndStop(1);
				if (sutraStep.step == item2.openStep && open)
					setID4 = setTimeout(runes2, 700);
				else
					runesBtn2.visible = true;
				runesBtn2.addEventListener(MouseEvent.MOUSE_OVER, onRunes2Over);
				runesBtn2.addEventListener(MouseEvent.MOUSE_OUT, onRunes2Out);
				runesBtn2.addEventListener(MouseEvent.MOUSE_DOWN, onrunes2Down);
			} else {
				runesBtn2.visible = false;
				runesBtn2.removeEventListener(MouseEvent.MOUSE_OVER, onRunes2Over);
				runesBtn2.removeEventListener(MouseEvent.MOUSE_OUT, onRunes2Out);
				runesBtn2.removeEventListener(MouseEvent.MOUSE_DOWN, onrunes2Down);
			}

			if (runes != 0) {
				if (runes == 1)
					runesBtn1.gotoAndStop(3);
				else
					runesBtn2.gotoAndStop(3);
			}
		}

		private function runes1() : void {
			runesBtn1.visible = true;
		}
		
		private function runes2() : void {
			runesBtn2.visible = true;
		}

		private function onrunes2Down(event : MouseEvent) : void {
			if (runes == 2) return;
			var cmd : CSSwitchSkill = new CSSwitchSkill();
			cmd.heroID = sutraStep.hero.id;
			cmd.skillID = 2;
			Common.game_server.sendMessage(0x1B, cmd);
		}

		private function onrunes1Down(event : MouseEvent) : void {
			if (runes == 1) return;
			var cmd : CSSwitchSkill = new CSSwitchSkill();
			cmd.heroID = sutraStep.hero.id;
			cmd.skillID = 1;
			Common.game_server.sendMessage(0x1B, cmd);
		}

		private function onRunes2Out(event : MouseEvent) : void {
			if (runes != 2)
				runesBtn2.gotoAndStop(1);
		}

		private function onRunes2Over(event : MouseEvent) : void {
			if (runes != 2)
				runesBtn2.gotoAndStop(2);
		}

		private function onRunes1Out(event : MouseEvent) : void {
			if (runes != 1)
				runesBtn1.gotoAndStop(1);
		}

		private function onRunes1Over(event : MouseEvent) : void {
			if (runes != 1)
				runesBtn1.gotoAndStop(2);
		}

		override public function hide() : void {
			super.hide();
			removeEvent();
		}

		override public function show() : void {
			super.show();
			initEvent();
		}
	}
}
