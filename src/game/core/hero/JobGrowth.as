package game.core.hero
{
	/**
	 * @author yangyiqiang
	 */
	public final class JobGrowth
	{
		/** 1:金刚 2:修罗 3 天师*/
		private var _id : uint;

		/** 力量成长 **/
		public var strengthGrowth : Number=0;

		/** 敏捷成长 **/
		public var agilityGrowth : Number=0;

		/** 体魄成长 **/
		public var physiqueGrowth : Number=0;

		/** 仙攻成长 **/
		public var spellDamGrowth : Number=0;

		/** 生命成长 **/
		public var healthGrowth : Number=0;

		/** 攻击成长 **/
		public var attackGrowth : Number=0;

		/** 力量转攻击力 **/
		public var strengthToAttack : Number;

		/** 力量转反击 **/
		public var strengthToCounter : Number;

		/** 敏捷转速度 **/
		public var agilityToSpeed : Number;

		/** 敏捷转闪避 **/
		public var agilityToDodge : Number;

		/** 体魄转生命 **/
		public var physiqueToHealth : Number;

		/** 体魄转防御 **/
		public var physiqueToDefend : Number;
		
		/** 弱化系数 **/
		public var weakenfactor : Number;
		
		/** 暴击系数 **/
		public var critfactor:Number;
		
		/** 反击伤害系数 **/
		public var backatkfactor:Number;
		
		/** 防御控制系数 **/
		public var defendcontrol:Number;

		public function JobGrowth(id : int)
		{
			_id = id;
		}

		public function get id() : int
		{
			return _id;
		}

		public function toString() : String
		{
			return "strengthGrowth"+strengthGrowth+"agilityGrowth"+agilityGrowth;
		}
	}
}
