package game.module.battle.view {
	import game.core.avatar.AvatarFight;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarType;
	import game.module.battle.battleData.BtStatus;
	import game.module.battle.battleData.FighterInfo;
	import game.module.battle.battleData.tipData;

	import net.RESManager;

	import com.greensock.TweenLite;
	import com.utils.PotentialColorUtils;

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;

	public class BTAvatar extends AvatarFight {
		private var _info : FighterInfo;
		private var _tipd : tipData;
		public var pos : Point = new Point();
		// 物理攻击出手时间点
		private var atkTimePhyPoint : Number = 0.4;
		// 法术攻击出手时间点
		private var atkTimeSkillPoint : Number = 0.4;
		// 物理攻击动作时间
		private var atkTimePhyatk : Number = 0.5;
		// 技能攻击动作时间
		private var atkTimeSkillatk : Number = 0.5;
		// 受挫动作时间
		private var atkTimeTrad : Number = 0.6;
		// 躲闪动作时间
		private var atkTimeevade : Number = 0.5;
		// 出击时间
		private var atkTimesally : Number = 0.2;
		// 原地出击
		private var atkTimeStand : Number = 0.1;
		// 归位时间
		private var atkTimeback : Number = 0.2;
		// 死亡动作时间
		private var atkTimeDie : Number = 0.5;
		// 技能攻击时的效果爆发时间点
		private var atkTimeSkillEfftBreak : Number = 0;
		// 攻击技能效果时间
		private var atkTimeSkillEfft : Number = 0.0;
		// hp Number相对基础偏移
		private static const hpNumberBaseOffSet : Point = new Point(20, 20);
		// 暴击，破击等在受挫方身上的效果的相对基础偏移
		private static const EffToEnemyBaseOffSet : Point = new Point(20, 20);
		// 暴击，破击等在攻击方身上的效果的相对基础偏移
		private static const EffFromMineBaseOffSet : Point = new Point(20, 20);

		public function BTAvatar(info : FighterInfo) {
			var points : Array = info.side == 0 ? BTSystem.SelfPoints : BTSystem.EnemyPoints;
			pos.x = points[info.pos][0];
			pos.y = points[info.pos][1];
			super();
			_info = info;
			this.initUUID(_info.key);
			this.setName(_info.name, PotentialColorUtils.getColorOfStr(theFighterInfo.getColor()));
			setAction(AvatarManager.BT_STAND, 0);

			var hpPercent : int = 0;
			hpPercent = Number(_info.initHp) / Number(_info.maxHp) * 100;
			if (hpPercent == 0 && _info.initHp != 0)
				hpPercent = 1;
			this.showHPBar(hpPercent);
		}

		public function getTipData() : tipData {
			return _tipd;
		}

		public function setTipData(td : tipData) : void {
			_tipd = td;
			td.playerLevel = this._info.getLevel();
			td.playerColor = this._info.getColor();
			td.playerGaugeInit = this._info.getGaugeUse();
			td.playerHPInit = this._info.maxHp;
		}

		// 物理攻击出手时间点
		public function getAtkTimePhyPoint() : Number {
			atkTimePhyPoint = avatarBd.fightData.atkTimePhyPoint;
			return atkTimePhyPoint;
		}

		public function setAtkTimePhyPoint(tm : Number) : void {
			atkTimePhyPoint = tm;
		}

		// 法术攻击出手时间点
		public function getAtkTimeSkillPoint() : Number {
			atkTimeSkillPoint = avatarBd.fightData.atkTimeSkillPoint;
			return atkTimeSkillPoint;
		}

		public function setAtkTimeSkillPoint(tm : Number) : void {
			atkTimeSkillPoint = tm;
		}

		// 物理攻击动作时间
		public function getAtkTimePhyatk() : Number {
			atkTimePhyatk = avatarBd.fightData.atkTimePhyatk;
			return atkTimePhyatk;
		}

		public function setAtkTimePhyatk(tm : Number) : void {
			atkTimePhyatk = tm;
		}

		// 技能攻击动作时间
		public function getAtkTimeSkillatk() : Number {
			atkTimeSkillatk = avatarBd.fightData.atkTimeSkillatk + 0.2;
			return atkTimeSkillatk;
		}

		public function setAtkTimeSkillatk(tm : Number) : void {
			atkTimeSkillatk = tm;
		}

		// 技能播放到触发点时间
		public function getAtkTimeSkillEfftBreak() : Number {
			var frontOrback : uint = 1;

			if (_info.getCanTurnOver() == 2) {
				frontOrback = _info.side ? 0 : 1;
			}
			if (_info.getSpellEftId() == 0)
				return 0;
			atkTimeSkillEfftBreak = AvatarManager.instance.getAvatarBD(AvatarManager.instance.getUUId(_info.getSpellEftId(), AvatarType.SKILL_TYPE_SPELL, frontOrback)).fightData.atkTimeSkillBreak;

			return atkTimeSkillEfftBreak;
		}

		// 给己方的技能播放到触发点时间
		public function getAtkTimeSkillEfftBreak2() : Number {
			var frontOrback : uint = 1;

			if (_info.getCanTurnOver() == 2) {
				frontOrback = _info.side ? 1 : 0;
			}
			atkTimeSkillEfftBreak = AvatarManager.instance.getAvatarBD(AvatarManager.instance.getUUId(_info.getSpellEftId2(), AvatarType.SKILL_TYPE_SPELL, frontOrback)).fightData.atkTimeSkillBreak;

			return atkTimeSkillEfftBreak;
		}

		public function getAtkTimeSkillEfft2() : Number {
			var frontOrback : uint = 1;

			if (_info.getCanTurnOver2() == 2) {
				frontOrback = _info.side ? 1 : 2;
			}
			atkTimeSkillEfft = AvatarManager.instance.getAvatarBD(AvatarManager.instance.getUUId(_info.getSpellEftId2(), AvatarType.SKILL_TYPE_SPELL, frontOrback)).fightData.atkTimeSkillEfft;

			return atkTimeSkillEfft;
		}

		public function getAtkTimeSkillEfft() : Number {
			var frontOrback : uint = 1;

			if (_info.getCanTurnOver() == 2) {
				frontOrback = _info.side ? 0 : 1;
			}
			atkTimeSkillEfft = AvatarManager.instance.getAvatarBD(AvatarManager.instance.getUUId(_info.getSpellEftId(), AvatarType.SKILL_TYPE_SPELL, frontOrback)).fightData.atkTimeSkillEfft;

			return atkTimeSkillEfft;
		}

		public function getAtkTimeGroundEfft() : Number {
			trace(AvatarManager.instance.getUUId(_info.getGroundSkillID(), AvatarType.SKILL_TYPE_GROUND, 1));
			var obj : Object = AvatarManager.instance.getAvatarBD(AvatarManager.instance.getUUId(_info.getGroundSkillID(), AvatarType.SKILL_TYPE_GROUND, 1)).fightData;
			if (obj)
				atkTimeSkillEfft = obj["atkTimeSkillEfft"];
			return atkTimeSkillEfft;
		}

		// 受挫动作时间
		public function getAtkTimeTrad() : Number {
			atkTimeTrad = avatarBd.fightData.atkTimeTrad;
			return atkTimeTrad;
		}

		public function setAtkTimeTrad(tm : Number) : void {
			atkTimeTrad = tm;
		}

		// 躲闪动作时间
		public function getAtkTimeevade() : Number {
			atkTimeevade = avatarBd.fightData.atkTimeTrad;
			return atkTimeevade;
		}

		public function setAtkTimeevade(tm : Number) : void {
			atkTimeevade = tm;
		}

		// 出击时间
		public function getAtkTimesally() : Number {
			return atkTimesally;
		}

		public function setAtkTimesally(tm : Number) : void {
			atkTimesally = tm;
		}

		// 原地stand
		public function getAtkTimeStand() : Number {
			return atkTimeStand;
		}

		public function setAtkTimeStand(tm : Number) : void {
			atkTimeStand = tm;
		}

		// 归位时间
		public function getAtkTimeback() : Number {
			return atkTimeback;
		}

		public function setAtkTimeback(tm : Number) : void {
			atkTimeback = tm;
		}

		// 死亡动作时间
		public function getAtkTimeDie() : Number {
			return atkTimeDie;
		}

		public function setAtkTimeDie(tm : Number) : void {
			atkTimeDie = tm;
		}

		public function getTopX() : int {
			trace(avatarBd);
			return avatarBd.topX;
		}

		public function getSide() : int {
			return _info.side;
		}

		public function getTopY() : int {
			return avatarBd.topY;
		}

		// 设置血条
		public function setHPProcessBar(hpP : Number) : void // hpP:血量百分比
		{
			return;
		}

		// 显示伤血文字
		public function showHarmText() : void {
		}

		// 根据avata的中心坐标获得伤血文字的偏移
		public function getHPNumber() : Point {
			return new Point(0, 0);
		}

		public function getInitHP() : uint {
			return _info.maxHp;
		}

		public function showAvatarEfftTo(effctID : uint, skillID : uint = 0, flag : uint = 0) : void {
			if (effctID == BTSystem.ID_PhyAtk) {
				var Phyatk : MovieClip = new BTSystem.EffectTo_PhyAtk as MovieClip;
				Phyatk.gotoAndStop(1);
				Phyatk.x = -145;
				Phyatk.y = -175;
				if (flag == 1) {
					Phyatk.scaleX = -1;
					Phyatk.x += Phyatk.width;
				}
				this.addChild(Phyatk);
				Phyatk.gotoAndPlay(1);
				TweenLite.to(Phyatk, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, Phyatk], overwrite:0});
			} else if (effctID == BTSystem.ID_Baoji) {
				var Baoji : MovieClip = new (BTSystem.EffectTo_Baoji) as MovieClip;
				Baoji.gotoAndStop(1);
				Baoji.x = -212;
				Baoji.y = -258;
				if (flag == 1) {
					Baoji.scaleX = -1;
					Baoji.x += Baoji.width;
				}
				this.addChild(Baoji);
				Baoji.gotoAndPlay(1);
				TweenLite.to(Baoji, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, Baoji], overwrite:0});
			} else if (effctID == BTSystem.ID_Poji) {
				var Poji : MovieClip = new BTSystem.EffectTo_Poji as MovieClip;
				Poji.gotoAndStop(1);
				Poji.x = -148;
				Poji.y = -324;
				if (flag == 1) {
					Poji.scaleX = -1;
					Poji.x += Poji.width - 195;
				}
				this.addChild(Poji);
				Poji.gotoAndPlay(1);
				TweenLite.to(Poji, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, Poji], overwrite:0});
			} else if (effctID == BTSystem.ID_Baopo) {
				var Baopo : MovieClip = new BTSystem.EffectTo_Poji as MovieClip;
				Baopo.gotoAndStop(1);
				Baopo.x = -148;
				Baopo.y = -324;
				if (flag == 1) {
					Baopo.scaleX = -1;
					Baopo.x += Baopo.width - 195;
				}
				this.addChild(Baopo);
				Baopo.gotoAndPlay(1);
				TweenLite.to(Baopo, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, Baopo], overwrite:0});
			}
			// else if (effctID == BTSystem.ID_Shanbi)
			// {
			// var Shanbi : MovieClip = new BTSystem.Effect_Shanbi as MovieClip;
			// Shanbi.x = -45;
			// Shanbi.y = -140;
			// this.addChild(Shanbi);
			// Shanbi.gotoAndPlay(1);
			// } 
			else if (effctID == BTSystem.ID_Skill) {
			}
		}

		// 设置普通效果,攻击方
		public function showAvatarEfft(effectID : uint, skillID : uint = 0) : void {
			trace(skillID);
			if (effectID == BTSystem.ID_Baoji) {
				var Baoji : MovieClip = new BTSystem.Effect_Baoji as MovieClip;
				Baoji.gotoAndStop(1);
				if (this.getSide() == 0) {
					Baoji.x = getTopX() + 50;
					Baoji.y = getTopY() - 65;
				} else {
					Baoji.x = getTopX() - 30;
					Baoji.y = getTopY() - 65;
				}
				this.addChild(Baoji);
				Baoji.gotoAndPlay(1);
				TweenLite.to(Baoji, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, Baoji], overwrite:0});
			} else if (effectID == BTSystem.ID_Poji) {
				var Poji : MovieClip = new BTSystem.Effect_Poji as MovieClip;
				Poji.gotoAndStop(1);
				if (this.getSide() == 0) {
					Poji.x = getTopX() + 50;
					Poji.y = getTopY() - 65;
				} else {
					Poji.x = getTopX() - 30;
					Poji.y = getTopY() - 65;
				}
				this.addChild(Poji);
				Poji.gotoAndPlay(1);
				TweenLite.to(Poji, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, Poji], overwrite:0});
			} else if (effectID == BTSystem.ID_Baopo) {
				var Baopo : MovieClip = new BTSystem.Effect_Baopo as MovieClip;
				Baopo.gotoAndStop(1);
				if (this.getSide() == 0) {
					Baopo.x = getTopX() + 50;
					Baopo.y = getTopY() - 65;
				} else {
					Baopo.x = getTopX() - 30;
					Baopo.y = getTopY() - 65;
				}
				this.addChild(Baopo);
				Baopo.gotoAndPlay(1);
				TweenLite.to(Baopo, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, Baopo], overwrite:0});
			} else if (effectID == BTSystem.ID_Shanbi) {
				var Shanbi : MovieClip = new BTSystem.Effect_Shanbi as MovieClip;
				Shanbi.gotoAndStop(1);
				if (this.getSide() == 0) {
					Shanbi.x = getTopX() + 50;
					Shanbi.y = getTopY() - 70;
				} else {
					Shanbi.x = getTopX() - 30;
					Shanbi.y = getTopY() - 50;
				}
				this.addChild(Shanbi);
				Shanbi.gotoAndPlay(1);
				TweenLite.to(Shanbi, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, Shanbi], overwrite:0});
			} else if (effectID == BTSystem.ID_Counter) {
				var Counter : MovieClip = new BTSystem.Effect_Counter as MovieClip;
				Counter.gotoAndStop(1);
				if (this.getSide() == 0) {
					Counter.x = getTopX() + 50;
					Counter.y = getTopY() - 70;
				} else {
					Counter.x = getTopX() - 30;
					Counter.y = getTopY() - 50;
				}
				this.addChild(Counter);
				Counter.gotoAndPlay(1);
				TweenLite.to(Counter, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, Counter], overwrite:0});
			} else if (effectID == BTSystem.ID_Skill) {
			}
		}

		// 显示技能名字美术字
		public function showSkillName() : void {
			// var skillNameStr:String = SkillManager.getInstance().getSkillName(theFighterInfo.skillId+30000);
			// var nametxt:TextField = new TextField();
			// nametxt.text = skillNameStr;
			// nametxt.x = this._avatarBd.topX;
			// nametxt.y = this._avatarBd.topY;
			//
			// var format:TextFormat=new TextFormat();
			// format.size = 15;
			// format.color=0xff0000;
			// nametxt.setTextFormat(format, 0, nametxt.text.length);
			// this.addChild(nametxt);
			// TweenLite.to(nametxt, 1, {y: this._avatarBd.topY + 50, onComplete:deleteTextField, onCompleteParams:[nametxt], overwrite:0});

			theFighterInfo.getSkillName();

			var skillClass : Class = RESManager.getLoader("Numbers").getClass("skillname");
			var skillnameMc : MovieClip = new skillClass as MovieClip;
			if (skillnameMc == null)
				return;
			skillnameMc["skill"]["myText"] = theFighterInfo.getSkillName();
			// (skillnameMc.getChildByName("skill")["skillname"] as TextField).text = theFighterInfo.getSkillName();
			// (skillnameMc.getChildByName("skill")["skillname"] as TextField).filters = [new GlowFilter(0xFF0000, 1, 3, 3, 3, 3)];
			// skillnameMc.gotoAndPlay(1);
			// this.addChild(skillnameMc);
			skillnameMc.y = this._avatarBd.topY;

			TweenLite.to(skillnameMc, 0, {delay:0.5, onComplete:PlayMovieClip, onCompleteParams:[this, skillnameMc], overwrite:0});
			TweenLite.to(skillnameMc, 0, {delay:2, onComplete:ShowEffectComplete_func, onCompleteParams:[this, skillnameMc], overwrite:0});
		}

		public function deleteTextField(nametxt : TextField) : void {
			this.removeChild(nametxt);
		}

		// 攻击方显示技能特效
		public function showSkillEfft(bs : BtStatus) : void {
		}

		public function playSkillEfft(playType : uint, spellEftid : uint, frontOrback : uint, needTurnOver : Boolean, angle : uint) : void {
			this.playSkill(spellEftid, playType, frontOrback, needTurnOver, angle);
		}

		public function playUpDownWords(skillid : uint, control : uint, skillAB : uint) : void {
			this.playupdownwords(skillid, control, skillAB);
		}

		// control：0 消失 1 播放
		public function playSkillBuff(skillid : uint, control : uint, skillAB : uint) : void {
			this.playBuff(skillid, control, skillAB);
		}

		// control：0 消失 1 播放
		public function playSkillBuff2(skillid : uint, control : uint) : void {
			this.playBuff2(skillid, control);
		}

		public function playGroudEft(skillid : uint) : void {
			this.playgroudeft(skillid, _info.side);
		}

		private static function ShowEffectComplete_func(av : BTAvatar, mc : MovieClip) : void {
			if (av.contains(mc)) {
				if (mc) mc.stop();
				av.removeChild(mc);
			}
		}

		private static function PlayMovieClip(av : BTAvatar, mc : MovieClip) : void {
			if (mc && av) {
				av.addChild(mc);
				mc.gotoAndPlay(1);
			}
		}

		public function get theFighterInfo() : FighterInfo {
			return _info;
		}

		public function clear() : void {
			var obj : *;
			while (this.numChildren) {
				obj = this.getChildAt(0);
				if (obj is MovieClip) (obj as MovieClip).stop();
				this.removeChildAt(0);
			}
		}

		override public function dispose() : void {
			_player.dispose();
			clear();
		}
	}
}