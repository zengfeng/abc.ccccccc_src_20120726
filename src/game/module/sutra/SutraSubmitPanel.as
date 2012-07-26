package game.module.sutra {
	import game.core.item.functionItem.FunManage;
	import game.core.item.sutra.Sutra;
	import game.core.item.sutra.sutraSkill.SutraManager;
	import game.core.prop.PropManager;

	import gameui.controls.GLabel;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GLabelData;

	import net.AssetData;
	import net.RESManager;

	import com.commUI.tooltip.ToolTipManager;
	import com.commUI.tooltip.WordWrapToolTip;
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * @author Lv
	 */
	public class SutraSubmitPanel extends GComponent {
		private var sutraLine : Bitmap;
		private var sutraName : TextField;
		private var sutraStep : TextField;
		private var heroName : GLabel;
		private var skillName : GLabel;
		private var arrow : MovieClip;
		private var itemdown : TextitemDown;
		private var sutra : Sutra;
		private var textItemVec : Vector.<TextItem> = new Vector.<TextItem>();
		private var textItemDic : Dictionary = new Dictionary();

		public function SutraSubmitPanel() {
			_base = new GComponentData();
			initData();
			super(_base);
			initView();
			initEvent();
		}

		private function initData() : void {
			_base.width = 185;
			_base.height = 338;
			// 取消背景
		}

		private function initEvent() : void {
			skillName.addEventListener(MouseEvent.MOUSE_OVER, onOverSkillName);
		}

		private function onOverSkillName(event : MouseEvent) : void {
			hideArrow();
		}

		private function initView() : void {
			addBG();
			showpanel();
			// addText(1);
			addRunet();
		}

		public function refreshData(nowSutra : Sutra) : void {
			TweenLite.killTweensOf(runesBtn1);
			TweenLite.killTweensOf(runesBtn2);
			ShowHarmComplete_func();
			sutra = nowSutra;
			ToolTipManager.instance.registerToolTip(skillName, WordWrapToolTip, sutra.sutraTips);
			clearItemVec();
			refreshItemVec();
			refreshText();
			hideArrow();
			if (sutra.stepEffect != "") {
				isShowRunet(true);
			}
		}

		public function weapUpLevel(upSutra : Sutra) : void {
			sutra = upSutra;
			ToolTipManager.instance.registerToolTip(skillName, WordWrapToolTip, sutra.sutraTips);
			if (sutra.step == 0) {
				clearItemVec();
				refreshItemVec();
				refreshText();
				hideArrow();
				return;
			}
			refreshItemVec();
			refreshText();
			if (sutra.getstepNowSkillChange == true) {
				palyerArrow();
			} else {
				hideArrow();
			}
			
			if (sutra.stepEffect != "") {
				isShowRunet(true);
				return;
			}
			if (runesBtn1.visible == true || runesBtn2.visible == true)
				runetFly();
		}

		// 符文改变
		public function runtesSubmitChange() : void {
			ToolTipManager.instance.registerToolTip(skillName, WordWrapToolTip, sutra.sutraTips);
		}

		private function refreshText() : void {
			sutraName.htmlText = sutra.name;
			if (sutra.step == 0)
				sutraStep.visible = false;
			else
				sutraStep.visible = true;
			sutraStep.htmlText = sutra.step + "阶";
			heroName.text = sutra.hero.htmlName;
			skillName.text = StringUtils.addLine(StringUtils.addColorById(sutra.skill, sutra.hero.color));
		}

		private function refreshItemVec() : void {
			var item : TextItem ;
			var max : int = sutra.getNowPropKye.length;
			for (var i : int = 0; i < max;i++) {
				var key : String = sutra.getNowPropKye[i];
				var nameStr : String = PropManager.instance.getPropByKey(key).name;
				var value : Number = sutra.stepProp[key];
				if (key == "act_add")
					value = value + sutra.prop["act_add"];
				if(key == "magic_per")continue;
				if (textItemDic[key]) {
					var oldItem : TextItem = textItemDic[key] as TextItem;
					var str : String = String(value);
					if(PropManager.instance.getPropByKey(key) != null){
						if(PropManager.instance.getPropByKey(key).per == 1){
							str = str + "%";
						}
					}
					if (oldItem.getValueStr.text != str)
						oldItem.getValueStr.setMagicText(str, value);
					oldItem.x = 50;
					oldItem.y = 115 + oldItem.height * i;
				} else {
					var str1 : String = String(value);
					if(PropManager.instance.getPropByKey(key) != null){
						if(PropManager.instance.getPropByKey(key).per == 1){
							str1 = str1 + "%";
						}
					}
					item = new TextItem(nameStr, str1, true);
					item.x = 50;
					item.y = 115 + item.height * i;
					this.addChild(item);
					textItemVec.push(item);
					textItemDic[key] = item;
				}
			}
			changeItem();
		}

		private function changeItem() : void {
			if (sutra.step == 0)
				setItemVec();

			// =====================
			// 调整分割线
			// =====================
			var index : Number = textItemVec.length ;
			if (textItemVec.length == 0) {
				sutraLine.y = 120;
			} else {
				sutraLine.y = 115 + textItemVec[0].height * index + 10;
			}
			// =====================
			// 下一阶效果
			itemdown.y = sutraLine.y + sutraLine.height + 10;
			countData();
		}

		private function setItemVec() : void {
			var item : TextItem ;
			var max : int = sutra.propKey.length;
			for (var i : int = 0; i < max;i++) {
				var key : String = sutra.propKey[i];
				var nameStr : String = PropManager.instance.getPropByKey(key).name;
				var value : Number = sutra.prop[key];
				item = new TextItem(nameStr, String(value), true);
				item.x = 50;
				item.y = 115 + item.height * i;
				textItemDic[key] = item;
				this.addChild(item);
				textItemVec.push(item);
			}
		}

		private function countData() : void {
			itemdown.visible = true;
			if (FunManage.instance.getSutraLeve(sutra.step + 1) == -1) {
				itemdown.visible = false;
				return;
			}
			if (sutra.step == sutra.hero.config.sutraUp) {
				itemdown.visible = false;
				return;
			}
			if(sutra.nextStepProp == null){
				itemdown.visible = false;
				return;
			}
			if (sutra.stepEffect != "") {
				itemdown.setIitem(sutra.stepEffect);
//				isShowRunet(true);
				return;
			}
//			if (runesBtn1.visible == true || runesBtn2.visible == true)
//				runetFly();
			var str : String = "";
			var key : String = sutra.getDeltaPropKey[0];
			if (key == null) {
				itemdown.setIitem("Effect 不存在");
				return;
			}
			var nameStr : String = PropManager.instance.getPropByKey(key).name;
			var value : Number = sutra.nextStepProp[key];
			if (key == "act_add")
				value = value + sutra.prop["act_add"];
			str = nameStr + "提升至 " + value;
			if(PropManager.instance.getPropByKey(key) != null){
				if(PropManager.instance.getPropByKey(key).per == 1){
					str = str + "%";
				}
			}
			itemdown.setIitem(str);
		}

		// =======================================================================================================
		//
		// 符印飞行控制
		//
		// ========================================================================================================
		/** 符印出现 **/
		private function isShowRunet(runet : Boolean) : void {
			var namestr : String;
			var runster : String ;
			if (!runet) {
				runesBtn1.visible = false;
				runesBtn2.visible = false;
			} else {
				if (sutra.nextOpenRunet == 1) {
					runesBtn1.visible = true;
					runesBtn1.x = 13;
					runesBtn1.y = itemdown.y + 20;
					namestr = SutraManager.instance.getMardsData(sutra.hero.id, 1).runetotemName;
					runster = StringUtils.addColor("符印：" + namestr + "\n", "#FFFF00") + SutraManager.instance.getMardsData(sutra.hero.id, 1).runetotem;
					runster = runster + "\n\n" + StringUtils.addColor("同时只能激活一种符印", "#999999");
					ToolTipManager.instance.registerToolTip(runesBtn1, WordWrapToolTip, runster);
				} else if (sutra.nextOpenRunet == 2) {
					runesBtn2.visible = true;
					runesBtn2.x = 13;
					runesBtn2.y = itemdown.y + 20;
					namestr = SutraManager.instance.getMardsData(sutra.hero.id, 2).runetotemName;
					runster = StringUtils.addColor("符印：" + namestr + "\n", "#FFFF00") + SutraManager.instance.getMardsData(sutra.hero.id, 2).runetotem;
					runster = runster + "\n\n" + StringUtils.addColor("同时只能激活一种符印", "#999999");
					ToolTipManager.instance.registerToolTip(runesBtn2, WordWrapToolTip, runster);
				} else {
					runesBtn1.visible = false;
					runesBtn2.visible = false;
				}
			}
		}
		private var twen1:TweenLite;
		private var twen2:TweenLite;
		private function runetFly() : void {
			if (runesBtn1.visible == true)
				TweenLite.to(runesBtn1, 0.8, {x:runes1ComparativelyPot.x, y:runes1ComparativelyPot.y, ease:Circ.easeIn, overwrite:0.5, onComplete:ShowHarmComplete_func});
			else if (runesBtn2.visible == true)
				TweenLite.to(runesBtn2, 0.8, {x:runes2ComparativelyPot.x, y:runes2ComparativelyPot.y, ease:Circ.easeIn, overwrite:0.5, onComplete:ShowHarmComplete_func});
		}

		public function ShowHarmComplete_func() : void {
			runesBtn1.visible = false;
			runesBtn2.visible = false;
		}

		private var runesBtn1 : MovieClip;
		private var runesBtn2 : MovieClip;
		private var runes1ComparativelyPot : Point = new Point(-235, 258);
		private var runes2ComparativelyPot : Point = new Point(-113, 258);

		/** 添加符印 **/
		private function addRunet() : void {
			runesBtn1 = RESManager.getMC(new AssetData("RunesBtn1", "sutraSwf"));
			runesBtn2 = RESManager.getMC(new AssetData("RunesBtn2", "sutraSwf"));
			addChild(runesBtn1);
			addChild(runesBtn2);
			runesBtn1.visible = false;
			runesBtn2.visible = false;
		}

		// ========================================================================================================
		private function clearItemVec() : void {
			while (textItemVec.length > 0) {
				this.removeChild(textItemVec[0]);
				textItemVec.splice(0, 1);
			}
			for (var K:String in textItemDic) {
				delete textItemDic[K];
			}
		}

		private function showpanel() : void {
			sutraName = new TextField();
			sutraName.defaultTextFormat = TextFormatUtils.demonCopyName;
			sutraName.filters = [new DropShadowFilter(0, 45, 0x000000, 1, 5, 5, 2)];
			sutraName.htmlText = "法宝名字";
			sutraName.width = 120;
			sutraName.mouseEnabled = false;
			this.addChild(sutraName);
			sutraStep = new TextField();
			sutraStep.defaultTextFormat = TextFormatUtils.demonCopyName;
			sutraStep.filters = [new DropShadowFilter(0, 45, 0x000000, 1, 5, 5, 2)];
			sutraStep.htmlText = "52阶";
			sutraStep.mouseEnabled = false;
			this.addChild(sutraStep);

			var data : GLabelData = new GLabelData();
			data.textFieldFilters = [];
			data.text = "所属名仙：";
			var name : GLabel = new GLabel(data);
			data.clone();
			data.text = "将领名字";
			heroName = new GLabel(data);
			data.clone();
			data.text = "法宝技能：";
			var skillN : GLabel = new GLabel(data);
			data.clone();
			data.text = StringUtils.addLine("技能技能");
			skillName = new GLabel(data);
			data.clone();
			data.text = "法宝属性：";
			var sutrPop : GLabel = new GLabel(data);

			sutraName.x = 5;
			sutraName.y = 16;
			sutraStep.x = 100;
			sutraStep.y = 16;
			this.addChild(name);
			name.x = 13;
			name.y = 48;
			this.addChild(heroName);
			heroName.x = 90;
			heroName.y = 48;
			this.addChild(skillN);
			skillN.x = 13;
			skillN.y = 70;
			this.addChild(skillName);
			skillName.x = 90;
			skillName.y = 70;
			this.addChild(sutrPop);
			sutrPop.x = 13;
			sutrPop.y = 92;

			itemdown = new TextitemDown();
			this.addChild(itemdown);
		}

		private function addBG() : void {
			var bg : Bitmap = new Bitmap(RESManager.getBitmapData(new AssetData("sutraRight", "sutraSwf")));
			addChild(bg);
			sutraLine = new Bitmap(RESManager.getBitmapData(new AssetData("sutraLine", "sutraSwf")));
			addChild(sutraLine);

			arrow = RESManager.getMC(new AssetData("sutraArrow", "sutraSwf"));
			arrow.y = 20;
			arrow.x = 60;
			this.addChild(arrow);
		}

		private function hideArrow() : void {
			arrow.visible = false;
		}

		private function showArrow() : void {
			arrow.visible = true;
			arrow.gotoAndPlay(70);
		}

		private function palyerArrow() : void {
			arrow.visible = true;
			arrow.gotoAndPlay(2);
		}
	}
}
import gameui.controls.GLabel;
import gameui.controls.GMagicLable;
import gameui.data.GLabelData;

