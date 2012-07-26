package game.module.battle.battleData
{
	public class BtInit
	{
		public var pside:uint;
		public var ppos:uint;
		public var pHp:uint;
		public var pGauge:uint;
		public var skillName:String = "";
		
		public function BtInit()
		{
		}
		
		public function clone():BtInit
		{
			var bt:BtInit = new BtInit();
			bt.pside = this.pside;
			bt.ppos = this.ppos;
			bt.pHp = this.pHp;
			bt.pGauge = this.pGauge;
			return bt;
		}
	}
}