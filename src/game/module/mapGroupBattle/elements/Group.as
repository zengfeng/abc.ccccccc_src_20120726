package game.module.mapGroupBattle.elements
{
	import game.module.mapGroupBattle.GBControl;
	import game.module.mapGroupBattle.uis.UiGroup;
	import game.module.mapGroupBattle.uis.UiPlayerList;

	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-2
	 */
	public class Group
	{
		/** ID */
		public var id : uint;
		/** 组AB */
		public var groupAB : int = 1;
		/** 组名 */
		public var name : String = "组名";
		/** 颜色 */
		public var color : int = 0xFE9966;
		/** 颜色字符串 */
		public var colorStr : String = "#FE9966";
		/** 最小等级 */
		public var minLevel : int = 1;
		/** 最大等级 */
		public var maxLevel : int = 40;
		/** 积分 */
		public var _score : uint = 0;
		/** 玩家人数 */
		public var _count : uint = 0;
		public var dic : Dictionary = new Dictionary();
		public var uiList : UiPlayerList;
		public var uiGroup : UiGroup;

		public function addBattler(battler : Battler) : void
		{
			if (getBattler(battler.playerId)) return;
			dic[battler.playerId] = battler;
			++count;
		}

		public function removeBattler(playerId : int) : void
		{
			delete dic[playerId];
			--count;
		}

		public function getBattler(playerId : int) : Battler
		{
			return dic[playerId];
		}

		public function clearup() : void
		{
			var keyArr : Array = [];
			var key : *;
			for (key in dic)
			{
				keyArr.push(key);
			}

			var battler : Battler;
			while (keyArr.length > 0)
			{
				key = keyArr.shift();
				battler = dic[key];
				battler.destory(true);
				delete dic[key];
			}
		}


		/** 积分 */
		public function get score() : uint
		{
			return _score;
		}

		public function set score(score : uint) : void
		{
			_score = score;
			if (uiList)
			{
				GBControl.instance.uc.centerMain.setScore(score, id);
			}
		}

		/** 玩家人数 */
		public function get count() : uint
		{
			return _count;
		}

		public function set count(value : uint) : void
		{
			_count = value;

			if (uiList)
			{
				uiList.setPlayerCount(value);
			}
		}
	}
}
