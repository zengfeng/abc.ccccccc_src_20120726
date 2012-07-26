package game.module.monsterPot
{
	/**
	 * @author jian
	 */
	public class MonsterCountryVO
	{
		// ===============================================================
		// 定义
		// ===============================================================
		public static const IDLE : int = 0;
		public static const SUMMONED : int = 1;
		public static const CORPSE : int = 2;
		// ===============================================================
		// 属性
		// ===============================================================
		// ------------------------------------------------
		// 国ID
		public var countryId : uint;
		// 国名
		public var countryName : String;
		// 开放等级
		public var openLevel : uint;
		// 简介
		public var description : String;
		//掉落物品
		public var dropGoods : String;
		// 怪物ID
		public var monsterAvatarIds : Vector.<uint> = new Vector.<uint>();
		// ------------------------------------------------
		// 剩余重置次数
		public var goldResetCount : uint = 0;
		public var freeResetCount : uint = 0;
		// ------------------------------------------------
		// 已开启
		public var opened : Boolean = false;
		// 通关次数
		public var passCount : int = 0;
		// 下一个怪物
		public var nextMonsterId : int = 1;
		// 开放的怪物
		public var openedMonsterId : int = 0;
		// 当前怪物
		public var currentMonsterId : int = 0;
		// 状态
		public var state : int = IDLE;
		// 奖品
		public var stuffItems : Vector.<uint>;

		// ===============================================================
		// 方法
		// ===============================================================
		public function toString() : String
		{
			return countryName + "(" + countryId + ")" + (opened ? "已开启" : "未开启") + "\r" + "开放怪物" + openedMonsterId + "\r" + "下一个挑战怪物" + nextMonsterId + "\r" + "当前怪物ID" + currentMonsterId + "\r" + "state" + state + "\r\r" + (stuffItems ? "奖励品个数" + stuffItems.length : "");
		}

		public function getAvatarIdByMonsterId(monsterId : int) : int
		{
			return monsterAvatarIds[monsterId - 1];
		}
	}
}
