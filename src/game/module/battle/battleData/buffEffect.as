package game.module.battle.battleData
{
	public class buffEffect
	{
		public var bfside:int;          //来自哪一方
		public var btoside:int;          //作用域哪一方
		//public var bpos:int;          //pos
		public var bfpos:int;          //来自的pos
		public var btpos:int;          //作用的pos 
		public var btype:int;          //效果种类,减速
		public var bround:int;         //作用轮数
		public var bvalue:Number;      //作用值
		public var bfirst:Boolean;     //是否第一次
		public var bskillid:int;       //skillid
		public var bskillab:int;           //技能一或者技能二
		public function buffEffect()
		{
		}
	}
}