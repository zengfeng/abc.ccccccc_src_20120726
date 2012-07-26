package game.module.battle.view
{
	import game.module.battle.battleData.BtBuffProcess;
	import game.module.battle.battleData.BtInit;
	import game.module.battle.battleData.BtInitProcess;
	import game.module.battle.battleData.BtProcess;
	/**
	 * @author zhengyuhang
	 */
	public class NewBattleSystem
	{
		
//===========================================
//    开始搞  首先初始化数据  获取方法
//===========================================	
		public var BtBuffData : Vector.<BtBuffProcess> = new Vector.<BtBuffProcess>();
		public var BtData : Vector.<BtProcess> = new Vector.<BtProcess>();
		public var BtInitData : Vector.<BtInit> = new Vector.<BtInit>();		
		
		public function ReloadBttleData() : void 
		{
			var i : uint;
			BtBuffProcess.data.splice(0, BtBuffProcess.data.length);
			BtProcess.data.splice(0, BtProcess.data.length);
			for (i = 0; i < BtBuffData.length; ++i) 
			{
				BtBuffProcess.data.push(BtBuffData[i]);
			}

			for (i = 0; i < BtData.length; ++i) 
			{
				BtProcess.data.push(BtData[i]);
			}

			for (i = 0; i < BtInitData.length; ++i) 
			{
				BtInitProcess.data.push(BtInitData[i]);
			}
		}
		
		
		
		
	
		
	}
}
