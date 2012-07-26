package game.core.avatar {
	import game.module.battle.battleData.AttackData;
	import game.module.battle.battleData.skillData;
	import game.module.battle.battleData.skillType;

	import gameui.controls.BDPlayer;
	import gameui.core.GComponentData;

	import net.RESManager;

	import com.greensock.TweenLite;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarFight extends AvatarThumb {
		private var _diePlay : BDPlayer;

		// 设置动作
		override public function setAction(value : int, loop : int = 1, index : int = 0, arr : Array = null, onComplete : Function = null, onCompleteParams : Array = null) : void {
			if (value == AvatarManager.DIE) {
				die();
				return;
			}
			super.setAction(value, loop, index, arr, onComplete, onCompleteParams);
		}

		private var _isDie : Boolean = false;

		public function getIsDie() : Boolean {
			return _isDie;
		}

		protected var _skillAvatar : AvatarSkill;

		override public function die() : void {
			// 隐藏技能buff
			for each (var buff:AvatarSkill in _buffDic) {
				if (buff) {
					buff.hide();
				}
			}
			_isDie = true;
			_diePlay = new BDPlayer(new GComponentData());
			_diePlay.setBDData(AvatarManager.instance.getDie());
			addChild(_diePlay);
			_diePlay.addEventListener(Event.COMPLETE, dieComplete);
			_diePlay.play(30);
			player.stop();
			TweenLite.to(player, 0.6, {alpha:0, overwrite:0});
			TweenLite.to(_progressBar, 0.6, {alpha:0, overwrite:0});
			TweenLite.to(_nameBitMap, 0.6, {alpha:0, overwrite:0});
		}

		override protected function onShow() : void {
			super.onShow();
			this.player.addEventListener(Event.COMPLETE, onComplete);
		}

		override protected function onHide() : void {
			super.onHide();
			this.player.removeEventListener(Event.COMPLETE, onComplete);
		}

		// 显示或者隐藏血条，名字bar
		public function showNameAndHPbar(bVisible : Boolean = true) : void {
			if (bVisible) {
				if (_progressBar)
					_progressBar.visible = true;
				_nameBitMap.visible = true;
			} else {
				if (_progressBar)
					_progressBar.visible = false;
				_nameBitMap.visible = false;
			}
		}

		// 放技能 control：0 消失 1 持续播放 2 播放一次   playType:是攻击发处播放还是受挫方处的播放 0:攻击方 1：受挫方  phyOrSkill:物理还是法术 0：物理 1：法术  frontOrback:正面动画还是反面 0表示正面，1表示反面   needTurnOver:为true 表示动画需要翻转
		public function playSkill(spellEftid : int, playType : uint, frontOrback : uint, needTurnOver : Boolean, angle : uint) : void {
			var firstKeyID : uint = AvatarType.SKILL_TYPE_SPELL;

			if (!_skillAvatar || _skillAvatar.uuid != AvatarManager.instance.getUUId(spellEftid, firstKeyID, frontOrback)) {
				if (playType == 0)  // 攻击方
				{
					_skillAvatar = AvatarManager.instance.getBattleAvatar(1);
					_skillAvatar.initAvatar(spellEftid, firstKeyID, frontOrback);
					_skillAvatar.x = avatarBd.skillPointX;
					_skillAvatar.y = avatarBd.skillPointY;
				} else if (playType == 1)  // 受挫方
				{
					if (angle == 0) {
						_skillAvatar = AvatarManager.instance.getBattleAvatar(1);
						;
						_skillAvatar.initAvatar(spellEftid, firstKeyID, frontOrback);
						_skillAvatar.x = 0;
						_skillAvatar.y = 0;
					} else if (angle == 1) // 有角度播放
					{
						// if(side == 1)
						// {
						// _skillAvatar = AvatarManager.instance.getBattleAvatar(1);;
						// _skillAvatar.setId(AvatarManager.instance.getUUId(spellEftid, firstKeyID, frontOrback));
						// _skillAvatar.x = 200;
						// _skillAvatar.y = -100;
						// }
						// else if(side == 0)
						// {
						// _skillAvatar = AvatarManager.instance.getBattleAvatar(1);;
						// _skillAvatar.setId(AvatarManager.instance.getUUId(spellEftid, firstKeyID, frontOrback));
						// _skillAvatar.x = -200;
						// _skillAvatar.y = -100;
						// }
						_skillAvatar = AvatarManager.instance.getBattleAvatar(1);
						_skillAvatar.initAvatar(spellEftid, firstKeyID, frontOrback);
						_skillAvatar.x = 0;
						_skillAvatar.y = 0;
					} else if (angle == 2)  // 目标base点播放
					{
						_skillAvatar = AvatarManager.instance.getBattleAvatar(1);
						_skillAvatar.initAvatar(spellEftid, firstKeyID, frontOrback);
						_skillAvatar.x = 0;
						_skillAvatar.y = 0;
					}
				}
				if (needTurnOver)
					_skillAvatar.player.scaleX = -1;
				addChild(_skillAvatar);
			} else {
				if (this.contains(_skillAvatar)) {
					_skillAvatar.initAvatar(spellEftid, firstKeyID, frontOrback);
				} else {
					addChild(_skillAvatar);
				}
				if (needTurnOver)
					_skillAvatar.player.scaleX = -1;
			}
			_skillAvatar.player.addEventListener(Event.COMPLETE, skillComplete);
			_skillAvatar.setAction(1, 1, 0);
			_skillAvatar.show();
		}

		private function ShowWordsComplete(af : AvatarFight, mc : MovieClip) : void {
			if (af.contains(mc)){
				mc.stop();
				af.removeChild(mc);
			}
		}

		private function playUpdownWords(words : String) : void {
			if (words.length <= 1)
				return;
			if (words.charAt(0) == "加") {
				words = words.substring(1, words.length);
				var upwordsClass : Class = RESManager.getLoader("Numbers").getClass("upwords");
				if (upwordsClass) {
					var upmc : MovieClip = new upwordsClass as MovieClip;
					upmc["myTF"]["myText"] = words;
					addChild(upmc);
					upmc.y = avatarBd.topY + 50;
					upmc.x -= 50;
					upmc.gotoAndPlay(1);
					TweenLite.to(upmc, 0, {delay:2, onComplete:ShowWordsComplete, onCompleteParams:[this, upmc], overwrite:0});
				}
			} else if (words.charAt(0) == "减") {
				words = words.substring(1, words.length);
				var downwordsClass : Class = RESManager.getLoader("Numbers").getClass("downwords");
				if (downwordsClass) {
					var downmc : MovieClip = new downwordsClass as MovieClip;
					downmc["myTF"]["myText"] = words;
					downmc.y = avatarBd.topY + 50;
					downmc.x -= 50;
					addChild(downmc);
					downmc.gotoAndPlay(1);
					TweenLite.to(downmc, 0, {delay:2, onComplete:ShowWordsComplete, onCompleteParams:[this, downmc], overwrite:0});
				}
			} else {
				return;
			}
		}

		// control：0 消失 1 持续播放
		protected var _buffDic : Dictionary = new Dictionary();

		public function playupdownwords(skillid : int, control : uint, skillAB : uint) : void {
			var skilldata : skillData;
			if (AttackData.skilllist[skillid] != null)
				skilldata = AttackData.skilllist[skillid] as skillData;
			else
				return;
			var playwords : String = "";
			if (control != 0) {
				if (skillAB == 0)
					playwords = skilldata.getUpDownWords();
				else
					playwords = skilldata.getUpDownWordsPlus();
				playUpdownWords(playwords);
			}
		}

		// index 0:底层 1：顶层
		public function playBuff(skillid : int, control : uint, skillAB : uint) : void {
			if (skillid == skillType.GAUGEFULL) // 聚气特殊处理，有两个buff效果组合
			{
				var skillGaugeA : AvatarSkill = _buffDic[skillType.GAUGEFULL];
				//var skillGaugeB : AvatarSkill = _buffDic[skillType.GAUGEFULL + 1];

				if (_isDie) return;
				switch(control) {
					case 0:
						// 移除
						if (!skillGaugeA) return;
						skillGaugeA.hide();
						//if (!skillGaugeB) return;
						//skillGaugeB.hide();
						break;
					case 1:
						// 添加
						if (!skillGaugeA)
							skillGaugeA = createBuffAvatar(skillType.GAUGEFULL);
						if (!this.contains(skillGaugeA))
							addChild(skillGaugeA);
						if ( skillGaugeA != null && this.contains(skillGaugeA))             // 移动至底层播放
							setChildIndex(skillGaugeA, 0);
						//if (!skillGaugeB)
						//	skillGaugeB = createBuffAvatar(skillType.GAUGEFULL + 1);
						//if (!this.contains(skillGaugeB))
						//	addChild(skillGaugeB);
						skillGaugeA.setAction(1, 0);
						//skillGaugeB.setAction(1, 0);
						_buffDic[skillType.GAUGEFULL] = skillGaugeA;
						//_buffDic[skillType.GAUGEFULL + 1] = skillGaugeB;
						break;
				}
			} else {
				var skilldata : skillData;
				var buffId : uint;
				var buffIndex : uint;
				var buffPosition : uint;
				var buffPlayType : uint;
				var updownwords : String;
				// 如果是在下层
				if (AttackData.skilllist[skillid] != null)
					skilldata = AttackData.skilllist[skillid] as skillData;
				else
					return;
				if (skilldata != null) {
					if (skillAB == 0) {
						buffId = skilldata.getBuffID();
						buffIndex = skilldata.getBuffIndex();
						buffPosition = skilldata.getBuffPosition();
						buffPlayType = skilldata.getBuffPlayType();
						updownwords = skilldata.getUpDownWords();
					} else {
						buffId = skilldata.getBuffPlusID();
						buffIndex = skilldata.getBuffPlusIndex();
						buffPosition = skilldata.getBuffPlusPosition();
						buffPlayType = skilldata.getBuffPlusPlayType();
						updownwords = skilldata.getUpDownWords();
					}

					if (buffId == 0)
						return;
				} else {
					return;
				}

				var skillAvatar : AvatarSkill = _buffDic[buffId];
				if (_isDie)
					return;
				switch(control) {
					case 0:
						// 移除
						if (!skillAvatar) return;
						skillAvatar.hide();
						break;
					case 1:
						// 添加
						if (!skillAvatar)
							skillAvatar = createBuffAvatar(buffId, buffPosition);
						addChild(skillAvatar);
						// 层级关系，上层or下层
						if (buffIndex == 2) // 身下
						{
							if ( skillAvatar != null && this.contains(skillAvatar)) // 移动至底层播放
								setChildIndex(skillAvatar, 0);
						}
						// 位置 1：头顶 2：叠在身上
						if (buffPosition == 1) {
						} else if (buffPosition == 2) // 身上
						{
						}
						// 播放方式
						if (buffPlayType == 1) // 循环播放
						{
							skillAvatar.setAction(1, 0);
						} else if (buffPlayType == 2) // 播放到最后一帧stop
						{
							skillAvatar.setAction(1, 1);
						}
						_buffDic[buffId] = skillAvatar;
						// Logger.debug(this._id+"buff.play()");
						// this.playUpdownWords(updownwords);
						break;
					/*case 2: // 播放一遍后消失
					{
					if (!skillAvatar) skillAvatar = createBuffAvatar(buffId, buffPosition);
					addChild(skillAvatar);
						
					// 层级关系，上层or下层
					if(buffIndex == 2) // 身下
					{
					if( skillAvatar != null && this.contains(skillAvatar)) // 移动至底层播放
					setChildIndex(skillAvatar, 0);
					}
						
					// 播放方式
					if(buffPlayType == 1) // 循环播放
					{
					skillAvatar.setAction(1, 0);
					}
					else if(buffPlayType == 2) // 播放到最后一帧stop
					{
					skillAvatar.setAction(1, 1);
					}
					skillAvatar.player.addEventListener(Event.COMPLETE, buffplayComplete); // 控制播放一次

					_buffDic[buffId]=skillAvatar;
					// Logger.debug(this._id+"buff.play()");
					// this.playUpdownWords(updownwords);
					break;
					}*/
				}
			}
		}

		// index 0:底层 1：顶层
		public function playBuff2(skillid : int, control : uint) : void {
			var skilldata : skillData;
			var buffId : uint;
			var buffIndex : uint;
			var buffPosition : uint;
			var buffPlayType : uint;
			// 如果是在下层
			if (AttackData.skilllist[skillid] != null)
				skilldata = AttackData.skilllist[skillid] as skillData;
			else
				return;
			if (skilldata != null) {
				buffId = skilldata.getBuffID2();
				buffIndex = skilldata.getBuffIndex2();
				buffPosition = skilldata.getBuffPosition2();
				buffPlayType = skilldata.getBuffPlayType2();
			} else {
				return;
			}

			var skillAvatar : AvatarSkill = _buffDic[buffId];
			if (_isDie) return;
			switch(control) {
				case 0:
					// 移除
					if (!skillAvatar) return;
					skillAvatar.hide();
					break;
				case 1:
					// 添加
					if (!skillAvatar) skillAvatar = createBuffAvatar(buffId, buffPosition);
					addChild(skillAvatar);
					// 层级关系，上层or下层
					if (buffIndex == 2) // 身下
					{
						if ( skillAvatar != null && this.contains(skillAvatar)) // 移动至底层播放
							setChildIndex(skillAvatar, 0);
					}
					// 位置 1：头顶 2：叠在身上
					if (buffPosition == 1) {
					} else if (buffPosition == 2) // 身上
					{
					}
					// 播放方式
					if (buffPlayType == 1) // 循环播放
					{
						skillAvatar.setAction(1, 0);
					} else if (buffPlayType == 2) // 播放到最后一帧stop
					{
						skillAvatar.setAction(1, 1);
					}
					_buffDic[buffId] = skillAvatar;
					break;
				case 2:
					break;
			}
		}

		// control  0:播放一次
		public function playgroudeft(skillid : uint, myside : uint) : void {
			var skilldata : skillData;
			if (AttackData.skilllist[skillid] != null)
				skilldata = AttackData.skilllist[skillid] as skillData;
			else
				return;
			// 如果挂了
			if (_isDie) return;

			var gEftAvatar : AvatarSkill = null;
			var groundeftid : uint = 0;
			var groundIndex : uint = 0;
			var needTurnOver : uint = 0;
			var frontOrback : uint = myside;

			groundeftid = skilldata.getGroundSkillID();
			groundIndex = skilldata.getGroundType();
			needTurnOver = skilldata.getGroundCanTurnOver();
			if (needTurnOver == 0 || needTurnOver == 1 ) // 不需要翻转或者程序翻转
			{
				frontOrback = 1;
			}

			if (groundeftid > 0) {
				gEftAvatar = AvatarManager.instance.getBattleAvatar(1);
				gEftAvatar.initAvatar(groundeftid, AvatarType.SKILL_TYPE_GROUND, frontOrback);
				// gEftAvatar.player.addEventListener(Event.COMPLETE, skillgroundSkillComplete);
				// 控制播放一次
				gEftAvatar.setAction(1, 1, 1, null, skillgroundSkillComplete, [gEftAvatar]);
				addChild(gEftAvatar);

				if (needTurnOver == 1) // 程序翻转
				{
					if (myside == 0) {
						gEftAvatar.scaleX = -1;
					}
				}
			}

			// 判断层次
			if (groundIndex == 2)  // 底层播放
			{
				if (gEftAvatar != null && this.contains(gEftAvatar)) // 移动至底层播放
					setChildIndex(gEftAvatar, 0);
			}
		}

		private function createBuffAvatar(id : int, putposition : int = 0) : AvatarSkill {
			var skillAvatar : AvatarSkill = AvatarManager.instance.getBattleAvatar(1);
			skillAvatar.initAvatar(id, AvatarType.BUFF_TYPE);
			// /Logger.debug("createBuffAvatar id===>"+skillAvatar.id);
			// skillAvatar.setAction(1);
			// 0 叠在avatar身上 1 头顶上 2 文字()
			switch(putposition) {
				case 0:
					skillAvatar.x = 0;
					skillAvatar.y = 0;
					break;
				case 1:
					skillAvatar.x = avatarBd.topX + 60;
					skillAvatar.y = avatarBd.topY + 35;
					break;
				case 2:
					skillAvatar.x = 0;
					skillAvatar.y = 0;
				case 3:
					break;
			}
			return skillAvatar;
		}

		private function skillComplete(event : Event) : void {
			if (_skillAvatar) {
				_skillAvatar.player.removeEventListener(Event.COMPLETE, skillComplete);
				_skillAvatar.hide();
			}
		}

		private function skillgroundSkillComplete(avatar : AvatarSkill) : void {
			if (avatar)
				avatar.hide();
		}

		private function onComplete(event : Event) : void {
			if (_currentAction.action == AvatarManager.DIE) {
				this.player.stop();
			} else
				setAction(AvatarManager.BT_STAND, 0);
		}

		private function dieComplete(event : Event) : void {
			_diePlay.stop();
			_diePlay.removeEventListener(Event.COMPLETE, dieComplete);
			hide();
		}

		override public function playShowAction() : void {
		}
		
		/** 回收 */
		override internal function callback() : void {
			reset();
			dispose();
		}

		public function AvatarFight() {
			super();
			addProgressBar();
		}
	}
}
