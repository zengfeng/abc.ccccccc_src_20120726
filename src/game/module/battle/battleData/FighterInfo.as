package game.module.battle.battleData
{
	import game.config.StaticConfig;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarType;
	import game.core.hero.HeroConfigManager;
	import game.core.hero.HeroManager;
	import game.manager.RSSManager;

	public class FighterInfo
	{
		public function FighterInfo()
		{
		}

		public var id : uint ;

		public var job : uint;

		public var key : int;

		/** 类型 1 为英雄  */
		public var ftype : uint ;

		private var _fname : String = "";

		public var side : uint = 0;

		public var pos : uint = 0;

		private var level : uint = 0;

		private var color : uint = 0;

		private var cloth : uint = 0;

		// 武器id
		public var weaponId : uint = 0;

		// public var attackType : uint = 1;
		private var phyMoveType : uint = 0;

		private var skillMoveType : uint = 0;

		// 0近战或者1远程攻击
		// 阵型id
		public var fID : uint = 0;

		// 技能
		public var skillId : uint = 0;

		public var initHp : uint = 0;

		public var maxHp : uint = 0;

		private var nowHp : uint = 0;

		// 当前血量
		private var maxGauge : uint = 0;

		// 最大聚气
		private var gaugeUse : uint = 0;

		//
		private var nowGauge : uint = 0;

		// 当前聚气
		private var skillName : String = "";
		
		// 技能名
		// 初始血量
		/** 获取avaterUrl **/
		public function getAvatarUrl() : String
		{
			return StaticConfig.cdnRoot + "assets/avatar/" + key + ".swf";
		}

		public function resetKey(side:int=-1) : void
		{
			var type : int = AvatarType.MONSTER_TYPE;
			var avatarId : int = id;
			if(side==-1)side=this.side;
			if (ftype == 1)
			{
				if (side == 1)
				{
					type = AvatarType.PLAYER_BATT_FRONT;
				}
				else
				{
					type = AvatarType.PLAYER_BATT_BACK;
				}
			}
			else
			{
				if (RSSManager.getInstance().getMosterById(id)){
					avatarId = RSSManager.getInstance().getMosterById(id).avatarId;
				}
				if (id < 4000) type = AvatarType.PLAYER_BATT_FRONT;
			}
			key = AvatarManager.instance.getUUId(avatarId, type, cloth);
		}

		/*		public function resetKey() : void
		{
		key = AvatarManager.instance.getUUId(id,ftype == 1 ? AvatarType.PLAYER_TYPE : AvatarType.MONSTER_TYPE,0,(ftype == 1 && side == 1) ? false : true);
		}
		 */
		public function get name() : String
		{
			if (_fname == "")
			{
				if (ftype == 1)
				{
					if (HeroConfigManager.instance.getConfigById(id))
						_fname = HeroConfigManager.instance.getConfigById(id).name;
				}
				else if (RSSManager.getInstance().getMosterById(id))
					_fname = RSSManager.getInstance().getMosterById(id).name;
			}
			return _fname;
		}

		public function getAtkMoveType() : uint                               // 物理和技能攻击移动方式
		{
			if (AttackData.skilllist[skillId] != null)
			{
				return AttackData.skilllist[skillId].getMoveType();
			}

			return 0;
		}

		public function getSpellEftId() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getSpellEftId();
			return 0;
		}

		public function getTargetType() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getTargetType();
			return 0;
		}

		public function getCanTurnOver() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getCanTurnOver();
			return 0;
		}

		public function getAngleType() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getAngleType();
			return 0;
		}

		public function getGroundSkillID() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getGroundSkillID();
			return 0;
		}
		
		public function getGroundType():uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getGroundType();
			return 0;
		}

		public function getBuffID() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return (AttackData.skilllist[skillId] as skillData).getBuffID();
			return 0;
		}
		
		public function getBuffIndex() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return (AttackData.skilllist[skillId] as skillData).getBuffIndex();
			return 0;
		}
		
		public function getBuffPosition() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return (AttackData.skilllist[skillId] as skillData).getBuffPosition();
			return 0;
		}
		
		public function getBuffPlayType() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return (AttackData.skilllist[skillId] as skillData).getBuffPlayType();
			return 0;
		}
		
		
		public function getSpellEftId2() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getSpellEftId2();
			return 0;
		}
		
		public function getTargetType2() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getTargetType2();
			return 0;
		}
		
		public function getCanTurnOver2() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getCanTurnOver2();
			return 0;
		}
		
		public function getAngleType2() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getAngleType2();
			return 0;
		}
		
		public function getGroundSkillID2() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getGroundSkillID2();
			return 0;
		}
		
		public function getGroundType2():uint
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getGroundType2();
			return 0;
		}
		
		public function getBuffID2() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return (AttackData.skilllist[skillId] as skillData).getBuffID2();
			return 0;
		}
		
		public function getBuffIndex2() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return (AttackData.skilllist[skillId] as skillData).getBuffIndex2();
			return 0;
		}
		
		public function getBuffPosition2() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return (AttackData.skilllist[skillId] as skillData).getBuffPosition2();
			return 0;
		}
		
		public function getBuffPlayType2() : uint
		{
			if (AttackData.skilllist[skillId] != null)
				return (AttackData.skilllist[skillId] as skillData).getBuffPlayType2();
			return 0;
		}
			
		
		public function getJobType() : uint
		{
			return HeroManager.instance.newHero(id).job;
		}

		public function getSkillTypeID() : uint
		{
			var pskilldata : skillData = AttackData.skilllist[skillId];
			if (pskilldata == null)
				return 0;
			var atkarea : Area = AttackData.arealist[pskilldata.atkID];
			if (atkarea == null)
				return 0;
			return atkarea.getType();
		}

		public function getSkillName() : String
		{
			if (AttackData.skilllist[skillId] != null)
				return AttackData.skilllist[skillId].getSkillName();
			return "";
		}
		


		// public function getSpellShowID():uint
		// {
		// if(AttackData.skilllist[skillId] != null)
		// return AttackData.skilllist[skillId].getSpellShowID();
		// return 0;
		// }
		//
		// public function getPhyShowID():uint
		// {
		// if(AttackData.skilllist[skillId] != null)
		// return AttackData.skilllist[skillId].getPhyShowID();
		// return 0;
		// }
		public function setNowHp(hp : uint) : void
		{
			if (hp >= 0)
			{
				if (hp < maxHp)
					nowHp = hp;
				else
					nowHp = maxHp;
			}
		}

		public function getNowHp() : uint
		{
			return nowHp;
		}

		public function setNowGauge(gauge : uint) : void
		{
			if (nowGauge >= 0)
				nowGauge = gauge;
		}

		public function getNowGauge() : uint
		{
			return nowGauge;
		}

		public function set name(value : String) : void
		{
			_fname = value;
		}

		public function getMaxGauge() : uint
		{
			return maxGauge;
		}

		public function setMaxGauge(mg : uint) : void
		{
			maxGauge = mg;
		}

		public function getGaugeUse() : uint
		{
			return gaugeUse;
		}

		public function setGaugeUse(guse : uint) : void
		{
			gaugeUse = guse
		}

		public function getLevel() : uint
		{
			return level;
		}

		public function setLevel(l : uint) : void
		{
			level = l;
		}

		public function getColor() : uint
		{
			return color;
		}

		public function setColor(c : uint) : void
		{
			color = c;
		}

		public function getCloth() : uint
		{
			return cloth;
		}

		public function setCloth(c : uint) : void
		{
			cloth = c;
		}

		// public function setSkillName(name:String):void
		// {
		// skillName = name;
		// }
		// public function getSkillName():String
		// {
		// return skillName;
		// }
		// 技能id
		public var pInfo2 : PropInfo2Base;
	}
}