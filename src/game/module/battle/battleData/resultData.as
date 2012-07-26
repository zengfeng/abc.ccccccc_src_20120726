package game.module.battle.battleData
{
	public class resultData
	{
		public function resultData(e:uint, d:uint, arr:Array)
		{
			this.exp = e;
			this.dmg = d;
			this.rewardlist = arr;
			
		}
		
		public var dmg:uint;
		public var exp:uint;
		public var rewardlist:Array;
	}
}