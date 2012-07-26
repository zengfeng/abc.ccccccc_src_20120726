package game.core.data
{
	import game.manager.RSSManager;
	import game.module.quest.VoMonster;


	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-12
	 */
	public class ParseMonsterSkillConfig
	{
		/** 单例对像 */
		private static var _instance : ParseMonsterSkillConfig;

		/** 获取单例对像 */
		static public function get instance() : ParseMonsterSkillConfig
		{
			if (_instance == null)
			{
				_instance = new ParseMonsterSkillConfig(new Singleton());
			}
			return _instance;
		}

		public function ParseMonsterSkillConfig(singleton : Singleton)
		{
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public function parseConfig(data : Array) : void
		{
			var rssManager : RSSManager = RSSManager.getInstance();
			var itemData : Array;
			var monsterId : int;
			var voMonster : VoMonster;
			var skillId : int;
			while (data.length > 0)
			{
				itemData = data.shift();
				monsterId = itemData[0];
				voMonster = rssManager.getMosterById(monsterId);
				if (!voMonster) continue;
				skillId = itemData[1];
				if (voMonster.skills.indexOf(skillId) == -1)
				{
					voMonster.skills.push(skillId);
				}
			}
		}
	}
}
class Singleton
{
}