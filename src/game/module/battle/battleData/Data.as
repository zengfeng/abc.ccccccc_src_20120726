package game.module.battle.battleData
{
	public class Data
	{
		public  var x:int = 0;
		public  var y:int = 0;            //沙盘坐标点
		public  var factor:Number = 0.0;   //对该位置效果系数
		public  var skilltype:Number = 0.0;    //效果类型
		
		public function Data(p:int = 0, t:int = 0, f:Number = 0.0, s:Number = 0.0)
		{
			x = p;
			y = t;
			factor = f;
			skilltype = s;
		}
		public function clone():Data
		{
			var tmp:Data = new Data();
			tmp.x = x;
			tmp.y = y;
			tmp.factor = factor;
			tmp.skilltype = skilltype;
			return tmp;
		}
	}
}