package game.module.battle.battleData
{
	public class BtRescued
	{
		public var side:int;         //仅跟发出技能者在同一方（己方）
		public var pos:int;          //位置
		public var addHp:int = 0;    //加血或者吸血值
		public var leftHp:uint;      //加血后剩余血量

		
		public function BtRescued()
		{
		}
		
		public function clone():BtRescued
		{
			var btd:BtRescued = new BtRescued();
			btd.side = this.side;
			btd.pos = this.pos;
			btd.addHp = this.addHp;
			btd.leftHp = this.leftHp;
			return btd;
		}
	}
}