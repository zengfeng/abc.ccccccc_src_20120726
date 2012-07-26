package game.module.battle.battleData
{
	public class BtStatus
	{
		public var atkorBackatk:int = 0;  //来自攻击或者是反击 0:攻击 1:反击 2:系统（初始状态）
		public var sideFrom:int;      //来自友方还是敌方
		public var toside:int;        //触发效果的side
		public var fpos:uint;         //来自位置
		public var tpos:uint;         //作用位置
		public var skillid:int;     //技能id
		public var type:int;          //类型(0:缓缓取消，取消 1:持续加上  2：加上后缓动取消)
		public var data:int = 0;      //数据
		public var letDie:int = 0;    //是否造成死亡
		public var skillab:int = 0;   //技能一或者二
		
		public function BtStatus()
		{
		}
		
		
		public function clone():BtStatus
		{
			var bs:BtStatus = new BtStatus();
			bs.atkorBackatk = this.atkorBackatk;
			bs.sideFrom = this.sideFrom;
			bs.toside = this.toside;
			bs.fpos = this.fpos;
			bs.tpos = this.tpos;
			bs.skillid = this.skillid;
			bs.type = this.type;
			bs.data = this.data;
			bs.letDie = this.letDie;
			bs.skillab = this.skillab;
			return bs;
		}
	}
}