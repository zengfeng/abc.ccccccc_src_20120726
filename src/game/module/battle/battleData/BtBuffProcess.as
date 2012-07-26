package game.module.battle.battleData
{
	public final class BtBuffProcess
	{
		public static var data:Vector.<BtBuffProcess> = new Vector.<BtBuffProcess>();
		//状态列表
		public var StatusList:Array = [];
		public function BtBuffProcess()
		{
		}
		
		public function clone():BtBuffProcess
		{
			var btbufp:BtBuffProcess = new BtBuffProcess();
			for(var i:int = 0; i < this.StatusList.length; ++i)
			{
				btbufp.StatusList.push(this.StatusList[i].clone() as BtStatus);
			}
			return btbufp;
		}
		
	}
}