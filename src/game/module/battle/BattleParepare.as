package game.module.battle
{
	import game.module.battle.battleData.BattleSimulator;
	import game.module.battle.battleData.FighterInfo;
	public class BattleParepare
	{
		public function BattleParepare()
		{
		}
		
		public function assault(player:Player):void
		{
			var _winner:int = 0;
			var bsim:BattleSimulator = new BattleSimulator(this as Player, player, 1);
			_winner = bsim.start();
			if(_winner == 0)
				b_Result = false;
			else if(_winner == 1)
				b_Result = true;
		}
		
		public function attackNpc( npcId:uint ):void
		{
			
		}
		
		public function put(bsim:BattleSimulator, side:uint):void
			
		{
			var i:int;
			for(i = 0; i < this.fighterInfoArr.length; ++i)
			{
				bsim.newFighter(this.fighterInfoArr[i].pInfo2, fighterInfoArr[i].weaponId, fighterInfoArr[i].skillId, side, fighterInfoArr[i].pos, fighterInfoArr[i].name, fighterInfoArr[i].fID, fighterInfoArr[i].job);		
			}		
		}
		
		public function putNpc( bsim:BattleSimulator, side:uint, pos:uint, npcId:uint, potential:uint ):void
		{
			
		}
		
		public function putFighterInfoArr(arr:Vector.<FighterInfo>):void
		{
			fighterInfoArr = arr;
		}
		
		public function getPropInfo2BaseByPos(pos:uint):FighterInfo    //根据位置获得属性
		{
			var i:int = 0;
			for(i = 0; i < fighterInfoArr.length; ++i)
			{
				if(fighterInfoArr[i].pos == pos)
				{
					return fighterInfoArr[i];
				}
			}
			return null;
		}
		
		public function getBattleResult():Boolean
		{
			if(bChangeSide)
				return !b_Result;
			else
				return b_Result;
		}
		
		public function setbChangeSide(bc:Boolean):void
		{
			bChangeSide = bc;
		}
		
		private var bChangeSide:Boolean = false;
		private var fighterInfoArr:Vector.<FighterInfo> = new Vector.<FighterInfo>();              //战士信息列表
		private var b_Result:Boolean = false;  //战斗结果
		// 战士列表
	}
}