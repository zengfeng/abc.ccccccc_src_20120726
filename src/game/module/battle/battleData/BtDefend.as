package game.module.battle.battleData
{
	public class BtDefend
	{
		public var pos:int;          //位置
		public var damage:int = 0;       //造成的伤害
		public var leftHp:uint;      //剩余血量
		public var counterDmg:int = 0;  //反击伤害
		public var counterLeft:uint = 0; //反击后剩余血量
	//	public var letDie:int = -1;    //当lefthp = 0时，用来判断是普通伤害造成的死亡还是如中毒之类的,-1表示没有造成死亡，0，表示普通伤害造成的死亡，其它表示技能造成
		public var leftGauge:uint;
		public var aterleftHp:uint;     //攻击者剩余hp
		public var aterleftGauge:uint;  //攻击者剩余gauge
		
		public function BtDefend()
		{
		}
		
		public function clone():BtDefend
		{
			var btd:BtDefend = new BtDefend();
			btd.pos = this.pos;
			btd.damage = this.damage;
			btd.leftHp = this.leftHp;
			btd.counterDmg = this.counterDmg;
			btd.counterLeft = this.counterLeft;
			btd.leftGauge = this.leftGauge;
			btd.aterleftHp = this.aterleftHp;
			btd.aterleftGauge = this.aterleftGauge;
			return btd;
		}
	}
}