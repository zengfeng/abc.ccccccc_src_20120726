package game.core.item.prop
{
	import com.utils.ClassUtil;

	/**
	 * @author yangyiqiang
	 */
	public class ItemProp
	{
		// =====================
		// 定义
		// =====================
		public static const ALL_KEYS : Array = ["strength", "quick", "physique", "hp", "hp_add", "hp_per", "act", "act_add", "act_per", "def", "speed", "speed_per", "hit", "dodge", "crit", "pierce", "counter", "critmul", "piercedef", "countermul", "harm", "predef", "magic_act", "magic_per", "magic_pierce", "gauge_initial", "gauge_speed", "strengthToAttack", "agilityToSpeed", "physiqueToHealth"];
		// =====================
		// 属性
		// =====================
		public var id : int = 0;
		// 力量
		public var strength : Number = 0;
		// 敏捷
		public var quick : Number = 0;
		/** 体魄 **/
		public var physique : Number = 0;
		/** 生命 **/
		public var hp : Number = 0;
		/** 生命附加 **/
		public var hp_add : Number = 0;
		/** 生命附加百分比 **/
		public var hp_per : Number = 0;
		/** 攻击 **/
		public var act : Number = 0;
		/** 攻击附加 **/
		public var act_add : Number = 0;
		/** 攻击附加百分比 **/
		public var act_per : Number = 0;
		/** 防御 **/
		public var def : Number = 0;
		/** 速度 **/
		public var speed : Number = 0;
		/** 速度附加百分比 **/
		public var speed_per : Number = 0;
		/** 命中 **/
		public var hit : Number = 0;
		/** 闪避 **/
		public var dodge : Number = 0;
		/** 暴击 **/
		public var crit : Number = 0;
		/** 破击 **/
		public var pierce : Number = 0;
		/** 反击 **/
		public var counter : Number = 0;
		/** 高暴 **/
		public var  critmul : Number = 0;
		/** 防破 **/
		public var  piercedef : Number = 0;
		/** 高反 **/
		public var countermul : Number = 0;
		/** 伤害增加（穿透） */
		public var harm : Number = 0;
		/** 伤害减少 */
		public var predef : Number = 0;
		/** 仙攻 **/
		public var magic_act : Number = 0;
		/** 仙倍 **/
		public var magic_per : Number = 0;
		/** 仙破 **/
		public var magic_pierce : Number = 0;
		/** 蓄力初始值 **/
		public var gauge_initial : Number = 0;
		/** 蓄力速度 **/
		public var gauge_speed : Number = 0;
		/** 力量到攻击加成 **/
		public var strengthToAttack : Number = 0;
		/** 敏捷到速度加成*/
		public var agilityToSpeed : Number = 0;
		/**体魄到生命加成*/
		public var physiqueToHealth : Number = 0;
		private var count : int = 0;

		// =====================
		// Getter/Setter
		// =====================
		public function get allKeys() : Array
		{
			return ALL_KEYS;
		}

		public function parse(arr : Array) : void
		{
			if (!arr) return;
			id = arr[count++];

			for each (var key:String in allKeys)
			{
				var val : Number = arr.length > count ? arr[count++] : 0;

				this[key] = val;
			}
		}

		public function clone() : ItemProp
		{
			var vo : ItemProp = new ItemProp();
			var variables : Vector.<String>=ClassUtil.getClassVariable(this);
			for each (var str:String in variables)
			{
				vo[str] = this[str];
			}
			return vo;
		}

		public function plus(prop : ItemProp) : void
		{
			if (!prop)
			{
				// trace("空物品属性！！");
				return;
			}

			for each (var key:String in allKeys)
			{
				var val : Number = prop[key];

				if (isNaN(val))
					continue;

				this[key] += val;
			}
		}

		public function minus(prop : ItemProp) : void
		{
			if (!prop)
			{
				trace("空物品属性！！");
				return;
			}

			for each (var key:String in allKeys)
			{
				var val : Number = prop[key];

				if (isNaN(val))
					continue;

				this[key] -= val;
			}
		}

		public function get effectiveKeys() : Array
		{
			var keys : Array = [];
			for each (var key:String in allKeys)
			{
				if (this[key] != 0)
				{
					keys.push(key);
				}
			}

			return keys;
		}
	}
}
