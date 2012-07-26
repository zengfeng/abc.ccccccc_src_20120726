package game.core.hero
{
	import com.utils.ClassUtil;

	/**
	 * @author yangyiqiang
	 */
	public class VoHeroProp
	{
		
		public var id : int;
		
		/** 职业 **/
		public var job : int = 1;

		/** 等级 **/
		public var level : int = 1;

		/** 潜力 **/
		public var potential : int;
		
		/** 力量 **/
		public var strength : Number;

		/** 敏捷 **/
		public var quick : Number;

		/** 体魄 **/
		public var physique : Number;

		/** 生命 **/
		public var hp : Number;

		/** 生命附加 **/
		public var hp_add : Number;

		/** 生命附加百分比 **/
		public var hp_per : Number=0;

		/** 攻击 **/
		public var act : Number;

		/** 攻击附加 **/
		public var act_add : Number=0;

		/** 攻击附加百分比 **/
		public var act_per : Number=0;

		/** 防御 **/
		public var def : Number;

		/** 速度 **/
		public var speed : Number;

		/** 速度附加百分比 **/
		public var speed_per : Number=0;

		/** 命中 **/
		public var hit : Number;

		/** 闪避 **/
		public var dodge : Number;

		/** 暴击 **/
		public var crit : Number;

		/** 破击 **/
		public var pierce : Number;

		/** 反击 **/
		public var counter : Number;

		/** 高暴 **/
		public var  critmul : Number;

		/** 防破 **/
		public var  piercedef : Number;

		/** 高反 **/
		public var countermul : Number;

		/** 伤害增加（穿透） */
		public var harm : Number;

		/** 伤害减少 */
		public var predef : Number;

		/** 仙攻 **/
		public var magic_act : Number;

		/** 仙倍 **/
		public var magic_per : Number=0;

		/** 仙破 **/
		public var magic_pierce : Number;
		
		/** 蓄力上限 **/
		public var gauge_max : Number;

		/** 蓄力初始值 **/
		public var gauge_initial : Number;

		/** 蓄力速度 **/
		public var gauge_speed : Number=0;
		
		/** 技能消耗点数 **/
		public var gauge_expend : Number;

		/** 力量到攻击加成 **/
		public var strengthToAttack : Number;
		
		/** 敏捷到速度加成*/
		public var agilityToSpeed : Number;
		
		/**体魄到生命加成*/
		public var physiqueToHealth : Number;
		
		private var count : int = 0;
		
		public function parse(arr : Array) : void
		{
			if (!arr) return;
			id = arr[count++];
			
			job = arr.length > count ? arr[count++] : 0;
			level = arr.length > count ? arr[count++] : 1;
			potential = arr.length > count ? arr[count++] : 1;
			strength = arr.length > count ? arr[count++] : 0;
			quick = arr.length > count ? arr[count++] : 0;
			physique = arr.length > count ? arr[count++] : 0;
			hp = arr.length > count ? arr[count++] : 0;
			hp_add = arr.length > count ? arr[count++] : 0;
//			hp_per = arr.length > count ? arr[count++] : 0;
			act = arr.length > count ? arr[count++] : 0;
			act_add = arr.length > count ? arr[count++] : 0;
//			act_per = arr.length > count ? arr[count++] : 0;
			def = arr.length > count ? arr[count++] : 0;
			speed = arr.length > count ? arr[count++] : 0;
			speed_per = arr.length > count ? arr[count++] : 0;
			hit = arr.length > count ? arr[count++] : 0;
			dodge = arr.length > count ? arr[count++] : 0;
			crit = arr.length > count ? arr[count++] : 0;
			pierce = arr.length > count ? arr[count++] : 0;
			counter = arr.length > count ? arr[count++] : 0;
			critmul = arr.length > count ? arr[count++] : 0;
			piercedef = arr.length > count ? arr[count++] : 0;
			countermul = arr.length > count ? arr[count++] : 0;
			harm=arr.length > count ? arr[count++] : 0;
			predef=arr.length > count ? arr[count++] : 0;
			magic_act = arr.length > count ? arr[count++] : 0;
//			magic_per = arr.length > count ? arr[count++] : 0;
			magic_pierce= arr.length > count ? arr[count++] : 0;
			gauge_max=arr.length > count ? arr[count++] : 0;
			gauge_initial=arr.length > count ? arr[count++] : 0;
			gauge_expend=arr.length > count ? arr[count++] : 0;
			strengthToAttack=arr.length > count ? arr[count++] : 0;
			agilityToSpeed=arr.length > count ? arr[count++] : 0;
			physiqueToHealth=arr.length > count ? arr[count++] : 0;
		}
		
		//private var _propV : Array = ["strength", "quick", "physique"/** 三个基础属性 */, "hp", "act", "magic_act", "def", "speed", "gauge_initial", "hit", "dodge", "crit", "pierce", "counter"/** 11个二级属性 */, "hp_add", "act_add", "hp_per", "act_per", "speed_per", "magic_per"/** 二级属性附加*/, "predef", "magic_pierce", "critmul", "piercedef", "countermul", "harm", "gauge_initial"/** 特殊属性 */];
		public function clone() : VoHeroProp
		{
			var vo : VoHeroProp = new VoHeroProp();
			var _propV:Vector.<String>=ClassUtil.getClassVariable(vo);
			for each (var str:String in _propV)
			{
				vo[str] = this[str];
			}
			vo.id=this.id;
			return vo;
		}
	}
}
