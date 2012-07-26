package game.core.hero {
	import game.core.item.ItemManager;
	import game.core.item.equipable.EquipableItem;
	import game.core.item.equipment.Equipment;
	import game.core.item.prop.ItemProp;
	import game.core.item.soul.Soul;
	import game.core.item.sutra.Sutra;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.module.formation.FMControler;
	import game.net.core.Common;
	import game.net.data.CtoC.CCUserDataChangeUp;
	import game.net.data.CtoS.CSOtherInfo;
	import game.net.data.StoC.SCHeroEnhance;

	/**
	 * @author jian
	 */
	public class HeroManager
	{
		// =====================
		// 单例
		// =====================
		private static var __instance : HeroManager;

		public static function get instance() : HeroManager
		{
			if (!__instance)
				__instance = new HeroManager();

			return __instance;
		}

		public function HeroManager() : void
		{
			if (__instance)
				throw (Error("单例错误！"));

			initiate();
		}

		// =====================
		// setter/getter
		// =====================
		public function get myHero() : VoHero
		{
			return UserData.instance.myHero;
		}

		public function get teamHeroes() : Array
		{
			var heroes : Array = [];
			for each (var hero:VoHero in UserData.instance.heroes)
			{
				heroes.push(hero);
			}
			return heroes;
		}

		public function get otherHeroes() : Array
		{
			var heroes : Array = [];
			for each (var hero:VoHero in UserData.instance.otherHeros)
			{
				heroes.push(hero);
			}
			return heroes;
		}

		public function get allHeroes() : Array
		{
			return teamHeroes.concat(otherHeroes);
		}

		/**
		 * 当前队伍中的英雄
		 * type 0:当前队伍英雄
		 * type 1:离队队伍英雄
		 * type 2:全部英雄
		 */
		public function getTeamHeroById(id : int, type : int = 0) : VoHero
		{
			var tempHeroes : Vector.<VoHero>;
			switch(type)
			{
				case 0:
					tempHeroes = UserData.instance.heroes;
					break;
				case 1:
					tempHeroes = UserData.instance.otherHeros;
					break;
				case 2:
					tempHeroes = UserData.instance.heroes.concat(UserData.instance.otherHeros);
					break;
			}
			for each (var vo:VoHero in tempHeroes)
			{
				if (vo.id == id)
				{
					return vo;
				}
			}
			return null;
		}

		// =====================
		// 方法
		// =====================
		private function initiate() : void
		{
			SignalBusManager.formationChange.add(onFormationChange);
			SignalBusManager.heroWaringChange.add(onHeroFormationChange);
			SignalBusManager.equipableItemAddToHero.add(onHeroItemChange);
			SignalBusManager.equipableItemMoveToHero.add(onHeroItemChange);
			SignalBusManager.equipableItemMoveToPack.add(onHeroItemChange);
			SignalBusManager.equipableItemRemoveFromHero.add(onHeroItemChange);
			SignalBusManager.heroItemPropChange.add(onHeroItemChange);
			Common.game_server.addCallback(0xFFF1, onUserLevelUp);
			Common.game_server.addCallback(0x15, onSutraProgressChange);
		}

		private function onSutraProgressChange(msg : SCHeroEnhance) : void
		{
			var hero : VoHero = getTeamHeroById(msg.id);
			hero.invalidate = true;
		}

		private function onUserLevelUp(msg : CCUserDataChangeUp) : void
		{
			for each (var hero:VoHero in  UserData.instance.heroes)
			{
				hero.invalidate = true;
			}
		}

		private function onHeroItemChange(item : EquipableItem, hero : VoHero) : void
		{
			if (hero)
				hero.invalidate = true;
		}

		private function onHeroFormationChange(heroId : int, isWaring : Boolean) : void
		{
			for each (var hero:VoHero in  UserData.instance.heroes)
			{
				if (hero.id == heroId)
					hero.invalidate = true;
			}
		}

		private function onFormationChange() : void
		{
			for each (var hero:VoHero in  UserData.instance.heroes)
			{
				if (hero.state == HeroState.WARING)
					hero.invalidate = true;
			}
		}

		public function newHero(id : uint, level : int = 0) : VoHero
		{
			var hero : VoHero = new VoHero(level);
			var conf : HeroConfig = HeroConfigManager.instance.getConfigById(id);

			if (!conf) return null;
			hero.config = conf;
			hero._name = conf.name;
			hero.id = id;

			var prop : VoHeroProp = HeroConfigManager.instance.getPropById(id);
			if (!prop) return null;
			hero.prop = prop;
			hero.potential = prop.potential;
			hero.recruitState = 3;
			
			var sutra : Sutra = ItemManager.instance.newItem(conf.sutraId) as Sutra;
			hero.sutra = sutra;
			sutra.hero = hero;

			hero.initSlots();

			return hero;
		}

		public function updateHeroProp(hero : VoHero) : void
		{
			hero.invalidate = false;

			var formationProp : ItemProp = FMControler.instance.getHeroFMProp(hero.id);
			hero.prop = calculateHeroProp(hero, UserData.instance.profLevel, formationProp);
			hero.bt = calculateBattlePower(hero.prop);
		}

		// =====================
		// 静态方法
		// =====================
		// 决定将领属性的元素：职业，基础属性，等级，装备，套装，法宝，灵珠（包括在法宝中），元神，潜力，修为，阵型
		// 固定不变的：职业，基础属性
		// 可变的：
		// 玩家类：修为，等级（修为等级上升，玩家等级上升）
		// 将领类：潜力（潜力变化）
		// 装备类：装备，法宝，灵珠，元神，套装（装上，卸下装备，镶嵌，取下灵珠，法宝升阶，装备强化等级提升）
		// 阵型类：阵型（上阵，下阵，阵型升级，阵型改变，将领在阵的位置改变）
		public static var propV : Array = [// 3个基础属性
		"strength", "quick", "physique",
		// 11个二级属性 
		"hp", "act", "magic_act", "def", "speed", "gauge_initial", "hit", "dodge", "crit", "pierce", "counter", 
		// 二级属性附加 
		"hp_add", "act_add", "hp_per", "act_per", "speed_per", "magic_per",
		// 特殊属性 
		"predef", "magic_pierce", "critmul", "piercedef", "countermul", "harm", "gauge_speed"];

		public static function calculateHeroProp(hero : VoHero, profLevel : int, formationProp : ItemProp) : VoHeroProp
		{
			 trace("重新计算将领数据 " + hero.name);

			var prop : VoHeroProp;
			var level : int = hero.level;
			var potential : int = hero.potential;
			var job : int = hero.job;
			var jobGrowth : JobGrowth = HeroConfigManager.instance.getJobGrowthByJobId(job);
			var general : VoHeroProp = HeroConfigManager.instance.getPropById(hero.id);

			// 装备加成
			var propKey : String;
			var eqProp : ItemProp;
			for each (var eq:Equipment in hero.equipments)
			{
				eqProp = eq.totalProp;
				if (!eqProp) continue;
				for each (propKey in propV)
				{
					general[propKey] += eqProp[propKey];
				}
			}
			
//			trace("装备加成，战斗力"+calculateBattlePower(general));

			// 套装加成
			var suiteProp : ItemProp;
			for (var suiteId:String in hero.suiteDict)
			{
				suiteProp = hero.getSuitePropById(uint(suiteId));
				if (suiteProp)
				{
					for each (propKey in propV)
					{
						general[propKey] += suiteProp[propKey];
					}
				}
			}
			
//			trace("套装加成，战斗力"+calculateBattlePower(general));

			// 法宝加成 + 灵珠加成
			var sutraProp : ItemProp = hero.sutra.totalProp;
			for each (propKey in propV)
			{
				general[propKey] += sutraProp[propKey];
			}
			
//			trace("法宝加成，战斗力"+calculateBattlePower(general));

			// 元神加成
			for each (var soul:Soul in hero.souls)
			{
				if (!soul.prop) continue;
				for each (propKey in propV)
				{
					general[propKey] += soul.prop[propKey];
				}
			}
			
//			trace("元神加成，战斗力"+calculateBattlePower(general));

			// 潜力加成
			var value : PotentialGrowth = HeroConfigManager.instance.getPotentialGrowth(job, potential);
			if (value)
			{
				var potentialProp : ItemProp = value.prop;
				for each (propV in potentialProp)
				{
					general[propKey] += potentialProp[propKey];
				}
			}
			
//			trace("潜力加成，战斗力"+calculateBattlePower(general));

			// 修仙加成
			// var _profProp : ItemProp = ProfessionManage.instance.getProfeProp(hero.id < 10 ? 0 : hero.job);
			// for each (propKey in _propV)
			// {
			// general[propKey] += _profProp[propKey];
			// }

			// 阵型加成
			if (formationProp)
			{
				for each (propKey in propV)
				{
					general[propKey] += formationProp[propKey];
				}
			}
			
//			trace("阵型加成，战斗力"+calculateBattlePower(general));

			// 需要计算的一些属性

			/** 计算三个一级属性 */
			// 当前力量=角色基础力量+等级*潜力*力量成长系数+其他附加的力量
			general.strength = general.strength + level * potential / 100 * jobGrowth.strengthGrowth;

			// 当前敏捷=角色基础敏捷+等级*潜力*敏捷成长系数+其他附加的敏捷
			general.quick = general.quick + level * potential / 100 * jobGrowth.agilityGrowth;

			// 当前体魄=角色基础体魄+等级*潜力*体魄成长系数+其他附加的体魄
			general.physique = general.physique + level * potential / 100 * jobGrowth.physiqueGrowth;
			
//			trace("等级加成，战斗力"+calculateBattlePower(general));

			prop = general.clone();

			// 当前生命值=［(基础生命值+当前等级*生命成长)*(1+当前体魄*体魄转生命/100)+其他附加生命值］*（1+附加生命百分比之和）
			prop.hp = ((general.hp + level * jobGrowth.healthGrowth) * (1 + general.physique * jobGrowth.physiqueToHealth / 100) + prop.hp_add) * (1 + prop.hp_per / 100);

			// 当前攻击力=［(基础攻击值+当前等级*攻击力成长)*(1+当前力量*力量转攻击/100)+其他附加攻击力］*（1+附加攻击百分比之和）
			prop.act = ((general.act + level * jobGrowth.attackGrowth) * (1 + general.strength * jobGrowth.strengthToAttack / 100) + prop.act_add + 0) * (1 + prop.act_per / 100 + 0);

			// 当前仙攻=基础仙攻+当前等级*当前潜力*仙攻成长+其他附加仙攻
			prop.magic_act = general.magic_act + level * jobGrowth.spellDamGrowth * potential / 100 + 0;

			// 当前防御值=基础防御值+当前体魄*体魄转防御+其他附加防御系数
			prop.def = general.def + general.physique * jobGrowth.physiqueToDefend + 0;

			// 当前命中=基础命中+其他附加命中
			prop.hit = general.hit + 0;

			// 当前闪躲=基础闪躲+当前敏捷*敏捷转闪躲+其他附加闪躲
			prop.dodge = general.dodge + general.quick * jobGrowth.agilityToDodge + 0;

			// 当前速度=基础速度*(1+当前敏捷*敏捷转速度/100)*(1+附加速度提升百分比)+其他附加速度
			prop.speed = general.speed * (1 + general.quick * jobGrowth.agilityToSpeed / 100) * (1 + prop.speed_per / 100) + 0;

			// 当前反击=基础反击+当前力量*力量转反击+其他附加的反击
			prop.counter = general.counter + general.strength * jobGrowth.strengthToCounter + 0;

			// SignalBusManager.heroPropChange.dispatch(this);
			return prop;
		}

		public static function calculateBattlePower(prop : VoHeroProp) : Number
		{
			/**
			 *	攻击部分=(3/4*攻击力+(25/技能聚气消耗)*(攻击力+仙攻)*(1+(初始聚气/200)))*命中*(1+暴击*0.5*(1+高暴)+破击*0.5+反击*0.5*(1+高反))*(1+伤害加深)
			 */
			var act : Number = (3.0 / 4 * prop.act + (25 / prop.gauge_expend) * (prop.act + prop.magic_act) * (1 + (prop.gauge_initial / 200))) * prop.hit / 100 * (1 + prop.crit / 100 * 0.5 * (1 + prop.critmul / 100) + prop.pierce / 100 * 0.5 + prop.counter / 100 * 0.5 * (1 + prop.countermul / 100)) * (1 + prop.harm / 100);
			/*
			 * 生命部分=生命*(1+闪避)*(1+防御*(1+防破)/(5000+防御*(1+防破)))*(1+伤害减少)
			 */
			var hp : Number = prop.hp * (1 + prop.dodge / 100) * (1 + prop.def * (1 + prop.piercedef / 100) / (5000 + prop.def * (1 + prop.piercedef / 100))) * (1 + prop.predef / 100);
			/*
			 * 速度部分=速度/100
			 */
			var speed : Number = prop.speed / 100;

			/**
			 * 战斗力=(攻击部分*生命部分*速度部分)^0.45
			 */
			return Math.pow(act * hp * speed, 0.45);
		}

		public function sendViewOtherInfo(name : String) : void
		{
			var msg : CSOtherInfo = new CSOtherInfo();
			msg.name = name;
			Common.game_server.sendMessage(0x14, msg);
		}
	}
}
