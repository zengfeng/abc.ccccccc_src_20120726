package game.module.mapGroupBattle
{
	import log4a.Logger;

	import game.module.mapGroupBattle.elements.Battler;
	import game.module.mapGroupBattle.elements.SelfBattler;
	import game.module.mapGroupBattle.elements.Group;

	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-2
	 */
	public class GBData
	{
		/** 单例对像 */
		private static var _instance : GBData;

		/** 获取单例对像 */
		public static function get instance() : GBData
		{
			if (_instance == null)
			{
				_instance = new GBData(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public static var hasHighLevel : Boolean = false;
		public static var enInstall : Boolean = false;
		public static var installPlayerCount:int = 0;
		public static var MAX_INSTALL_PLAYER:int = 200;
		/** 组字典 */
		private var groupDic : Dictionary = new Dictionary();
		/** A组 */
		public var groupA : Group;
		/** B组 */
		public var groupB : Group;
		/** A组副本 */
		public var groupAc : Group;
		/** B组副本 */
		public var groupBc : Group;
		/** 自己 */
		public var selfBattler : SelfBattler;

		function GBData(singleton : Singleton) : void
		{
			singleton;
		}

		public function clearup() : void
		{
			var group : Group;
			for each (group in groupDic)
			{
				group.clearup();
			}
		}

		// ================
		// Group
		// ================
		/** 初始化组 */
		public function initGroup(level : int) : void
		{
			if (!groupDic[0])
			{
				var group : Group;
				group = new Group();
				group.id = 0;
				group.groupAB = GBConfig.GROUP_ID_A;
				group.name = "朱雀组";
				group.color = GBConfig.GROUP_COLOR_A;
				group.colorStr = GBConfig.GROUP_COLOR_STR_A;
				group.minLevel = 20;
				group.maxLevel = 69;
				groupDic[group.id] = group;

				group = new Group();
				group.id = 1;
				group.groupAB = GBConfig.GROUP_ID_B;
				group.name = "玄武组";
				group.color = GBConfig.GROUP_COLOR_B;
				group.colorStr = GBConfig.GROUP_COLOR_STR_B;
				group.minLevel = 20;
				group.maxLevel = 69;
				groupDic[group.id] = group;

				group = new Group();
				group.id = 2;
				group.groupAB = GBConfig.GROUP_ID_A;
				group.name = "青龙组";
				group.color = GBConfig.GROUP_COLOR_A;
				group.colorStr = GBConfig.GROUP_COLOR_STR_A;
				group.minLevel = 70;
				group.maxLevel = -1;
				groupDic[group.id] = group;

				group = new Group();
				group.id = 3;
				group.groupAB = GBConfig.GROUP_ID_B;
				group.name = "白虎组";
				group.color = GBConfig.GROUP_COLOR_B;
				group.colorStr = GBConfig.GROUP_COLOR_STR_B;
				group.minLevel = 70;
				group.maxLevel = -1;
				groupDic[group.id] = group;
			}

			if (level == GBConfig.LEVEL_1)
			{
				groupA = groupDic[0];
				groupB = groupDic[1];
				groupAc = groupDic[2];
				groupBc = groupDic[3];
			}
			else
			{
				groupA = groupDic[2];
				groupB = groupDic[3];
				groupAc = groupDic[0];
				groupBc = groupDic[1];
			}
		}

		/** 获取组,根据组Id */
		public function getGroup(groupId : int) : Group
		{
			return groupDic[groupId];
		}

		// ================
		// Battler
		// ================
		/** 获取Battler */
		public function getBattler(playerId : int) : Battler
		{
			if (!groupA) return null;
			var battler : Battler = groupA.getBattler(playerId);
			if (!battler) battler = groupB.getBattler(playerId);
			return battler;
		}

		/** 添加Battler */
		public function addBattler(battler : Battler) : void
		{
			var oldBattler : Battler = getBattler(battler.playerId);
			if (oldBattler)
			{
				Logger.info("陈治国发了两次玩家进入");
				if (battler != oldBattler)
				{
					Logger.info("强制退出之前的");
					removeBattler(battler.playerId);
				}
			}
			var group : Group = groupDic[battler.groupId];
			battler.group = group;
			group.addBattler(battler);
			if (enInstall) battler.install();
		}

		/** 移除Battler */
		public function removeBattler(playerId : int) : void
		{
			var battler : Battler = getBattler(playerId);
			if (battler)
			{
				battler.destory();
			}
		}

		// ================
		// 第一名
		// ================
		private var _firstPlayerCall : Function;

		public function set firstPlayerCall(fun : Function) : void
		{
			_firstPlayerCall = fun;
		}
	}
}
class Singleton
{
}