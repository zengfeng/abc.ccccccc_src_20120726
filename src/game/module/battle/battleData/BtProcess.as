package game.module.battle.battleData
{
	public final class BtProcess
	{
		public static var data:Vector.<BtProcess> = new Vector.<BtProcess>();
		public static var selfList:Vector.<FighterInfo>;
		public static var enemyList:Vector.<FighterInfo>;
		
		
		//可能需要标志
		
		//攻击信息
		public var oneAtkInfo:BtOneAtk;
		
		//被攻击者列表
		public var defendList:Array = [];
		
		//状态改变列表
		public var SChangeList:Array = [];
		
		//被帮助者列表
		public var rescuedList:Array = [];
		
		//被帮助者状态改变
		public var resuedSChangeList:Array = [];
		
		
		public  function BtProcess()
		{
			
		}
		
		public function clone():BtProcess
		{
			var i:int = 0;
			var btpr:BtProcess = new BtProcess();
			if(this.oneAtkInfo != null)
				btpr.oneAtkInfo = this.oneAtkInfo.clone();
			for(i = 0; i < defendList.length; ++i)
			{
				btpr.defendList.push(this.defendList[i].clone() as BtDefend);
			}
			
			for(i = 0 ; i < SChangeList.length; ++i)
			{
				btpr.SChangeList.push(this.SChangeList[i].clone() as BtStatus);
			}
			
			for(i = 0; i < rescuedList.length; ++i)
			{
				btpr.rescuedList.push(this.rescuedList[i].clone() as BtRescued);
			}
			
			for(i = 0; i < resuedSChangeList.length; ++i)
			{
				btpr.resuedSChangeList.push(this.resuedSChangeList[i].clone() as BtStatus);
			}
			return btpr;
		}
		
		public static function ChangeSide():void
		{
			var i:int;
			var j:int;
			var publicInfo:FighterInfo;
			var selfClone : Vector.<FighterInfo> = new Vector.<FighterInfo>;
			var enemyClone : Vector.<FighterInfo> = new Vector.<FighterInfo>;
			for(i = 0; i < selfList.length; ++i)
			{	
				publicInfo = selfList[i] as FighterInfo;
				publicInfo.side = publicInfo.side ? 0 : 1;
				selfClone.push(publicInfo);
			}
			
			for(i = 0; i < enemyList.length; ++i)
			{	
				publicInfo = enemyList[i] as FighterInfo;
				publicInfo.side = publicInfo.side ? 0 : 1;
				enemyClone.push(publicInfo);
			}
			
			selfList.splice(0, selfList.length);
			for(i = 0; i < selfClone.length; ++i)
			{
				selfList.push(selfClone[i] as FighterInfo);
			}
			
			enemyList.splice(0, enemyList.length);
			for( i = 0; i < enemyClone.length; ++i)
			{
				enemyList.push(enemyClone[i] as FighterInfo);
			}
			
				
			//selfList =  ;
			//enemyList = ;
			var btpr:BtProcess = null
			for(i = 0; i < BtProcess.data.length; ++i)
			{
				btpr = BtProcess.data[i] as BtProcess;
				if(btpr == null)
					continue;
				if(btpr.oneAtkInfo != null)
					btpr.oneAtkInfo.atkerSide = btpr.oneAtkInfo.atkerSide ? 0 : 1;
//				for(i = 0; i < defendList.length; ++i)
//				{
//					(btpr.defendList[i] as BtDefend).
//				}
				
				for(j = 0 ; j < btpr.SChangeList.length; ++j)
				{
					(btpr.SChangeList[j] as BtStatus).sideFrom = (btpr.SChangeList[j] as BtStatus).sideFrom ? 0 : 1;
					(btpr.SChangeList[j] as BtStatus).toside = (btpr.SChangeList[j] as BtStatus).toside ? 0 : 1;
				}
				
				for(j = 0; j < btpr.rescuedList.length; ++j)
				{
					(btpr.rescuedList[j] as BtRescued).side = (btpr.rescuedList[j] as BtRescued).side ? 0 : 1;
				}
				
				for(j = 0; j < btpr.resuedSChangeList.length; ++j)
				{
					(btpr.resuedSChangeList[j] as BtStatus).sideFrom = (btpr.resuedSChangeList[j] as BtStatus).sideFrom ? 0 : 1;
					(btpr.resuedSChangeList[j] as BtStatus).toside = (btpr.resuedSChangeList[j] as BtStatus).toside ? 0 : 1;
				}
			}
			
			//BtInitProcess
			for(i = 0; i < BtInitProcess.data.length; ++i)
			{
				(BtInitProcess.data[i] as BtInit).pside = (BtInitProcess.data[i] as BtInit).pside ? 0 : 1;
			}
			
			//BtBuff
			var btBuf : BtBuffProcess;
			var bs : BtStatus;
			for (i = 0; i < BtBuffProcess.data.length; ++i ) {
				btBuf = BtBuffProcess.data[i];
				for (j = 0; j < btBuf.StatusList.length; ++j) {
					bs = btBuf.StatusList[j] as BtStatus
					bs.sideFrom = bs.sideFrom ? 0 : 1;
					bs.toside = bs.toside ? 0 : 1;
				}
			}
		}
	}
}