import flash.display.Sprite;

class TextItem extends Sprite {
	private var nameStr : GLabel;
	private var valueStr : GMagicLable;

	public function TextItem(nameS : String, value : String, boo : Boolean) : void {
		init();
		nameStr.text = nameS;
		if (!boo)
			valueStr.visible = false;
		else
			valueStr.visible = true;
		valueStr.text = value;
	}

	private function init() : void {
		var data : GLabelData = new GLabelData();
		data.textColor = 0xFFFF99;
		data.width = 120;
		nameStr = new GLabel(data);
		data.clone();
		data.x = 48;
		valueStr = new GMagicLable(data);
		this.addChild(nameStr);
		this.addChild(valueStr);
	}

	public function get getValueStr() : GMagicLable {
		return valueStr;
	}

	public function set setValueStr(valueStr : GMagicLable) : void {
		this.valueStr = valueStr;
	}

	public function getNameStr() : void {
		nameStr.width = 130;
	}
}
class TextitemDown extends Sprite {
	private var itemVec : Vector.<TextItem> = new Vector.<TextItem>();
	private var names : GLabel;

	public function TextitemDown() : void {
		var data : GLabelData = new GLabelData();
		data.text = "下一阶的效果：";
		names = new GLabel(data);
		this.addChild(names);
		names.x = 13;
	}

	public function setIitem(itemStr : String) : void {
		if (itemVec.length > 0) clearVecItem();
		for (var i : int = 0; i < 1; i++) {
			itemVec[i] = new TextItem(itemStr, "", false);
			this.addChild(itemVec[i]);
			itemVec[i].y = 22 + itemVec[i].height * i;
			itemVec[i].x = 50;
		}
	}

	private function clearVecItem() : void {
		while (itemVec.length > 0) {
			this.removeChild(itemVec[0]);
			itemVec.splice(0, 1);
		}
	}
}

