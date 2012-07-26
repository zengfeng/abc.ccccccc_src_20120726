package game.core.user
{
	import log4a.Logger;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class ExperienceConfig
	{
		// =====================
		// 属性
		// =====================
		/** 升级经验表 **/
		private static var _expDict : Dictionary = new Dictionary();

		// =====================
		// 方法
		// =====================
		public static function getUpgradeExperience(targetLevel : uint) : uint
		{
			var exp : ExperienceVO = _expDict[targetLevel];

			if (!exp)
			{
				Logger.error("经验表读取错误！");
				return 0;
			}

			return exp.upExp;
		}
		
		public static function getTotalExpExperience(targetLevel : uint) :Number
		{
			var exp : ExperienceVO = _expDict[targetLevel];

			if (!exp)
			{
				Logger.error("经验表读取错误！");
				return 0;
			}

			return exp.totalExp;
		}
		

		public static function getPracticeExperience(currentLevel : uint) : uint
		{
			var exp : ExperienceVO = _expDict[currentLevel];

			if (!exp)
			{
				Logger.error("经验表读取错误！");
				return 0;
			}
			return exp.practiceExp;
		}

		public static function parse(value : Array) : void
		{
			for each (var arr:Array in value)
			{
				var vo : ExperienceVO = new ExperienceVO();
				vo.parse(arr);
				_expDict[vo.level] = vo;
			}
		}
	}
}

