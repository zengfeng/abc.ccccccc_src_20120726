package game.module.formation.centralPanel {
	import game.core.avatar.AvatarMySelf;
	import game.core.hero.VoHero;

	import worlds.apis.MSelfPlayer;

	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.utils.StringUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;

	import game.core.avatar.AvatarType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.module.formation.FMControlPoxy;
	import game.module.formation.FMControler;
	import game.module.formation.drageAvatear.FMDrageAvatar;
	import game.module.formation.drageAvatear.FMReceiveAvatar;
	import game.module.formation.formationManage.FMManager;
	import game.module.formation.formationManage.VoFM;
	import game.net.core.Common;
	import game.net.data.CtoS.CSSetSquad;

	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	import net.RESManager;

	/**
	 * @author Lv
	 */
	public class CentralPanel extends GPanel {
		private var fmVec : Vector.<MovieClip> = new Vector.<MovieClip>();
		private var fmName : GLabel;
		private var fmLevel : GLabel;
		private var fmEffect : GLabel;
		private var fmEyeEffect : GLabel;
		private var promptText : GLabel;
		private var saveHeroDic : Dictionary = new Dictionary();

		public function CentralPanel() {
			_data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 351;
			_data.height = 322;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
		}

		private function initEvent() : void {
		}

		private function initView() : void {
			addDrageBG();
			addBG();
		}

		private var drage : DrageItem ;

		private function addDrageBG() : void {
			var bg : Sprite = UIManager.getUI(new AssetData("formationBG0", "FMSwf"));
			_content.addChild(bg);
			drage = new DrageItem();
			_content.addChild(drage);
			drage.addEventListener(MouseEvent.MOUSE_UP, onStageUp);
		}

		private function onStageUp(event : MouseEvent) : void {
			startMovePoint = -1;
			endMovePoint = -1;
		}

		private function addBG() : void {
			var data : GLabelData = new GLabelData();
			data.text = "四方金刚阵";
			data.textColor = 0x2F1F00;
			data.textFormat.size = 14;
			data.textFieldFilters = [];
			data.x = 23;
			data.y = 5;
			fmName = new GLabel(data);
			_content.addChild(fmName);
			data.clone();
			data.textFormat.size = 12;
			data.text = "10级";
			data.x = 103;
			fmLevel = new GLabel(data);
			_content.addChild(fmLevel);
			data.clone();
			data.width = 300;
			data.text = "阵型效果：增加队伍暴击伤害";
			data.y = fmName.y + fmName.height + 2;
			data.x = 23;
			fmEffect = new GLabel(data);
			_content.addChild(fmEffect);
			data.text = "阵眼效果：初始聚气增加40点";
			data.y = fmEffect.y + fmEffect.height + 2;
			fmEyeEffect = new GLabel(data);
			_content.addChild(fmEyeEffect);
			data.clone();
			data.text = "2级阵型可布置5人";
			data.y = 300 - 3;
			data.x = 246;
			data.width = 150;
			data.textFormat = new TextFormat("12", null, null, null, null, null, null, null, TextFormatAlign.RIGHT);
			promptText = new GLabel(data);
			_content.addChild(promptText);
			promptText.visible = false;
		}

		private var nowHeroFmVec : Vector.<Object>;

		// 刷新阵型面板
		public function loaderFormation(index : int = 12) : void {
			if (FMControlPoxy.saveAllFMDic[index] == null) return;
			if (fmVec.length > 0) clearnVec();
			FMControlPoxy.startFmK = index;
			nowHeroFmVec = FMControlPoxy.saveAllFMDic[index];
			var vo : VoFM = FMManager.formationKindsDic[index];
			fmName.text = StringUtils.addBold(vo.fm_name);
			if (vo.fm_level == 10)
				fmLevel.text = String(vo.fm_level) + "级(已满级)";
			else
				fmLevel.text = String(vo.fm_level) + "级";
			var max : int;
			var formationMC : MovieClip;
			var pointVec : Vector.<Point>;
			if (vo.fm_level > 1) {
				max = vo.fm_Point2Vec.length;
				pointVec = vo.fm_Point2Vec;
			} else {
				max = vo.fm_Point1Vec.length;
				pointVec = vo.fm_Point1Vec;
			}
			for (var i : int = 0; i < max;i++) {
				formationMC = RESManager.getMC(new AssetData("formationBG", "FMSwf"));
				formationMC.x = pointVec[i].x;
				formationMC.y = pointVec[i].y;
				_content.addChild(formationMC);
				if ((vo.fm_level == 1) && (vo.fm_frameArr[i] == 3)) {
					formationMC.gotoAndStop(2);
				} else {
					formationMC.gotoAndStop(vo.fm_frameArr[i]);
				}
				fmVec.push(formationMC);
			}
			if (vo.fm_level == 1) {
				promptText.visible = true;
				fmEyeEffect.visible = false;
			} else {
				promptText.visible = false;
				fmEyeEffect.visible = true;
				fmEyeEffect.text = "阵眼效果：" + vo.fm_eyeEffEct;
			}
			fmEffect.text = "阵型效果：" + vo.fm_Effect;
			addMaskSp();
			setheroFm();
		}

		// 设置阵型上的将领  Avatar放置
		private var myHero : FMDrageAvatar;

		private function setheroFm() : void {
			clearnPlayerVec();
			var max : int = nowHeroFmVec.length;
			for (var i : int = 0;i < max; i++) {
				var obj : Object = nowHeroFmVec[i];
				var id : int = obj["id"];
				var pos : int = obj["pos"];
				var player : FMDrageAvatar = new FMDrageAvatar();
				player.identifyPath = 2;
				player.isWaring = 1;
				player.step = pos;
				player.initAvatar(id, AvatarType.PLAYER_BATT_BACK, 0);
				var dx : int = fmVec[pos].x + 51;
				var dy : int = fmVec[pos].y + 70;
				player.scaleY = player.scaleX = 0.6;
				player.x = dx;
				player.y = dy;
				_content.addChild(player);
				if (id == UserData.instance.myHero.id)
					myHero = player;
				saveHeroDic[pos] = player;
				maskSpVec[pos].isDrag = true;
				maskSpVec[pos].heroID = id;
				player.addEventListener(MouseEvent.MOUSE_DOWN, palyerDown);
				player.addEventListener(MouseEvent.MOUSE_UP, playerUP);
			}
			for each (var item:FMReceiveAvatar in maskSpVec) {
				_content.addChild(item);
			}
			revisionLayer();
			if (myHero)
				myHero.changeCloth(UserData.instance.myHero.cloth);
			MSelfPlayer.sChangeCloth.add(changeCloth);
		}

		private function changeCloth(clothId : int) : void {
			if (myHero)
				myHero.changeCloth(clothId);
		}

		private function playerUP(event : MouseEvent) : void {
			startMovePoint = -1;
			endMovePoint = -1;
		}

		private function clearnPlayerVec() : void {
			for (var K:String in saveHeroDic) {
				var hero : FMDrageAvatar = saveHeroDic[K];
				hero.removeEventListener(MouseEvent.MOUSE_DOWN, palyerDown);
				hero.removeEventListener(MouseEvent.MOUSE_UP, playerUP);
				_content.removeChild(saveHeroDic[K]);
				delete saveHeroDic[K];
			}
		}

		private function palyerDown(event : MouseEvent) : void {
			var palyer : FMDrageAvatar = event.currentTarget as FMDrageAvatar;
			for each (var obj:Object in nowHeroFmVec) {
				var id : int = palyer.heroID;
				if (id == obj["id"]) {
					startMovePoint = obj["pos"];
					palyer.stateDrag();
					return;
				}
			}
		}

		// 删除在阵将领
		public function deleteInFmHero() : void {
			if (!saveHeroDic[startMovePoint] || !_content.contains(saveHeroDic[startMovePoint])) return;
			_content.removeChild(saveHeroDic[startMovePoint]);
			delete saveHeroDic[startMovePoint];
			maskSpVec[startMovePoint].isDrag = false;
			maskSpVec[startMovePoint].heroID = 0;
			FMControlPoxy.instance.outNowHeroWaring(startMovePoint);
			startMovePoint = -1;
		}

		// 清空start位置
		public function clearnStartStep() : void {
			if (startMovePoint < 0) return;
			maskSpVec[startMovePoint].heroID = 0;
			maskSpVec[startMovePoint].isDrag = false;
			startMovePoint = -1;
		}

		// 交换删除在阵将领
		public function changeDeleteInFmHero() : void {
			if (endMovePoint == -1) return;
			if (saveHeroDic[endMovePoint] == null) return;
			if ((saveHeroDic[endMovePoint] as FMDrageAvatar).heroID == UserData.instance.myHero.id) {
				StateManager.instance.checkMsg(279);
				return;
			}
			var id : int = (saveHeroDic[endMovePoint] as FMDrageAvatar).heroID;
			FMControler.instance.changeWaringStateLeft(id);
			var hero : FMDrageAvatar = saveHeroDic[endMovePoint];
			hero.removeEventListener(MouseEvent.MOUSE_DOWN, palyerDown);
			hero.removeEventListener(MouseEvent.MOUSE_UP, playerUP);
			_content.removeChild(saveHeroDic[endMovePoint]);
			delete saveHeroDic[endMovePoint];
			maskSpVec[endMovePoint].isDrag = false;
			FMControlPoxy.instance.outNowHeroWaring(endMovePoint);
		}

		// 空阵添加将领  id:将领id
		public function addToFmHero(id : int) : void {
			if (endMovePoint == -1) return;
			if (saveHeroDic[endMovePoint]) {
				if ((saveHeroDic[endMovePoint] as FMDrageAvatar).heroID == UserData.instance.myHero.id) return;
				var id1 : int = (saveHeroDic[endMovePoint] as FMDrageAvatar).heroID;
				FMControler.instance.changeWaringStateLeft(id1);
				var hero : FMDrageAvatar = saveHeroDic[endMovePoint];
				hero.removeEventListener(MouseEvent.MOUSE_DOWN, palyerDown);
				hero.removeEventListener(MouseEvent.MOUSE_UP, playerUP);
				_content.removeChild(saveHeroDic[endMovePoint]);
				maskSpVec[endMovePoint].isDrag = false;
				maskSpVec[endMovePoint].heroID = 0;
				delete saveHeroDic[endMovePoint];
			}
			var obj : Object = new Object();
			obj["id"] = id;
			obj["pos"] = endMovePoint;
			nowHeroFmVec.push(obj);
			var player : FMDrageAvatar = new FMDrageAvatar();
			player.identifyPath = 2;
			player.isWaring = 1;
			player.initAvatar(id, AvatarType.PLAYER_BATT_BACK, 0);
			var dx : int = fmVec[endMovePoint].x + 51;
			var dy : int = fmVec[endMovePoint].y + 70;
			player.scaleY = player.scaleX = 0.6;
			player.x = dx;
			player.y = dy;
			_content.addChild(player);
			player.step = endMovePoint;
			saveHeroDic[endMovePoint] = player;
			player.addEventListener(MouseEvent.MOUSE_DOWN, palyerDown);
			player.addEventListener(MouseEvent.MOUSE_UP, playerUP);
			maskSpVec[endMovePoint].isDrag = true;
			maskSpVec[endMovePoint].heroID = id;
			FMControler.instance.changeWaring(id);
			var cmd : CSSetSquad;
			cmd = new CSSetSquad();
			cmd.formation = FMControlPoxy.startFmK;
			cmd.heroId = id;
			cmd.position = endMovePoint;
			Common.game_server.sendMessage(0x1C, cmd);
			for each (var item:FMReceiveAvatar in maskSpVec) {
				_content.addChild(item);
			}
			revisionLayer();
		}

		private var maskSpVec : Vector.<FMReceiveAvatar> = new Vector.<FMReceiveAvatar>();

		// 接受点
		private function addMaskSp() : void {
			var maskSp : FMReceiveAvatar;
			var max : int = fmVec.length;
			for (var i : int = 0; i < max;i++) {
				var dx : int = fmVec[i].x + 21;
				var dy : int = fmVec[i].y + 54;
				maskSp = new FMReceiveAvatar();
				maskSp.x = dx;
				maskSp.y = dy;
				_content.addChild(maskSp);
				maskSp.isDrag = false;
				maskSpVec.push(maskSp);
				maskSp.name = "name_" + i;
				maskSp.fmstep = i;
				maskSp.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				maskSp.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				maskSp.addEventListener(MouseEvent.MOUSE_DOWN, ondonw);
				maskSp.addEventListener(MouseEvent.MOUSE_UP, onUp);
			}
		}

		private var startMovePoint : Number = -1;
		private var endMovePoint : Number = -1;
		private var isExist : Boolean;

		private function onUp(event : MouseEvent) : void {
			var index : int = event.currentTarget.name.split("_")[1];
			if (saveHeroDic[index] == null) {
				isExist = false;
			} else {
				isExist = true;
			}
			endMovePoint = index;
			if (saveHeroDic[endMovePoint] != null)
				maskSpVec[endMovePoint].heroID = (saveHeroDic[endMovePoint] as FMDrageAvatar).heroID;
			if (saveHeroDic[startMovePoint] == null) return;
			if (startMovePoint == -1) return;
			changePosition();
		}

		// 左边列表出战将领拖动调换位置
		public function leftChangeHeroStep(heroid : int) : void {
			for each (var obj:Object in nowHeroFmVec) {
				var id : int = obj["id"];
				if (id == heroid) {
					startMovePoint = obj["pos"];
				}
			}
		}

		// 改变位置
		private function changePosition() : void {
			var mc1 : FMDrageAvatar = saveHeroDic[startMovePoint];
			var cmd : CSSetSquad;
			cmd = new CSSetSquad();
			cmd.formation = FMControlPoxy.startFmK;
			cmd.heroId = mc1.heroID;
			cmd.position = endMovePoint;
			Common.game_server.sendMessage(0x1C, cmd);
			var mc2 : FMDrageAvatar ;
			var mc : MovieClip ;
			this.enabled = false;
			if (isExist) {
				mc2 = saveHeroDic[endMovePoint];
				TweenLite.to(mc1, 0.2, {x:mc2.x, y:mc2.y, ease:Expo.easeOut});
				TweenLite.to(mc2, 0.2, {x:mc1.x, y:mc1.y, ease:Expo.easeOut, onComplete:setStep});
				var start : int = maskSpVec[startMovePoint].heroID;
				var end : int = maskSpVec[endMovePoint].heroID;
				maskSpVec[endMovePoint].heroID = start;
				maskSpVec[startMovePoint].heroID = end;
			} else {
				mc = fmVec[endMovePoint];
				TweenLite.to(mc1, 0.2, {x:(mc.x + 51), y:(mc.y + 70), ease:Expo.easeOut, onComplete:setStep});
				maskSpVec[endMovePoint].heroID = maskSpVec[startMovePoint].heroID;
				maskSpVec[startMovePoint].heroID = 0;
			}
			for each (var obj:Object in nowHeroFmVec) {
				var id : int = obj["id"];
				if (mc1.heroID == id) {
					obj["pos"] = endMovePoint;
				}
				if (mc2) {
					if (mc2.heroID == id) {
						obj["pos"] = startMovePoint;
					}
				}
			}
		}

		private function setStep() : void {
			(saveHeroDic[startMovePoint] as FMDrageAvatar).step = maskSpVec[endMovePoint].fmstep;
			if ((saveHeroDic[endMovePoint] as FMDrageAvatar)) {
				(saveHeroDic[endMovePoint] as FMDrageAvatar).step = maskSpVec[startMovePoint].fmstep;
			}
			this.enabled = true;
			changeDicAvatear();
			revisionLayer();
			startMovePoint = -1;
			endMovePoint = -1;
		}

		private function changeDicAvatear() : void {
			if (isExist) {
				var avatar1 : FMDrageAvatar = saveHeroDic[startMovePoint];
				var avatar2 : FMDrageAvatar = saveHeroDic[endMovePoint];
				delete saveHeroDic[startMovePoint];
				delete saveHeroDic[endMovePoint];
				saveHeroDic[endMovePoint] = avatar1;
				saveHeroDic[startMovePoint] = avatar2;
			} else {
				var avatar : FMDrageAvatar = saveHeroDic[startMovePoint];
				saveHeroDic[endMovePoint] = avatar;
				delete saveHeroDic[startMovePoint];
				maskSpVec[endMovePoint].isDrag = true;
				maskSpVec[startMovePoint].isDrag = false;
			}
			startMovePoint = -1;
			endMovePoint = -1;
		}

		private function ondonw(event : MouseEvent) : void {
			var index : int = event.currentTarget.name.split("_")[1];
			if (saveHeroDic[index] == null) return;
			var hero : FMDrageAvatar = saveHeroDic[index];
			hero.stateDrag();
			startMovePoint = index;
		}

		private function clearnVec() : void {
			while (fmVec.length > 0) {
				_content.removeChild(fmVec[0]);
				fmVec.splice(0, 1);
			}
			while (maskSpVec.length > 0) {
				_content.removeChild(maskSpVec[0]);
				maskSpVec.splice(0, 1);
			}
			for (var K:String in saveHeroDic) {
				var hero : FMDrageAvatar = saveHeroDic[K];
				hero.removeEventListener(MouseEvent.MOUSE_DOWN, palyerDown);
				hero.removeEventListener(MouseEvent.MOUSE_UP, playerUP);
				_content.removeChild(saveHeroDic[K]);
				delete saveHeroDic[K];
			}
		}

		private function onOut(event : MouseEvent) : void {
			FMmc.FM.gotoAndStop(1);
		}

		private var FMmc : MovieClip;

		private function onOver(event : MouseEvent) : void {
			var index : int = event.currentTarget.name.split("_")[1];
			FMmc = fmVec[index];
			FMmc.FM.gotoAndStop(2);
		}

		// 调整层级关系
		private function revisionLayer() : void {
			var max : int = maskSpVec.length;
			var FMK : int = FMControlPoxy.startFmK;
			_content.addChild(drage);
			for (var i : int = 0; i < max; i++) {
				if (saveHeroDic[i] != null) {
					_content.addChild(saveHeroDic[i]);
				}
			}

			if (FMK == 13) {
				if (saveHeroDic[2] != null) {
					_content.addChild(saveHeroDic[2]);
				}
			}
			for each (var mask:FMReceiveAvatar in maskSpVec) {
				_content.addChild(mask);
			}
		}
	}
}
