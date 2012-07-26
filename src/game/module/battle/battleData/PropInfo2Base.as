package game.module.battle.battleData
{
	import game.net.data.StoC.PropertyB;
	public class PropInfo2Base
	{
		public function PropInfo2Base()
		{
		}
		public var maxhp:int;         //满血hp
		public var health:int;        //hp
		public var attack:int;        //攻击力
		public var defend:int;        //防御
		public var speed:int;         //速度
		public var hitrate:Number;    //命中率
		public var dodge:Number;      //躲闪率
		public var critical:Number;   //暴击率
		public var pierce:Number;     //破击率
		public var counter:Number;    //反击率
		public var critMul:Number;    //高爆率
		public var pierceDef:Number;  //防破率
		public var counterMul:Number; //高反
		public var damageAmp:Number = 0;
		public var damageDef:Number = 0; //伤害减免
		public var spellPow:int;      //附加法术伤害
		public var spellMul:Number;   //法术伤害倍数
		public var gaugeMax:int;      //最大聚气值
		public var gaugeInit:int;     //初始聚气值
		public var gaugeUse:int;      //聚气触发技能值
		public var formationid:int;   //阵型id
		
		public function clone():PropInfo2Base{
			var tmp:PropInfo2Base = new PropInfo2Base();
			tmp.maxhp = maxhp;
			tmp.health = health;
			tmp.attack = attack;
			tmp.defend = defend;
			tmp.speed = speed;
			tmp.hitrate = hitrate;
			tmp.dodge = dodge;
			tmp.critical = critical;
			tmp.pierce = pierce;
			tmp.counter = counter;
			tmp.critMul = critMul;
			tmp.pierceDef = pierceDef;
			tmp.counterMul = counterMul;
			tmp.damageDef = damageDef;
			tmp.damageAmp = damageAmp;
			tmp.spellPow = spellPow;
			tmp.spellMul = spellMul;
			tmp.gaugeMax = gaugeMax;
			tmp.gaugeInit = gaugeInit;
			tmp.gaugeUse = gaugeUse;
			tmp.formationid = formationid;
			return tmp;
		}
		/**
		 * 
   required uint32 hp = 6;
   //攻击力
   required uint32 attack = 7;
   //法术伤害
   required uint32 spelldmg = 8;
   //防御
   required uint32 defend = 9;
   //命中率
   required double hitrate = 10;
   //躲闪率
   required double dodge = 11;
   //攻击速度
   required uint32 speed = 12;
   //暴击
   required double crit = 13;
   //破击
   required double pierce = 14;   
   //反击
   required double counter = 15;
   //高反
   required double countermul = 16;
   //高暴
   required double critmul = 17;
   //防破
   required double piercedef = 18;
   //法术伤害倍数
   required double spellmul = 19;
		 */
		public function clonePropertyB(value:PropertyB):PropInfo2Base{
			this.maxhp = value.hp;
			this.health = value.hpnow;
			this.attack = value.attack;
			this.defend = value.defend;
			this.speed = value.speed;
			this.hitrate = value.hitrate;
			this.dodge = value.dodge;
			this.critical = value.crit;
			this.pierce = value.pierce;
			this.counter = value.counter;
			this.critMul = value.critmul;
			this.pierceDef = value.piercedef;
			this.counterMul = value.countermul;
			this.damageDef = value.damagedef;
			this.damageAmp = value.damageAmp;
			this.spellPow = value.spelldmg;
			this.spellMul = value.spellmul;
			this.gaugeMax = value.gaugemax;
			this.gaugeInit = value.gaugeinit;
			this.gaugeUse = value.gaugeuse;
			if(value.hasFormationid)
    			this.formationid = value.formationid;
			else
				this.formationid = 0;
			return this;
		}
	}
}